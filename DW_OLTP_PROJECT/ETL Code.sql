




CREATE TABLE FactSales (
-- Should we create a surrogate key?
CustomerKey NUMBER(10) NOT NULL,
LocationKey NUMBER(10) NOT NULL,
ProductKey NUMBER(10) NOT NULL,
SalespersonKey NUMBER(10) NOT NULL,
SupplierKey NUMBER(10) NOT NULL, -- This is the Key that is added to create to DimSupplier table
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

--------------------------------------------DIMENSIONAL TABLES --------------------------------------------------------------------------------


----------------------------TYPE 1 SCD------------------------------------
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

----------------------------TYPE 1 SCD------------------------------------
CREATE TABLE DimLocation(
LocationKey NUMBER(10),
CityName NVARCHAR2(50) NULL,
StateProvinceCode NVARCHAR2(5) NULL,
StateProvName NVARCHAR2(50) NULL,
CountryName NVARCHAR2(60) NULL,
CountryFormalName NVARCHAR2(60) NULL,
CONSTRAINT PK_DimLocation PRIMARY KEY ( LocationKey )
);


--------------------------TYPE 2 SCD-------------------------------
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

--***************************************************************Requirement 1 of Assignment 4*********************************************************************
/*

Requirement 1 ï¿½ Dimensional Model tables

*/

-- This is the Key that is added to create to DimSupplier table
--I have already added this column in the table , it is just to highlight it. 
/*
ALTER TABLE FactSales
ADD SupplierKey NUMBER(10) NOT NULL;
*/



--------------Added one more Dimension Table in our Schema----------------------------------------------------------------
----------------- Type 2 -------------------------------------
CREATE TABLE DimSuppliers(
SupplierKey NUMBER(10) NOT NULL,
SupplierCategoryName    NVARCHAR2(50),
FullName NVARCHAR2(50)  NULL,
PhoneNumber NVARCHAR2(20) NULL,
FaxNumber NVARCHAR2(20) NULL,
WebsiteURL NVARCHAR2(256) NULL,
StartDate DATE NOT NULL,
EndDate DATE NULL,
CONSTRAINT PK_DimSuppliers PRIMARY KEY (SupplierKey)
);



-------------------INDEXES CREATED  ---------------------------------------------------------------------------------------------------------

CREATE INDEX IX_FactSales_SupplierKey ON FactSales(SupplierKey); --Index for table FactSales 

----------------Dimensional Table Indexes--------------------------------------------------------
CREATE INDEX IX_DimLocation_City ON DimLocation (CityName,StateProvCode,CountryName);
CREATE INDEX IX_DimProducts_ProductName ON DimProducts (ProductName);
CREATE INDEX IX_DimCustomer_CustomerName ON DimCustomers (CustomerName);
CREATE INDEX IX_DimSalesPeople_LogonName ON DimSalesPeople (LogonName);
CREATE INDEX IX_DimSupplier_FullName ON DimSuppliers (FullName);
---------------------------------------------------------------------------------
   


/* 
************************************************************************************************************************************************
REQUIREMENT 2 

Create a stored procedure to insert into the date dimension table, 
using a single DateValue parameter as an input DATE field.

*/

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


SELECT * FROM DimDate;

EXECUTE DimDate_Load('2017-12-01');



--************************************************************************************************
/*
REQUIREMENT 3

Write a query that will return Customer, City, Salespeople, Products, suppliers 
and dates for Order facts using this dimensional table.

*/

SELECT DimSuppliers.FullName,DimCustomers.CustomerName,DimLocation.CityName,DimProducts.ProductName,DimDate.DateValue,DimSuppliers.SupplierCategoryName
FROM DimSalesPeople sp
JOIN FactSales  
ON FactSales.SalespersonKey = DimSalesPeople.SalespersonKey
JOIN DimLocation 
ON FactSales.LocationKey = DimLocation.LocationKey
JOIN DimCustomers 
ON FactSales.CustomerKey=DimCustomers.CustomerKey
JOIN DimProducts 
ON FactSales.ProductKey=DimProducts.ProductKey
JOIN DimDate  
ON FactSales.DateKey=DimDate.DateKey
JOIN DimSuppliers  
ON FactSales.SupplierKey=DimSuppliers.SupplierKey;



/****************************************************************


REQUIREMENT 4 - Extracts


Create stage tables to insert the extracted data into, and Write stored procedures that will obtain 
all the required data from the following source data sets from WideWorldImporters :
- Customers - Query that joins Customers, CustomerCategories, Cities, StateProvinces, and Countries.
- Products - Query that joins StockItems and Colours
- Salespeople - Query of People where IsSalesperson is 1
- Orders - Query that joins Orders, OrderLines, Customers, and People, and accepts an @OrderDate as a parameter, and only selects records that match that date.
- Suppliers - Query that joins Suppliers and SupplierCategories (Business Analyst and SME review of the Supplier 
source tables suggests that SupplierCategory might also influence sales orders, 
so please add the SupplierCategoryName field to the appropriate table in the dimensional model).
Test each of your Extract stored procedures by executing each one of them. When testing the orders extract, use ï¿½2013-01-01ï¿½ as the date.

*/

--****************************************1. Staging Table and Extract Procedure - Customers**************************************************************

-- Customers - Query that joins Customers, CustomerCategories, Cities, StateProvinces, and Countries.

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

-- EXECUTE PROCEDURE
EXECUTE Customers_Extract;
SELECT * FROM customers_stage;





--****************************************2. Staging Table and Extract Procedure - Products**************************************************************
--Products ï¿½ Query that joins StockItems and Colours

  CREATE TABLE Products_Stage (
    ColorName nvarchar2(20)  NULL, -- Colors
    Brand nvarchar2(50) NULL, -- StockItems
	ItemSize nvarchar2(20) NULL, -- StockItems
    StockItemName    NVARCHAR2(100)  -- StockItems
);

CREATE OR REPLACE PROCEDURE Products_Extract
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE wwidmuser.Products_Stage DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    
    INSERT INTO wwidmuser.Products_Stage (ColorName,Brand,ItemSize,StockItemName)
    SELECT col.ColorName,si.Brand,si.ItemSize,si.StockItemName
    FROM wwidbuser.StockItems si
    LEFT JOIN wwidbuser.Colors col
        ON si.ColorId = col.ColorId;

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

-- EXECUTE PROCEDURE
EXECUTE Products_Extract;
SELECT * FROM Products_Stage;

--****************************************3. Staging Table and Extract Procedure - SalesPeople**************************************************************

--Salespeople ï¿½ Query of People where IsSalesperson is 1

CREATE TABLE SalesPeople_Stage(
    FullName NVARCHAR2(50)  NULL,
    PreferredName NVARCHAR2(50),
    LogonName NVARCHAR2(50),
    PhoneNumber NVARCHAR2(20), 
	FaxNumber NVARCHAR2(20), 
	EmailAddress NVARCHAR2(256)
    
);


CREATE OR REPLACE PROCEDURE SalesPeople_Extract
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE wwidmuser.SalesPeople_Stage DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    
    INSERT INTO wwidmuser.SalesPeople_Stage
    SELECT FullName,PreferredName,LogonName,PhoneNumber,FaxNumber,EmailAddress
    FROM wwidbuser.People pe
    WHERE pe.IsSalesPerson = 1;

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

-- EXECUTE PROCEDURE
EXECUTE SalesPeople_Extract;
SELECT * FROM SalesPeople_Stage;




--****************************************5. Staging Table and Extract Procedure - Suppliers**************************************************************

--Suppliers  - Suppliers and SuppliersCategories

CREATE TABLE Suppliers_Stage (
SupplierCategoryName    NVARCHAR2(100),  --  SupplierCategories  
FullName NVARCHAR2(50)  , --  Suppliers
PhoneNumber NVARCHAR2(20) , --Suppliers
FaxNumber nvarchar2(20) , --Suppliers
WebsiteURL NVARCHAR2(256)   --Suppliers
);


CREATE OR REPLACE PROCEDURE Suppliers_Extract
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE wwidmuser.Suppliers_Stage DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    
    INSERT INTO wwidmuser.Suppliers_Stage 
    SELECT  sc.SupplierCategoryName,s.SupplierName,s.PhoneNumber,s.FaxNumber,s.WebsiteURL 
    FROM wwidbuser.Suppliers s
    LEFT JOIN wwidbuser.SupplierCategories sc
        ON s.SupplierCategoryID = sc.SupplierCategoryID;
	 
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

-- EXECUTE PROCEDURE
EXECUTE Suppliers_Extract;
SELECT * FROM Suppliers_Stage;


--****************************************6. Staging Table and Extract Procedure - Orders**************************************************************

--Orders - Orders,OrderLines,Customers and People
-- DROP TABLE Orders_Stage;
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
    LogonName       NVARCHAR2(50),
    SupplierName NVARCHAR2(100)
);

CREATE OR REPLACE PROCEDURE Orders_Extract(var_OrderDate DATE)
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
        ,su.SupplierName
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
            ON o.salespersonpersonid = p.personid 
        LEFT JOIN wwidbuser.Suppliers su
            ON su.PrimaryContactPersonID = p.personid
        WHERE o.OrderDate = var_OrderDate;

RowCt := SQL%ROWCOUNT;
COMMIT;
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


EXECUTE Orders_Extract ('2013-01-01');
SELECT * FROM Orders_Stage;


/*
****************************************************************************************************************************************************************

REQUIREMENT 5

Create the PreLoad staging tables that match the structure of the destination (dim) tables, 
and Stored Procedures to perform the transformations of the source to destination data.

*/
 
-- Sequences must be dropped everytime a procedure is executed------------------------------------------------------------- 
SELECT * FROM user_sequences;


--****************************************1. Preload Table and Transform Procedure - Locations**************************************************************
SET SERVEROUT ON;
DROP SEQUENCE LocationKey ;
CREATE SEQUENCE LocationKey START WITH 1 CACHE 10;


CREATE TABLE Locations_Preload (
    LocationKey NUMBER(10) NOT NULL,	
    CityName NVARCHAR2(50) NULL,
    StateProvCode NVARCHAR2(5) NULL,
    StateProvName NVARCHAR2(50) NULL,
    CountryName NVARCHAR2(60) NULL,
    CountryFormalName NVARCHAR2(60) NULL,
    CONSTRAINT PK_Location_Preload PRIMARY KEY (LocationKey)
);



create or replace PROCEDURE Locations_Transform
AS
  RowCt NUMBER(10);
  v_sql VARCHAR(255) := 'TRUNCATE TABLE Locations_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO Locations_Preload /* Column list excluded for brevity */
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
INSERT INTO Locations_Preload /* Column list excluded for brevity */
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
/*



*/


EXECUTE Locations_Transform;
SELECT * FROM Locations_Preload;



--****************************************2. Preload Table and Transform Procedure - Customers**************************************************************
SET SERVEROUT ON;
DROP SEQUENCE CustomerKey;
CREATE SEQUENCE CustomerKey START WITH 1 CACHE 10;

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
        SELECT CustomerKey.NEXTVAL AS CustomerKey,--
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
        SELECT CustomerKey.NEXTVAL AS CustomerKey, 
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
SELECT * FROM Customers_preload;



--****************************************3. Preload Table and Transform Procedure - SalesPeople**************************************************************
SET SERVEROUT ON;

DROP SEQUENCE SalespersonKey;
CREATE SEQUENCE SalespersonKey START WITH 1 CACHE 10;


CREATE TABLE SalesPeople_Preload (
SalespersonKey INT NOT NULL,
FullName NVARCHAR2(50) NULL,
PreferredName NVARCHAR2(50) NULL,
LogonName NVARCHAR2(50) NULL,
PhoneNumber NVARCHAR2(20) NULL,
FaxNumber NVARCHAR2(20) NULL,
EmailAddress NVARCHAR2(256) NULL,
CONSTRAINT PK_SalesPeople_Preload PRIMARY KEY (SalespersonKey )
);




CREATE OR REPLACE PROCEDURE SalesPeople_Transform
AS
RowCt NUMBER(10);
v_sql VARCHAR(255) := 'TRUNCATE TABLE SalesPeople_Preload DROP STORAGE';
BEGIN
EXECUTE IMMEDIATE v_sql;

INSERT INTO SalesPeople_Preload /* Column list excluded for brevity */
SELECT SalespersonKey.NEXTVAL AS SalespersonKey,
sp.FullName,
sp.PreferredName,
sp.LogonName,
sp.PhoneNumber,
sp.FaxNumber,
sp.EmailAddress
FROM SalesPeople_Stage sp
WHERE NOT EXISTS
( SELECT 1
FROM DimSalesPeople dsp
WHERE sp.FullName = dsp.FullName
AND sp.PreferredName = dsp.PreferredName
AND sp.LogonName = dsp.LogonName
AND sp.PhoneNumber = dsp.PhoneNumber
AND sp.FaxNumber = dsp.FaxNumber
AND sp.EmailAddress = dsp.EmailAddress
);

 RowCt := SQL%ROWCOUNT;
INSERT INTO SalesPeople_Preload /* Column list excluded for brevity */
SELECT SalespersonKey.NEXTVAL AS SalespersonKey,
sp.FullName,
sp.PreferredName,
sp.LogonName,
sp.PhoneNumber,
sp.FaxNumber,
sp.EmailAddress
FROM SalesPeople_Stage sp
JOIN DimSalesPeople dsp
ON sp.FullName = dsp.FullName
AND sp.PreferredName = dsp.PreferredName
AND sp.LogonName = dsp.LogonName
AND sp.PhoneNumber = dsp.PhoneNumber
AND sp.FaxNumber = dsp.FaxNumber
AND sp.EmailAddress = dsp.EmailAddress;

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

EXECUTE SalesPeople_Transform;
SELECT * FROM SalesPeople_Preload;


--****************************************4. Preload Table and Transform Procedure - Products**************************************************************
SET SERVEROUT ON;

DROP SEQUENCE ProductsKey;
CREATE SEQUENCE ProductsKey START WITH 1 CACHE 10;

CREATE TABLE Products_Preload (
ProductKey INT NOT NULL,
ProductName NVARCHAR2(100) NULL,
ProductColour NVARCHAR2(20) NULL,
ProductBrand NVARCHAR2(50) NULL,
ProductSize NVARCHAR2(20) NULL,
StartDate DATE NOT NULL,
EndDate DATE NULL,
CONSTRAINT PK_Products_Preload PRIMARY KEY ( ProductKey )
);


CREATE OR REPLACE PROCEDURE Products_Transform
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE Products_Preload DROP STORAGE';
    v_StartDate DATE := SYSDATE; 
    v_EndDate DATE := ((SYSDATE) - 1);
BEGIN
    EXECUTE IMMEDIATE v_sql;
    -- Add updated records
    INSERT INTO Products_Preload -- Column list excluded for brevity 
        SELECT ProductsKey.NEXTVAL AS ProductsKey,
            stg.StockItemName,
            stg.ColorName,
            stg.Brand,
            stg.ItemSize,
            StartDate,
            NULL
        FROM Products_Stage stg
        JOIN DimProducts cu
            ON stg.StockItemName = cu.ProductName 
            AND stg.ColorName = cu.ProductColour
            AND stg.Brand = cu.ProductBrand
            AND stg.ItemSize = cu.ProductSize
            AND cu.EndDate IS NULL;
    
            
            RowCt := SQL%ROWCOUNT;
  
    -- Add existing records, and expire as necessary
    INSERT INTO Products_Preload -- Column list excluded for brevity 
        SELECT cu.ProductKey,
            cu.ProductName,
            cu.ProductColour,
            cu.ProductBrand,
            cu.ProductSize,
            cu.StartDate,
            (CASE WHEN pl.ProductName IS NULL THEN NULL
                ELSE cu.EndDate
            END) AS EndDate
        FROM DimProducts cu
        LEFT JOIN wwidmuser.Products_Preload pl 
            ON pl.ProductName = cu.ProductName
            AND cu.EndDate IS NULL;
            
            RowCt := RowCt+SQL%ROWCOUNT;


        -- Create new records
    INSERT INTO Products_Preload -- Column list excluded for brevity 
        SELECT ProductsKey.NEXTVAL AS ProductsKey,
            stg.StockItemName,
            stg.ColorName,
            stg.Brand,
            stg.ItemSize,
            (v_StartDate),
            NULL
        FROM Products_Stage stg
        WHERE NOT EXISTS ( SELECT 1 FROM DimProducts cu WHERE stg.StockItemName = cu.ProductName );
        
        RowCt := RowCt+SQL%ROWCOUNT;

    -- Expire missing records--------
     INSERT INTO Products_Preload -- Column list excluded for brevity 
        SELECT cu.ProductKey,
            cu.ProductName,
            cu.ProductColour,
            cu.ProductBrand,
            cu.ProductSize,
            cu.StartDate,
            (v_EndDate)
        FROM DimProducts cu
        WHERE NOT EXISTS ( SELECT 1 FROM Products_Stage stg WHERE stg.StockItemName = cu.ProductName )
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


EXECUTE Products_Transform;
SELECT * FROM Products_preload;


--****************************************5. Preload Table and Transform Procedure - Suppliers**************************************************************
 SET SERVEROUT ON;

DROP SEQUENCE Key;
CREATE SEQUENCE SuppliersKey START WITH 1 CACHE 10;

CREATE TABLE Suppliers_Preload(
SupplierKey NUMBER(10) NOT NULL,
SupplierCategoryName    NVARCHAR2(50),
FullName NVARCHAR2(50)  NULL,
PhoneNumber NVARCHAR2(20) NULL,
FaxNumber NVARCHAR2(20) NULL,
WebsiteURL NVARCHAR2(256) NULL,
StartDate DATE NOT NULL,
EndDate DATE NULL,
CONSTRAINT PK_Suppliers_Preload PRIMARY KEY (SupplierKey)
);


CREATE OR REPLACE PROCEDURE Suppliers_Transform
AS
    RowCt NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE Suppliers_Preload DROP STORAGE';
    v_StartDate DATE := SYSDATE; 
    v_EndDate DATE := ((SYSDATE) - 1);
BEGIN
    EXECUTE IMMEDIATE v_sql;
    -- Add updated records
    INSERT INTO Suppliers_Preload -- Column list excluded for brevity 
        SELECT SuppliersKey.NEXTVAL AS SuppliersKey,
            stg.SupplierCategoryName,
            stg.FullName,
            stg.PhoneNumber,
            stg.FaxNumber,
            stg.WebsiteURL,
            StartDate,
            NULL
        FROM Suppliers_Stage stg
        JOIN DimSuppliers cu
            ON stg.SupplierCategoryName = cu.SupplierCategoryName 
            AND stg.FullName = cu.FullName
            AND stg.PhoneNumber = cu.PhoneNumber
            AND stg.FaxNumber = cu.FaxNumber
            AND stg.WebsiteURL = cu.WebsiteURL
            AND cu.EndDate IS NULL;
    
            
            RowCt := SQL%ROWCOUNT;
  
    -- Add existing records, and expire as necessary
    INSERT INTO Suppliers_Preload -- Column list excluded for brevity 
        SELECT cu.SupplierKey,
            cu.SupplierCategoryName,
            cu.FullName,
            cu.PhoneNumber,
            cu.FaxNumber,
            cu.WebsiteURL,
            cu.StartDate,
            (CASE WHEN pl.SupplierCategoryName IS NULL THEN NULL
                ELSE cu.EndDate
            END) AS EndDate
        FROM DimSuppliers cu
        LEFT JOIN wwidmuser.Suppliers_Preload pl 
            ON pl.FullName = cu.FullName
            AND cu.EndDate IS NULL;
            
            RowCt := RowCt+SQL%ROWCOUNT;


        -- Create new records
    INSERT INTO Suppliers_Preload -- Column list excluded for brevity 
        SELECT SuppliersKey.NEXTVAL AS SuppliersKey,
            stg.SupplierCategoryName,
            stg.FullName,
            stg.PhoneNumber,
            stg.FaxNumber,
            stg.WebsiteURL,
            (v_StartDate),
            NULL
        FROM Suppliers_Stage stg
        WHERE NOT EXISTS ( SELECT 1 FROM DimSuppliers cu WHERE stg.FullName = cu.FullName );
        
        RowCt := RowCt+SQL%ROWCOUNT;

    -- Expire missing records
     
    INSERT INTO Suppliers_Preload -- Column list excluded for brevity 
        SELECT cu.SupplierKey,
            cu.SupplierCategoryName,
            cu.FullName,
            cu.PhoneNumber,
            cu.FaxNumber,
            cu.WebsiteURL,
            cu.StartDate,
            (v_EndDate)
        FROM DimSuppliers cu
        WHERE NOT EXISTS ( SELECT 1 FROM Suppliers_Stage stg WHERE stg.FullName = cu.FullName )
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


EXECUTE Suppliers_Transform;
SELECT * FROM Suppliers_Preload;




--****************************************6. Preload Table and Transform Procedure - Orders**************************************************************

-- DROP TABLE Orders_Preload;
CREATE TABLE Orders_Preload (
CustomerKey NUMBER(10) NOT NULL,
LocationKey NUMBER(10) NOT NULL,
ProductKey NUMBER(10) NOT NULL,
SalespersonKey NUMBER(10) NOT NULL,
SupplierKey NUMBER(10) NOT NULL,
DateKey NUMBER(8) NOT NULL,
Quantity NUMBER(3) NOT NULL,
UnitPrice NUMBER(18, 2) NOT NULL,
TaxRate NUMBER(18, 3) NOT NULL,
TotalBeforeTax NUMBER(18, 2) NOT NULL,
TotalAfterTax NUMBER(18, 2) NOT NULL
);


create or replace PROCEDURE Factorders_transform (date_transform DATE) AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE Orders_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO Orders_Preload
        SELECT
            cu.customerkey,
            ci.locationkey,
            pr.productkey,
            sp.salespersonkey,
            su.supplierkey,
            TO_NUMBER(TO_CHAR(date_transform,'YYYYMMDD')),
            SUM(ord.quantity),
            AVG(ord.unitprice),
            AVG(ord.taxrate),
            SUM(ord.quantity * ord.unitprice),
            SUM(ord.quantity * ord.unitprice *(1 + ord.taxrate / 100))
        FROM
                 orders_stage ord
            INNER JOIN customers_preload   cu ON ord.customername = cu.customername
            INNER JOIN locations_preload    ci ON ord.cityname = ci.cityname
                                              AND ord.stateprovincename = ci.stateprovname
                                              AND ord.countryname = ci.countryname
            INNER JOIN products_preload    pr ON ord.stockitemname = pr.productname
            INNER JOIN salespeople_preload sp ON ord.logonname = sp.logonname
            INNER JOIN suppliers_preload   su ON ord.suppliername = su.FullName
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    factsales fo
                WHERE
                        fo.customerkey = cu.customerkey
                    AND fo.locationkey = ci.locationkey
                    AND fo.productkey = pr.productkey
                    AND fo.salespersonkey = sp.salespersonkey
                    AND fo.supplierkey = su.supplierkey
                    AND fo.datekey = to_number(to_char(date_transform, 'YYYYMMDD'))
            )
        GROUP BY
            to_number(to_char(date_transform, 'YYYYMMDD')),
            customerkey,
            locationkey,
            productkey,
            salespersonkey,
            supplierkey;
          
    RowCt := SQL%ROWCOUNT;

      INSERT INTO Orders_Preload SELECT * FROM factsales;


    COMMIT;
dbms_output.put_line('Transfom_preload==>'||''||'Number of orders added: ' || TO_CHAR(RowCt));
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
END;




EXECUTE Factorders_transform('2013-01-01');
SELECT * FROM Orders_Preload;

/************************************************************************************************
Requirement 6 -  Create ETL Loads 

Create stored procedures that will load the dimension tables with any changed records 
and load the fact table in the WideWorldImporters Data mart/Data warehouse. 
Remember to follow the best practices for creating stored procedures that ensures that if part of the updates for a table fail, 
the rest of the updates to the table will be rolled back.
*/

--1. Customers Load


CREATE OR REPLACE PROCEDURE Customers_Load
AS
    RowCt NUMBER(10);
BEGIN
    
    DELETE FROM DimCustomers dloc
    WHERE (dloc.CustomerKey) IN
    (SELECT dloc.CustomerKey FROM DimCustomers dloc
    JOIN Customers_Preload locp
        ON dloc.CustomerKey = locp.CustomerKey);
    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Deleted!');

    INSERT INTO DimCustomers
    SELECT *
    FROM Customers_Preload;

    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Inserted!');
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No records found. Check with source system.');
        WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
END;


EXECUTE Customers_Load;

SELECT * FROM DimCustomers;

--2.Loacation/Cities Load  

CREATE OR REPLACE PROCEDURE Location_Load
AS
    RowCt NUMBER(10);
BEGIN
    
    DELETE FROM DimLocation dloc
    WHERE (dloc.LocationKey) IN
    (SELECT dloc.locationkey FROM DimLocation dloc
    JOIN Location_Preload locp
        ON dloc.LocationKey = locp.LocationKey);
    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Deleted!');

    INSERT INTO DimLocation
    SELECT *
    FROM Location_Preload;

    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Inserted!');
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No records found. Check with source system.');
        WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
END;

EXECUTE Location_Load;


--3.SalesPeople Load  
CREATE OR REPLACE PROCEDURE SalesPeople_load
AS
    RowCt NUMBER(10);
BEGIN
    
    DELETE FROM DimSalesPeople dloc
    WHERE (dloc.SalespersonKey) IN
    (SELECT dloc.SalespersonKey FROM DimSalesPeople dloc
    JOIN SalesPeople_Preload locp
        ON dloc.SalespersonKey = locp.SalespersonKey);
    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Deleted!');

    INSERT INTO DimSalesPeople
    SELECT *
    FROM SalesPeople_Preload;

    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Inserted!');
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No records found. Check with source system.');
        WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
END;

EXECUTE SalesPeople_load;

--4.Products Load  

CREATE OR REPLACE PROCEDURE Products_load
AS
    RowCt NUMBER(10);
BEGIN
    
    DELETE FROM DimProducts dloc
    WHERE (dloc.ProductKey) IN
    (SELECT dloc.ProductKey FROM DimProducts dloc
    JOIN Products_Preload locp
        ON dloc.ProductKey = locp.ProductKey);
    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Deleted!');

    INSERT INTO DimProducts
    SELECT *
    FROM Products_Preload;

    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Inserted!');
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No records found. Check with source system.');
        WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
END;

EXECUTE Products_load;

--5. Suppliers Load

CREATE OR REPLACE PROCEDURE Suppliers_load
AS
    RowCt NUMBER(10);
BEGIN
    
    DELETE FROM DimSuppliers dloc
    WHERE (dloc.SupplierKey) IN
    (SELECT dloc.SupplierKey FROM DimSuppliers dloc
    JOIN Suppliers_Preload locp
        ON dloc.SupplierKey = locp.SupplierKey);
    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Deleted!');

    INSERT INTO DimSuppliers
    SELECT *
    FROM Suppliers_Preload;

    RowCt := SQL%ROWCOUNT;
    dbms_output.put_line(RowCt ||' Rows have been Inserted!');
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No records found. Check with source system.');
        WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
END;

EXECUTE Suppliers_load;
SELECT * FROM DimSuppliers;

--6.Orders Load ( This Should be done in last) 

CREATE OR REPLACE PROCEDURE Orders_Load
AS
BEGIN
INSERT INTO FactSales /* Columns excluded for brevity */
SELECT * /* Columns excluded for brevity */
FROM Orders_Preload;
END;

EXECUTE Orders_Load;
SELECT * FROM FactSales;

/***************************************************************************************************************
Requirement 7 - Load rest of data to DWH and Query 

Execute the above procedures for 4 days worth of Orders to load the Data Mart (2013-01-01 to 2013-01-04).

*/



BEGIN

EXECUTE DimDate_Load('2013-01-01');
EXECUTE Customers_Extract;
EXECUTE Products_Extract;
EXECUTE SalesPeople_Extract;
EXECUTE Suppliers_Extract;
EXECUTE Orders_Extract('2013-01-01');
EXECUTE Locations_Transform;
EXECUTE Customers_Transform;
EXECUTE SalesPeople_Transform;
EXECUTE Products_Transform;
EXECUTE Suppliers_Transform;
EXECUTE Factorders_Transform;
EXECUTE Customers_Load;
EXECUTE Products_Load;
EXECUTE SalesPeople_Load;
EXECUTE Location_Load;
EXECUTE Suppliers_load;
EXECUTE Orders_Load;

END;

BEGIN

EXECUTE DimDate_Load('2013-01-02');
EXECUTE Customers_Extract;
EXECUTE Products_Extract;
EXECUTE SalesPeople_Extract;
EXECUTE Suppliers_Extract;
EXECUTE Orders_Extract('2013-01-02');
EXECUTE Locations_Transform;
EXECUTE Customers_Transform;
EXECUTE SalesPeople_Transform;
EXECUTE Products_Transform;
EXECUTE Suppliers_Transform;
EXECUTE Factorders_Transform;
EXECUTE Customers_Load;
EXECUTE Products_Load;
EXECUTE SalesPeople_Load;
EXECUTE Location_Load;
EXECUTE Suppliers_load;
EXECUTE Orders_Load;

END;

BEGIN

EXECUTE DimDate_Load('2013-01-04');
EXECUTE Customers_Extract;
EXECUTE Products_Extract;
EXECUTE SalesPeople_Extract;
EXECUTE Suppliers_Extract;
EXECUTE Orders_Extract('2013-01-03');
EXECUTE Locations_Transform;
EXECUTE Customers_Transform;
EXECUTE SalesPeople_Transform;
EXECUTE Products_Transform;
EXECUTE Suppliers_Transform;
EXECUTE Factorders_Transform;
EXECUTE Customers_Load;
EXECUTE Products_Load;
EXECUTE SalesPeople_Load;
EXECUTE Location_Load;
EXECUTE Suppliers_load;
EXECUTE Orders_Load;

END;


BEGIN

EXECUTE DimDate_Load('2013-01-04');
EXECUTE Customers_Extract;
EXECUTE Products_Extract;
EXECUTE SalesPeople_Extract;
EXECUTE Suppliers_Extract;
EXECUTE Orders_Extract('2013-01-04');
EXECUTE Locations_Transform;
EXECUTE Customers_Transform;
EXECUTE SalesPeople_Transform;
EXECUTE Products_Transform;
EXECUTE Suppliers_Transform;
EXECUTE Factorders_Transform;
EXECUTE Customers_Load;
EXECUTE Products_Load;
EXECUTE SalesPeople_Load;
EXECUTE Location_Load;
EXECUTE Suppliers_load;
EXECUTE Orders_Load;

END;

-- After this we can execute the Query Done in Requirement 3 and it is working fine. 

SELECT * FROM FactSales;
SELECT * FROM DimLocation;
SELECT * FROM DimCustomers;
SELECT * FROM DimProducts;
SELECT * FROM DimSalesPeople;
SELECT * FROM DimSuppliers;
