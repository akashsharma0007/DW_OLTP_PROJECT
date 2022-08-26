CREATE TABLE FactSales (
-- Should we create a surrogate key?
CustomerKey NUMBER(10) NOT NULL,
LocationKey NUMBER(10) NOT NULL,
ProductKey NUMBER(10) NOT NULL,
SalespersonKey NUMBER(10) NOT NULL,
DateKey NUMBER(8) NOT NULL,
Quantity NUMBER(4) NOT NULL,
UnitPrice NUMBER(18,2) NOT NULL,
TaxRate NUMBER(18,3) NOT NULL,
TotalBeforeTax NUMBER(18,2) NOT NULL,
TotalAfterTax NUMBER(18,2) NOT NULL
);
-- DROP TABLE FactSales;
CREATE INDEX IX_FactSales_CustomerKey ON FactSales(CustomerKey);
CREATE INDEX IX_FactSales_CityKey ON FactSales(LocationKey);
CREATE INDEX IX_FactSales_ProductKey ON FactSales(ProductKey);
CREATE INDEX IX_FactSales_SalespersonKey ON FactSales(SalespersonKey);
CREATE INDEX IX_FactSales_DateKey ON FactSales(DateKey);



CREATE TABLE DimDate (
DateKey NUMBER(10) NOT NULL,
DateValue DATE NOT NULL,
CYear NUMBER(10) NOT NULL,
CQtr NUMBER(1) NOT NULL,
CMonth NUMBER(2) NOT NULL,
DayNo NUMBER(2) NOT NULL,
StartOfMonth DATE NOT NULL,
EndOfMonth DATE NOT NULL,
MonthName VARCHAR2(9) NOT NULL,
DayOfWeekName VARCHAR2(9) NOT NULL,
CONSTRAINT PK_DimDate PRIMARY KEY ( DateKey )
);
--
CREATE OR REPLACE PROCEDURE DimDate_Load ( DateValue IN DATE )
IS
BEGIN
INSERT INTO DimDate
SELECT
EXTRACT(YEAR FROM DateValue) * 10000 + EXTRACT(Month FROM DateValue) * 100 + EXTRACT(Day FROM DateValue) DateKey
,DateValue DateValue
,EXTRACT(YEAR FROM DateValue) CYear
,CAST(TO_CHAR(DateValue, 'Q') AS INT) CQtr
,EXTRACT(Month FROM DateValue) CMonth
,EXTRACT(Day FROM DateValue) "Day"
,TRUNC(DateValue) - (TO_NUMBER (TO_CHAR(DateValue,'DD')) - 1) StartOfMonth
,ADD_Months(TRUNC(DateValue) - (TO_NUMBER(TO_CHAR(DateValue,'DD')) - 1), 1) -1 EndOfMonth
,TO_CHAR(DateValue, 'MONTH') MonthName
,TO_CHAR(DateValue, 'DY') DayOfWeekName
FROM dual;
END;


select * from dimdate;

EXECUTE DimDate_Load('2017-12-01');


BEGIN
   DimDate_Load('2017-12-02');
END;
COMMIT;
-----------------------------
----------------------------TYPE 1 SCD----------------
--DROP TABLE DimLocation;
CREATE TABLE DimLocation(
LocationKey NUMBER(10),
CityName nvarchar2(50) NULL,
StateProvinceCode NVARCHAR2(5) NULL,
StateProvName NVARCHAR2(50) NULL,
CountryName NVARCHAR2(60) NULL,
CountryFormalName NVARCHAR2(60) NULL,
CONSTRAINT PK_DimLocation PRIMARY KEY ( LocationKey )
);
-------------------------------
--------------------------TYPE 2
CREATE TABLE DimProducts(
ProductKey NUMBER(10),
ProductName NVARCHAR2(100) NULL,
ProductColour NVARCHAR2(20) NULL,
ProductBrand NVARCHAR2(50) NULL,
ProductSize NVARCHAR2(20) NULL,
StartDate DATE NOT NULL,
EndDate DATE NULL,
CONSTRAINT PK_DimProducts PRIMARY KEY ( ProductKey )
);
----------------------------------------
------------------------TYPE 1
CREATE TABLE DimSalesPeople(
SalespersonKey NUMBER(10),
FullName NVARCHAR2(50) NULL,
PreferredName NVARCHAR2(50) NULL,
LogonName NVARCHAR2(50) NULL,
PhoneNumber NVARCHAR2(20) NULL,
FaxNumber NVARCHAR2(20) NULL,
EmailAddress NVARCHAR2(256) NULL,
CONSTRAINT PK_DimSalesPeople PRIMARY KEY (SalespersonKey )
);
-----------------------------
----------------------------------TYPE 2 SCD------------------
CREATE TABLE DimCustomers(
CustomerKey NUMBER(10),
CustomerName NVARCHAR2(100) NULL,
CustomerCategoryName NVARCHAR2(50) NULL,
DeliveryCityName NVARCHAR2(50) NULL,
DeliveryStateProvCode NVARCHAR2(5) NULL,
DeliveryCountryName NVARCHAR2(50) NULL,
PostalCityName NVARCHAR2(50) NULL,
PostalStateProvCode NVARCHAR2(5) NULL,
PostalCountryName NVARCHAR2(50) NULL,
StartDate DATE NOT NULL,
EndDate DATE NULL,
CONSTRAINT PK_DimCustomers PRIMARY KEY ( CustomerKey )
);
------------------------------
------------------------------------
CREATE TABLE Customers_Stage (
CustomerName NVARCHAR2(100),
CustomerCategoryName NVARCHAR2(50),
DeliveryCityName NVARCHAR2(50),
DeliveryStateProvinceCode NVARCHAR2(5),
DeliveryStateProvinceName NVARCHAR2(50),
DeliveryCountryName NVARCHAR2(50),
DeliveryFormalName NVARCHAR2(60),
PostalCityName NVARCHAR2(50),
PostalStateProvinceCode NVARCHAR2(5),
PostalStateProvinceName NVARCHAR2(50),
PostalCountryName NVARCHAR2(50),
PostalFormalName NVARCHAR2(60)
);
----------------------------------
--------------------------------
SET SERVEROUT ON;

CREATE OR REPLACE PROCEDURE Customers_Extract 
IS
    RowCt NUMBER(10):=0;
    v_sql VARCHAR(255) := 'TRUNCATE TABLE wwidmuser.Customers_Stage DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;

    INSERT INTO wwidmuser.Customers_Stage
    WITH CityDetails AS (
        SELECT ci.CityID,
               ci.CityName,
               sp.StateProvinceCode,
               sp.StateProvinceName,
               co.CountryName,
               co.FormalName
        FROM wwidbuser.Cities ci
        LEFT JOIN wwidbuser.StateProvinces sp
            ON ci.StateProvinceID = sp.StateProvinceID
        LEFT JOIN wwidbuser.Countries co
            ON sp.CountryID = co.CountryID 
    )

SELECT cust.CustomerName,
           cat.CustomerCategoryName,
           dc.CityName,
           dc.StateProvinceCode,
           dc.StateProvinceName,
           dc.CountryName,
           dc.FormalName,
           pc.CityName,
           pc.StateProvinceCode,
           pc.StateProvinceName,
           pc.CountryName,
           pc.FormalName
    FROM wwidbuser.Customers cust
    LEFT JOIN wwidbuser.CustomerCategories cat
        ON cust.CustomerCategoryID = cat.CustomerCategoryID
    LEFT JOIN CityDetails dc
        ON cust.DeliveryCityID = dc.CityID
    LEFT JOIN CityDetails pc
        ON cust.PostalCityID = pc.CityID;

    RowCt := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Number of employees added: ' || TO_CHAR(SQL%ROWCOUNT));
END;




SET SERVEROUT ON;
TRUNCATE TABLE customers_stage;
EXECUTE Customers_Extract;
SELECT * FROM customers_stage;

/*
create or replace PROCEDURE Customers_Extract 
IS
    RowCt NUMBER(10);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE Customers_Stage';

    INSERT INTO Customers_Stage
    WITH CityDetails AS (
        SELECT ci.CityID,
               ci.CityName,
               sp.StateProvinceCode,
               sp.StateProvinceName,
               co.CountryName,
               co.FormalName
        FROM dwuser.Cities ci
        LEFT JOIN dwuser.StateProvinces sp
            ON ci.StateProvinceID = sp.StateProvinceID
        LEFT JOIN dwuser.Countries co
            ON sp.CountryID = co.CountryID 
    )
    SELECT cust.CustomerName,
           cat.CustomerCategoryName,
           dc.CityName,
           dc.StateProvinceCode,
           dc.StateProvinceName,
           dc.CountryName,
           dc.FormalName,
           pc.CityName,
           pc.StateProvinceCode,
           pc.StateProvinceName,
           pc.CountryName,
           pc.FormalName
    FROM dwuser.Customers cust
    LEFT JOIN dwuser.CustomerCategories cat
        ON cust.CustomerCategoryID = cat.CustomerCategoryID
    LEFT JOIN CityDetails dc
        ON cust.DeliveryCityID = dc.CityID
    LEFT JOIN CityDetails pc
        ON cust.PostalCityID = pc.CityID;

    RowCt := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Number of employees added: ' || TO_CHAR(SQL%ROWCOUNT));
END;
*/



CREATE TABLE Orders_Stage (
    OrderDate       DATE,
    Quantity        NUMBER(3),
    UnitPrice       NUMBER(18,2),
    TaxRate         NUMBER(18,3),
    CustomerName    NVARCHAR2(100),
    CityName        NVARCHAR2(50),
    StateProvinceName   NVARCHAR2(50),
    CountryName     NVARCHAR2(60),
    StockItemName   NVARCHAR2(100),
    LogonName       NVARCHAR2(50)
);

CREATE OR REPLACE PROCEDURE Orders_Extract
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE wwidmuser.Orders_Stage DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    
    INSERT INTO wwidmuser.Orders_Stage 
    WITH CityDetails AS (
        SELECT ci.CityID,
               ci.CityName,
               sp.StateProvinceCode,
               sp.StateProvinceName,
               co.CountryName,
               co.FormalName
        FROM wwidbuser.Cities ci
        LEFT JOIN wwidbuser.StateProvinces sp
            ON ci.StateProvinceID = sp.StateProvinceID
        LEFT JOIN wwidbuser.Countries co
            ON sp.CountryID = co.CountryID 
    )
SELECT o.OrderDate
        ,ol.Quantity
        ,ol.UnitPrice
        ,ol.TaxRate
        ,c.CustomerName
        ,dc.cityname
        ,dc.stateprovincename
        ,dc.countryname
        ,stk.StockItemName
        ,p.LogonName
    FROM wwidbuser.Orders o
        LEFT JOIN wwidbuser.OrderLines ol
            ON o.OrderID = ol.OrderID
        LEFT JOIN wwidbuser.customers c
            ON o.CustomerID = c.CustomerID
        LEFT JOIN CityDetails dc
            ON c.DeliveryCityID = dc.CityID
        LEFT JOIN wwidbuser.stockitems stk
            ON ol.Stockitemid = stk.StockItemID
        LEFT JOIN wwidbuser.People p
            ON o.salespersonpersonid = p.personid AND IsSalesPerson = 1;

RowCt := SQL%ROWCOUNT;
    IF sql%notfound THEN
       dbms_output.put_line('No records found. Check with source system.');
    ELSIF sql%found THEN
       dbms_output.put_line(TO_CHAR(RowCt) ||' Rows have been inserted!');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
       dbms_output.put_line(SQLERRM);
       dbms_output.put_line(v_sql);
END;

EXECUTE Orders_Extract;
SELECT * FROM Orders_stage;



--------------------------------------------------------------------
------------Transform Stage----------------------------------------

CREATE TABLE Location_Preload (
    LocationKey NUMBER(10) NOT NULL,	
    CityName NVARCHAR2(50) NULL,
    StateProvCode NVARCHAR2(5) NULL,
    StateProvName NVARCHAR2(50) NULL,
    CountryName NVARCHAR2(60) NULL,
    CountryFormalName NVARCHAR2(60) NULL,
    CONSTRAINT PK_Location_Preload PRIMARY KEY (LocationKey)
);



CREATE TABLE Customers_Preload (
   CustomerKey NUMBER(10) NOT NULL,
   CustomerName NVARCHAR2(100) NULL,
   CustomerCategoryName NVARCHAR2(50) NULL,
   DeliveryCityName NVARCHAR2(50) NULL,
   DeliveryStateProvCode NVARCHAR2(5) NULL,
   DeliveryCountryName NVARCHAR2(50) NULL,
   PostalCityName NVARCHAR2(50) NULL,
   PostalStateProvCode NVARCHAR2(5) NULL,
   PostalCountryName NVARCHAR2(50) NULL,
   StartDate DATE NOT NULL,
   EndDate DATE NULL,
   CONSTRAINT PK_Customers_Preload PRIMARY KEY ( CustomerKey )
);

DROP SEQUENCE LocationKey ;

CREATE SEQUENCE LocationKey START WITH 1 CACHE 10;

SELECT * FROM user_sequences;

SELECT * FROM Customers_Stage;



/*
CREATE OR REPLACE PROCEDURE Locations_Transform
AS
  RowCt NUMBER(10);
  v_sql VARCHAR(255) := 'TRUNCATE TABLE Location_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO Location_Preload -- Column list excluded for brevity 
    SELECT LocationKey.NEXTVAL AS LocationKey,
           cu.DeliveryCityName,
           cu.DeliveryStateProvinceCode,
           cu.DeliveryStateProvinceName,
           cu.DeliveryCountryName,
           cu.DeliveryFormalName
    FROM Customers_Stage cu
    WHERE NOT EXISTS 
	( SELECT 1 
              FROM DimLocation ci
              WHERE cu.DeliveryCityName = ci.CityName
                AND cu.DeliveryStateProvinceName = ci.STATEPROVNAME 
                AND cu.DeliveryCountryName = ci.CountryName 
        );
       
INSERT INTO Location_Preload -- Column list excluded for brevity 
    SELECT ci.LocationKey,
           cu.DeliveryCityName,
           cu.DeliveryStateProvinceCode,
           cu.DeliveryStateProvinceName,
           cu.DeliveryCountryName,
           cu.DeliveryFormalName
    FROM Customers_Stage cu
    JOIN DimLocation ci
        ON cu.DeliveryCityName = ci.CityName
        AND cu.DeliveryStateProvinceName = ci.STATEPROVNAME 
        AND cu.DeliveryCountryName = ci.CountryName;
    
    RowCt := SQL%ROWCOUNT;
    IF sql%notfound THEN
       dbms_output.put_line('No records found. Check with source system.');
    ELSIF sql%found THEN
       dbms_output.put_line(RowCt ||' Rows have been inserted!');
    END IF;
    
  EXCEPTION
    WHEN OTHERS THEN
       dbms_output.put_line(SQLERRM);
       dbms_output.put_line(v_sql);
END;
*/

--------------------------PROCEDURE Locations_Transform---------------------
create or replace PROCEDURE Locations_Transform
AS
  RowCt NUMBER(10);
  v_sql VARCHAR(255) := 'TRUNCATE TABLE Location_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO Location_Preload /* Column list excluded for brevity */
    SELECT LocationKey.NEXTVAL AS LocationKey,
           cu.DeliveryCityName,
           cu.DeliveryStateProvinceCode,
           cu.DeliveryStateProvinceName,
           cu.DeliveryCountryName,
           cu.DeliveryFormalName
    FROM Customers_Stage cu
    WHERE NOT EXISTS
	( SELECT 1
              FROM DimLocation ci
              WHERE cu.DeliveryCityName = ci.CityName
                AND cu.DeliveryStateProvinceName = ci.STATEPROVNAME
                AND cu.DeliveryCountryName = ci.CountryName 
        );
            RowCt := SQL%ROWCOUNT;
INSERT INTO Location_Preload /* Column list excluded for brevity */
    SELECT ci.LocationKey,
           cu.DeliveryCityName,
           cu.DeliveryStateProvinceCode,
           cu.DeliveryStateProvinceName,
           cu.DeliveryCountryName,
           cu.DeliveryFormalName
    FROM Customers_Stage cu
    JOIN DimLocation ci
        ON cu.DeliveryCityName = ci.CityName
        AND cu.DeliveryStateProvinceName = ci.STATEPROVNAME
        AND cu.DeliveryCountryName = ci.CountryName;

    RowCt := RowCt+SQL%ROWCOUNT;
dbms_output.put_line(RowCt ||' Rows have been inserted!');
COMMIT;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
         dbms_output.put_line('No records found. Check with source system.');
WHEN OTHERS THEN
       dbms_output.put_line(SQLERRM);
       dbms_output.put_line(v_sql);
       ROLLBACK;
  
END;


SET SERVEROUT ON;
-- TRUNCATE TABLE Location_Preload;
EXECUTE Locations_Transform;
SELECT * FROM location_preload ORDER BY locationkey;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------Customers_Transform-----------------------------------------------------
/*
DROP SEQUENCE CustomerKey ;
CREATE SEQUENCE CustomerKey START WITH 1 CACHE 10;


CREATE  OR REPLACE PROCEDURE Customers_Transform
AS
  RowCt NUMBER(10);
  v_sql VARCHAR(255) := 'TRUNCATE TABLE Customers_Preload DROP STORAGE';
  StartDate DATE := SYSDATE; EndDate DATE := SYSDATE - 1;
BEGIN
    EXECUTE IMMEDIATE v_sql;
 --BEGIN TRANSACTION;
 -- Add updated records
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
    SELECT  CustomerKey.NEXTVAL AS CustomerKey,
           stg.CustomerName,
           stg.CustomerCategoryName,
           stg.DeliveryCityName,
           stg.DeliveryStateProvinceCode,
           stg.DeliveryCountryName,
           stg.PostalCityName,
           stg.PostalStateProvinceCode,
           stg.PostalCountryName,
           StartDate,
           NULL
    FROM Customers_Stage stg
    JOIN DimCustomers cu
        ON stg.CustomerName = cu.CustomerName AND cu.EndDate IS NULL
WHERE stg.CustomerCategoryName <> cu.CustomerCategoryName
          OR stg.DeliveryCityName <> cu.DeliveryCityName
          OR stg.DeliveryStateProvinceCode <> cu.DeliveryStateProvCode
          OR stg.DeliveryCountryName <> cu.DeliveryCountryName
          OR stg.PostalCityName <> cu.PostalCityName
          OR stg.PostalStateProvinceCode <> cu.PostalStateProvCode
          OR stg.PostalCountryName <> cu.PostalCountryName;

    -- Add existing records, and expire as necessary
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
    SELECT cu.CustomerKey,
           cu.CustomerName,
           cu.CustomerCategoryName,
           cu.DeliveryCityName,
           cu.DeliveryStateProvCode,
           cu.DeliveryCountryName,
           cu.PostalCityName,
           cu.PostalStateProvCode,
           cu.PostalCountryName,
           cu.StartDate,
           CASE 
               WHEN pl.CustomerName IS NULL THEN NULL
               ELSE EndDate
           END AS EndDate
FROM DimCustomers cu
    LEFT JOIN Customers_Preload pl    
        ON pl.CustomerName = cu.CustomerName
        AND cu.EndDate IS NULL;

    -- Create new records
    INSERT INTO Customers_Preloa -- Column list excluded for brevity 
    SELECT CustomerKey.NEXTVAL AS CustomerKey,
        stg.CustomerName,
        stg.CustomerCategoryName,
        stg.DeliveryCityName,
        stg.DeliveryStateProvinceCode,
        stg.DeliveryCountryName,
        stg.PostalCityName,
        stg.PostalStateProvinceCode,
        stg.PostalCountryName,
        StartDate,
         NULL
    FROM Customers_Stage stg
    WHERE NOT EXISTS ( SELECT 1 FROM DimCustomers cu WHERE stg.CustomerName = cu.CustomerName );
    -- Expire missing records
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
        SELECT cu.CustomerKey,
        cu.CustomerName,
        cu.CustomerCategoryName,
        cu.DeliveryCityName,
        cu.DeliveryStateProvCode,
        cu.DeliveryCountryName,
        cu.PostalCityName,
        cu.PostalStateProvCode,
        cu.PostalCountryName,
        cu.StartDate,
        EndDate
    FROM DimCustomers cu
    WHERE NOT EXISTS ( SELECT 1 FROM Customers_Stage stg WHERE stg.CustomerName = cu.CustomerName )
    AND cu.EndDate IS NULL;
    COMMIT;
    END;
    
 */
 --This is the correct one
 -- Customers Transform – Type 2 SCD
 DROP SEQUENCE SeqCustomerKey;
 CREATE SEQUENCE SeqCustomerKey START WITH 1 CACHE 10;
 SET SERVEROUT ON;
-- TRUNCATE TABLE Customers_preload;

CREATE OR REPLACE PROCEDURE Customers_Transform
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE Customers_Preload DROP STORAGE';
    v_StartDate DATE := SYSDATE; 
    v_EndDate DATE := ((SYSDATE) - 1);
BEGIN
    EXECUTE IMMEDIATE v_sql;
    -- Add updated records
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
        SELECT SeqCustomerKey.NEXTVAL AS CustomerKey,
            stg.CustomerName,
            stg.CustomerCategoryName,
            stg.DeliveryCityName,
            stg.DeliveryStateProvinceCode,
            stg.DeliveryCountryName,
            stg.PostalCityName,
            stg.PostalStateProvinceCode,
            stg.PostalCountryName,
            StartDate,
            NULL
        FROM Customers_Stage stg
        JOIN DimCustomers cu
            ON stg.CustomerName = cu.CustomerName AND cu.EndDate IS NULL
        WHERE stg.CustomerCategoryName <> cu.CustomerCategoryName
            OR stg.DeliveryCityName <> cu.DeliveryCityName
            OR stg.DeliveryStateProvinceCode <> cu.DeliveryStateProvCode
            OR stg.DeliveryCountryName <> cu.DeliveryCountryName
            OR stg.PostalCityName <> cu.PostalCityName
            OR stg.PostalStateProvinceCode <> cu.PostalStateProvCode
            OR stg.PostalCountryName <> cu.PostalCountryName;
            
                      RowCt := SQL%ROWCOUNT;
  
    -- Add existing records, and expire as necessary
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
        SELECT cu.CustomerKey,
            cu.CustomerName,
            cu.CustomerCategoryName,
            cu.DeliveryCityName,
            cu.DeliveryStateProvCode,
            cu.DeliveryCountryName,
            cu.PostalCityName,
            cu.PostalStateProvCode,
            cu.PostalCountryName,
            cu.StartDate,
            (CASE WHEN pl.CustomerName IS NULL THEN NULL
                ELSE cu.EndDate
            END) AS EndDate
        FROM DimCustomers cu
        LEFT JOIN wwidmuser.Customers_Preload pl 
            ON pl.CustomerName = cu.CustomerName
            AND cu.EndDate IS NULL;
            
                         RowCt := RowCt+SQL%ROWCOUNT;


        -- Create new records
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
        SELECT SeqCustomerKey.NEXTVAL AS CustomerKey,
            stg.CustomerName,
            stg.CustomerCategoryName,
            stg.DeliveryCityName,
            stg.DeliveryStateProvinceCode,
            stg.DeliveryCountryName,
            stg.PostalCityName,
            stg.PostalStateProvinceCode,
            stg.PostalCountryName,
            (v_StartDate),
            NULL
        FROM Customers_Stage stg
        WHERE NOT EXISTS ( SELECT 1 FROM DimCustomers cu WHERE stg.CustomerName = cu.CustomerName );
        
        RowCt := RowCt+SQL%ROWCOUNT;

    -- Expire missing records
    INSERT INTO Customers_Preload -- Column list excluded for brevity 
        SELECT cu.CustomerKey,
            cu.CustomerName,
            cu.CustomerCategoryName,
            cu.DeliveryCityName,
            cu.DeliveryStateProvCode,
            cu.DeliveryCountryName,
            cu.PostalCityName,
            cu.PostalStateProvCode,
            cu.PostalCountryName,
            cu.StartDate,
            (v_EndDate)
        FROM DimCustomers cu
        WHERE NOT EXISTS ( SELECT 1 FROM Customers_Stage stg WHERE stg.CustomerName = cu.CustomerName )
            AND cu.EndDate IS NULL;
    
      RowCt := RowCt+SQL%ROWCOUNT;

     
dbms_output.put_line(RowCt ||' Rows have been inserted!');
COMMIT;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
         dbms_output.put_line('No records found. Check with source system.');
WHEN OTHERS THEN
       dbms_output.put_line(SQLERRM);
       dbms_output.put_line(v_sql);
       ROLLBACK;
END;


EXECUTE Customers_Transform;
--SELECT * FROM Customers_preload;
