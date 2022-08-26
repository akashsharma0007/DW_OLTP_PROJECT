/*
fINAL PROJECT
PROG8620-22S-Sec2-Data Warehouse
Saeed Moghadam
Delmi Alarcon
Akash Sharma
Verinder Singh
Professor: Prof. Osama Ali
*/

-----------------------------------------------------------------------------------------------------------------------------
--  Star-Schema Dimensional Model  
-------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Table DIMCUSTOMERS
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMCUSTOMERS" (
    "CUST_KEY"     NUMBER(10, 0),
    "CUST_NAME"    NVARCHAR2(100),
    "CUST_DOB"     DATE,
    "CUST_GENDER"  NVARCHAR2(1),
    "CUST_COUNTRY" NVARCHAR2(20),
    "CUST_STATE"   NVARCHAR2(50),
    "CUST_CITY"    NVARCHAR2(50),
    "STARTDATE"    DATE,
    "ENDDATE"      DATE
);
--------------------------------------------------------
--  DDL for Index UIX_DIMCUSTOMERS_CUSTNAME
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMCUSTOMERS_CUSTNAME" ON
    "DWPR"."DIMCUSTOMERS" (
        "CUST_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_DIMCUSTOMERS
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMCUSTOMERS" ON
    "DWPR"."DIMCUSTOMERS" (
        "CUST_KEY"
    );
--------------------------------------------------------
--  Constraints for Table DIMCUSTOMERS
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMCUSTOMERS" MODIFY (
    "STARTDATE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMCUSTOMERS"
    ADD CONSTRAINT "PK_DIMCUSTOMERS" PRIMARY KEY ( "CUST_KEY" )
        USING INDEX "DWPR"."PK_DIMCUSTOMERS"
    ENABLE;
  
  --------------------------------------------------------
--  DDL for Table DIMDATE
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMDATE" (
    "DATEKEY"       NUMBER(10, 0),
    "DATEVALUE"     DATE,
    "CYEAR"         NUMBER(10, 0),
    "CMONTH"        NUMBER(2, 0),
    "DAYNO"         NUMBER(2, 0),
    "CQTR"          NUMBER,
    "MONTHNAME"     VARCHAR2(10 BYTE),
    "DAYOFWEEKNAME" VARCHAR2(10 BYTE),
    "STARTOFYEAR"   DATE,
    "ENDOFYEAR"     DATE,
    "YEAR_SPAN"     NUMBER(3, 0),
    "STARTOFQTR"    DATE,
    "ENDOFQTR"      DATE,
    "QTR_SPAN"      NUMBER(3, 0),
    "STARTOFMONTH"  DATE,
    "ENDOFMONTH"    DATE,
    "MONTH_SPAN"    NUMBER(3, 0)
)
NO INMEMORY;
--------------------------------------------------------
--  DDL for Index PK_DIMDATE_DATEKEY
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMDATE_DATEKEY" ON
    "DWPR"."DIMDATE" (
        "DATEKEY"
    );
--------------------------------------------------------
--  DDL for Index UIX_DIMDATE_DATEVALUE
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMDATE_DATEVALUE" ON
    "DWPR"."DIMDATE" (
        "DATEVALUE"
    );
--------------------------------------------------------
--  Constraints for Table DIMDATE
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "DATEKEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "DATEVALUE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "CYEAR"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "CMONTH"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "DAYNO"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "CQTR"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "MONTHNAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "DAYOFWEEKNAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "STARTOFYEAR"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "ENDOFYEAR"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "YEAR_SPAN"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "STARTOFQTR"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "ENDOFQTR"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "QTR_SPAN"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "STARTOFMONTH"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "ENDOFMONTH"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE" MODIFY (
    "MONTH_SPAN"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMDATE"
    ADD CONSTRAINT "PK_DIMDATE_DATEKEY" PRIMARY KEY ( "DATEKEY" )
        USING INDEX "DWPR"."PK_DIMDATE_DATEKEY"
    ENABLE;
--------------------------------------------------------
--  DDL for Table DIMLOCATION
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMLOCATION" (
    "LOC_KEY"      NUMBER(10, 0),
    "COUNTRY_NAME" NVARCHAR2(20),
    "STATE_NAME"   NVARCHAR2(50),
    "CITY_NAME"    NVARCHAR2(50)
);
--------------------------------------------------------
--  DDL for Index UIX_DIMLOCATION_CITYSATECOUNTRY
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMLOCATION_CITYSATECOUNTRY" ON
    "DWPR"."DIMLOCATION" (
        "CITY_NAME",
        "STATE_NAME",
        "COUNTRY_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_DIMLOCATION
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMLOCATION" ON
    "DWPR"."DIMLOCATION" (
        "LOC_KEY"
    );
--------------------------------------------------------
--  Constraints for Table DIMLOCATION
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMLOCATION"
    ADD CONSTRAINT "PK_DIMLOCATION" PRIMARY KEY ( "LOC_KEY" )
        USING INDEX "DWPR"."PK_DIMLOCATION"
    ENABLE;
--------------------------------------------------------
--  DDL for Table DIMPRODUCTS
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMPRODUCTS" (
    "PROD_KEY"          NUMBER(10, 0),
    "PROD_NAME"         NVARCHAR2(1000),
    "PROD_NAMEDES"      NVARCHAR2(1000),
    "PROD_CATEGORY"     NVARCHAR2(1000),
    "PROD_CATEGORYDESC" NVARCHAR2(1000),
    "STARTDATE"         DATE,
    "ENDDATE"           DATE
);
--------------------------------------------------------
--  DDL for Index UIX_DIMPRODUCTS_PRODNAME
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMPRODUCTS_PRODNAME" ON
    "DWPR"."DIMPRODUCTS" (
        "PROD_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_DIMPRODUCTS
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMPRODUCTS" ON
    "DWPR"."DIMPRODUCTS" (
        "PROD_KEY"
    );
--------------------------------------------------------
--  Constraints for Table DIMPRODUCTS
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMPRODUCTS" MODIFY (
    "STARTDATE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."DIMPRODUCTS"
    ADD CONSTRAINT "PK_DIMPRODUCTS" PRIMARY KEY ( "PROD_KEY" )
        USING INDEX "DWPR"."PK_DIMPRODUCTS"
    ENABLE;
--------------------------------------------------------
--  DDL for Table DIMPROMOTION
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMPROMOTION" (
    "PROMO_KEY"      NUMBER(10, 0),
    "PROMO_ID"       NUMBER(10, 0),
    "PROMO_NAME"     NVARCHAR2(200),
    "PROMO_CATEGORY" NVARCHAR2(100)
);
--------------------------------------------------------
--  DDL for Index UIX_DIMPROMOTION_PRMOID
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMPROMOTION_PRMOID" ON
    "DWPR"."DIMPROMOTION" (
        "PROMO_ID"
    );
--------------------------------------------------------
--  DDL for Index PK_DIMPROMOTION
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMPROMOTION" ON
    "DWPR"."DIMPROMOTION" (
        "PROMO_KEY"
    );
--------------------------------------------------------
--  Constraints for Table DIMPROMOTION
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMPROMOTION"
    ADD CONSTRAINT "PK_DIMPROMOTION" PRIMARY KEY ( "PROMO_KEY" )
        USING INDEX "DWPR"."PK_DIMPROMOTION"
    ENABLE;
--------------------------------------------------------
--  DDL for Table DIMSALECHANNEL
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMSALECHANNEL" (
    "CHNL_KEY"  NUMBER(10, 0),
    "CHNL_NAME" NVARCHAR2(50)
);
--------------------------------------------------------
--  DDL for Index UIX_DIMSALECHANNEL_CHNLNAME
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMSALECHANNEL_CHNLNAME" ON
    "DWPR"."DIMSALECHANNEL" (
        "CHNL_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_DIMSALECHANNEL
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMSALECHANNEL" ON
    "DWPR"."DIMSALECHANNEL" (
        "CHNL_KEY"
    );
--------------------------------------------------------
--  Constraints for Table DIMSALECHANNEL
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMSALECHANNEL"
    ADD CONSTRAINT "PK_DIMSALECHANNEL" PRIMARY KEY ( "CHNL_KEY" )
        USING INDEX "DWPR"."PK_DIMSALECHANNEL"
    ENABLE;
--------------------------------------------------------
--  DDL for Table DIMSALESPEOPLE
--------------------------------------------------------

CREATE TABLE "DWPR"."DIMSALESPEOPLE" (
    "EMP_KEY"   NUMBER(10, 0),
    "EMP_NAME"  NVARCHAR2(100),
    "EMP_EMAIL" NVARCHAR2(200),
    "EMP_PHONE" NVARCHAR2(100)
);
--------------------------------------------------------
--  DDL for Index UIX_DIMSALESPEOPLE_EMPNAME
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_DIMSALESPEOPLE_EMPNAME" ON
    "DWPR"."DIMSALESPEOPLE" (
        "EMP_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_DIMSALESPEOPLE
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_DIMSALESPEOPLE" ON
    "DWPR"."DIMSALESPEOPLE" (
        "EMP_KEY"
    );
--------------------------------------------------------
--  Constraints for Table DIMSALESPEOPLE
--------------------------------------------------------

ALTER TABLE "DWPR"."DIMSALESPEOPLE"
    ADD CONSTRAINT "PK_DIMSALESPEOPLE" PRIMARY KEY ( "EMP_KEY" )
        USING INDEX "DWPR"."PK_DIMSALESPEOPLE"
    ENABLE;
--------------------------------------------------------
--  DDL for Table FACTORDERS
--------------------------------------------------------

CREATE TABLE "DWPR"."FACTORDERS" (
    "CUST_KEY"   NUMBER(10, 0),
    "LOC_KEY"    NUMBER(10, 0),
    "PROD_KEY"   NUMBER(10, 0),
    "EMP_KEY"    NUMBER(10, 0),
    "PROMO_KEY"  NUMBER(10, 0),
    "CHNL_KEY"   NUMBER(10, 0),
    "DATEKEY"    NUMBER(10, 0),
    "QUANTITY"   NUMBER(4, 0),
    "UNITPRICE"  NUMBER(18, 2),
    "TOTALPRICE" NUMBER(18, 2)
);
--------------------------------------------------------
--  DDL for Index IX_FACTORDERS_PROMOKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTORDERS_PROMOKEY" ON
    "DWPR"."FACTORDERS" (
        "PROMO_KEY"
    );
--------------------------------------------------------
--  DDL for Index IX_FACTSALES_DATEKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTSALES_DATEKEY" ON
    "DWPR"."FACTORDERS" (
        "DATEKEY"
    );
--------------------------------------------------------
--  DDL for Index IX_FACTSALES_CUSTKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTSALES_CUSTKEY" ON
    "DWPR"."FACTORDERS" (
        "CUST_KEY"
    );
--------------------------------------------------------
--  DDL for Index IX_FACTSALES_PRODKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTSALES_PRODKEY" ON
    "DWPR"."FACTORDERS" (
        "PROD_KEY"
    );
--------------------------------------------------------
--  DDL for Index IX_FACTSALES_CHNLKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTSALES_CHNLKEY" ON
    "DWPR"."FACTORDERS" (
        "CHNL_KEY"
    );
--------------------------------------------------------
--  DDL for Index IX_FACTSALES_EMPKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTSALES_EMPKEY" ON
    "DWPR"."FACTORDERS" (
        "EMP_KEY"
    );
--------------------------------------------------------
--  DDL for Index IX_FACTSALES_LOCKEY
--------------------------------------------------------

CREATE INDEX "DWPR"."IX_FACTSALES_LOCKEY" ON
    "DWPR"."FACTORDERS" (
        "LOC_KEY"
    );
--------------------------------------------------------
--  DDL for Index UIX_FACTORDERS_FOREIGNKEYS
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UIX_FACTORDERS_FOREIGNKEYS" ON
    "DWPR"."FACTORDERS" (
        "CUST_KEY",
        "LOC_KEY",
        "PROD_KEY",
        "PROMO_KEY",
        "CHNL_KEY",
        "EMP_KEY",
        "DATEKEY"
    );
--------------------------------------------------------
--  Constraints for Table FACTORDERS
--------------------------------------------------------

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "CUST_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "LOC_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "CHNL_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "PROD_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "EMP_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "PROMO_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "DATEKEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "QUANTITY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "UNITPRICE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS" MODIFY (
    "TOTALPRICE"
        NOT NULL ENABLE
);
--------------------------------------------------------
--  Ref Constraints for Table FACTORDERS
--------------------------------------------------------

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_CUSTKEY" FOREIGN KEY ( "CUST_KEY" )
        REFERENCES "DWPR"."DIMCUSTOMERS" ( "CUST_KEY" )
    ENABLE;

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_PROMOKEY" FOREIGN KEY ( "PROMO_KEY" )
        REFERENCES "DWPR"."DIMPROMOTION" ( "PROMO_KEY" )
    ENABLE;

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_PRODKEY" FOREIGN KEY ( "PROD_KEY" )
        REFERENCES "DWPR"."DIMPRODUCTS" ( "PROD_KEY" )
    ENABLE;

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_EMPKEY" FOREIGN KEY ( "EMP_KEY" )
        REFERENCES "DWPR"."DIMSALESPEOPLE" ( "EMP_KEY" )
    ENABLE;

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_DATEKEY" FOREIGN KEY ( "DATEKEY" )
        REFERENCES "DWPR"."DIMDATE" ( "DATEKEY" )
    ENABLE;

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_CHNLKEY" FOREIGN KEY ( "CHNL_KEY" )
        REFERENCES "DWPR"."DIMSALECHANNEL" ( "CHNL_KEY" )
    ENABLE;

ALTER TABLE "DWPR"."FACTORDERS"
    ADD CONSTRAINT "FK_FACTORDERS_LOCKEY" FOREIGN KEY ( "LOC_KEY" )
        REFERENCES "DWPR"."DIMLOCATION" ( "LOC_KEY" )
    ENABLE;
      
-----------------------------------------------------------------------------------------------------------------------------
--  ETL process- Initialization  
-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure DIMDATE_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."DIMDATE_LOAD" (
    datevalue DATE
) AS

    datekey       NUMBER(10, 0);
    cyear         NUMBER(10, 0);
    cmonth        NUMBER(2, 0);
    dayno         NUMBER(2, 0);
    cqtr          NUMBER;
    monthname     VARCHAR2(10 BYTE);
    dayofweekname VARCHAR2(10 BYTE);
    startofyear   DATE;
    endofyear     DATE;
    year_span     NUMBER(3);
    startofqtr    DATE;
    endofqtr      DATE;
    qtr_span      NUMBER(3);
    startofmonth  DATE;
    endofmonth    DATE;
    month_span    NUMBER(3);
BEGIN
    datekey := to_number(to_char(datevalue, 'YYYYMMDD'));
    cyear := extract(YEAR FROM datevalue);
    cmonth := extract(MONTH FROM datevalue);
    dayno := extract(DAY FROM datevalue);
    cqtr := to_number(to_char(datevalue, 'Q'));
    monthname := to_char(datevalue, 'MON');
    dayofweekname := to_char(datevalue, 'DAY');
    startofyear := trunc(datevalue, 'YEAR');
    endofyear := add_months(startofyear, 12);
    year_span := to_number(endofyear - startofyear);
    startofqtr := trunc(datevalue, 'Q');
    endofqtr := add_months(startofqtr, 3);
    qtr_span := to_number(endofqtr - startofqtr);
    startofmonth := trunc(datevalue, 'MONTH');
    endofmonth := add_months(trunc(datevalue, 'MONTH'), 1) - 1;
    month_span := to_number(endofmonth - startofmonth);
    INSERT INTO dimdate VALUES (
        datekey,
        datevalue,
        cyear,
        cmonth,
        dayno,
        cqtr,
        monthname,
        dayofweekname,
        startofyear,
        endofyear,
        year_span,
        startofqtr,
        endofqtr,
        qtr_span,
        startofmonth,
        endofmonth,
        month_span
    );

END;
/
-----------------------------------------------------------------------------------------------------------------------------
--  ETL process- Extract 
-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CUSTOMERS_STAGE
--------------------------------------------------------

CREATE TABLE "DWPR"."CUSTOMERS_STAGE" (
    "CUST_NAME"    NVARCHAR2(50),
    "CUST_DOB"     DATE,
    "CUST_GENDER"  NVARCHAR2(1),
    "CUST_COUNTRY" NVARCHAR2(50),
    "CUST_STATE"   NVARCHAR2(50),
    "CUST_CITY"    NVARCHAR2(50)
);
--------------------------------------------------------
--  DDL for Table ORDERS_STAGE
--------------------------------------------------------

CREATE TABLE "DWPR"."ORDERS_STAGE" (
    "CUST_NAME"    NVARCHAR2(100),
    "COUNTRY_NAME" NVARCHAR2(20),
    "STATE_NAME"   NVARCHAR2(50),
    "CITY_NAME"    NVARCHAR2(50),
    "PROD_NAME"    NVARCHAR2(200),
    "EMP_NAME"     NVARCHAR2(100),
    "PROMO_ID"     NVARCHAR2(200),
    "CHNL_NAME"    NVARCHAR2(50),
    "ORDERDATE"    DATE,
    "QUANTITY"     NUMBER(4, 0),
    "UNITPRICE"    NUMBER(18, 2)
);
--------------------------------------------------------
--  DDL for Table PRODUCTS_STAGE
--------------------------------------------------------

CREATE TABLE "DWPR"."PRODUCTS_STAGE" (
    "PROD_NAME"         NVARCHAR2(1000),
    "PROD_NAMEDES"      NVARCHAR2(1000),
    "PROD_CATEGORY"     NVARCHAR2(1000),
    "PROD_CATEGORYDESC" NVARCHAR2(1000)
);
--------------------------------------------------------
--  DDL for Table PROMOTION_STAGE
--------------------------------------------------------

CREATE TABLE "DWPR"."PROMOTION_STAGE" (
    "PROMO_ID"       NUMBER(10, 0),
    "PROMO_NAME"     NVARCHAR2(200),
    "PROMO_CATEGORY" NVARCHAR2(100)
);
--------------------------------------------------------
--  DDL for Table SALESPEOPLE_STAGE
--------------------------------------------------------

CREATE TABLE "DWPR"."SALESPEOPLE_STAGE" (
    "EMP_NAME"  NVARCHAR2(100) DEFAULT 'Online Sale',
    "EMP_EMAIL" NVARCHAR2(200) DEFAULT 'No Email',
    "EMP_PHONE" NVARCHAR2(100) DEFAULT 'No Phone'
);
--------------------------------------------------------
--  DDL for Procedure CUSTOMERS_EXTRACT
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."CUSTOMERS_EXTRACT" (
    date_ext DATE
) IS
    rowct NUMBER(10);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CUSTOMERS_STAGE';
    INSERT INTO customers_stage
        SELECT
            ( cust_first_name
              || ' '
              || cust_last_name ) AS "CUST_NAME",
            date_of_birth,
            gender,
            nls_territory,
            cus.cust_address.state_province,
            cus.cust_address.city
        FROM
            oe.customers cus
        WHERE
            EXISTS (
                SELECT
                    1
                FROM
                    oe.orders ord
                WHERE
                        trunc(CAST(order_date AS DATE)) = date_ext
                    AND ord.customer_id = cus.customer_id
            );

    rowct := SQL%rowcount;
    dbms_output.put_line('EXTRACT_STAGE ABLE==>'
                         || 'Number of customers added: '
                         || to_char(SQL%rowcount));
END;
/

--------------------------------------------------------
--  DDL for Procedure PRODUCTS_EXTRACT
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."PRODUCTS_EXTRACT" (
    date_ext DATE
) AS
    rowct NUMBER(10);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE PRODUCTS_STAGE';
    INSERT INTO products_stage
        SELECT
            pr.product_name,
            pr.product_description,
            ca.category_name,
            ca.category_description
        FROM
            oe.product_information pr
            LEFT JOIN oe.categories_tab      ca ON pr.category_id = ca.category_id
        WHERE
            EXISTS (
                SELECT
                    1
                FROM
                         oe.orders ord
                    INNER JOIN oe.order_items oit ON ord.order_id = oit.order_id
                WHERE
                        trunc(CAST(order_date AS DATE)) = date_ext
                    AND oit.product_id = pr.product_id
            );

    rowct := SQL%rowcount;
    dbms_output.put_line('EXTRACT_STAGE ABLE==>'
                         || 'Number of products added: '
                         || to_char(rowct));
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('errors:' || sqlerrm);
END;
/
--------------------------------------------------------
--  DDL for Procedure PROMOTION_EXTRACT
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."PROMOTION_EXTRACT" (
    date_ext DATE
) IS
    rowct NUMBER(10);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE PROMOTION_STAGE';
    INSERT INTO promotion_stage
        SELECT
            prom.promo_id,
            prom.promo_name,
            prom.promo_category
        FROM
            oe.promotions prom
        WHERE
            EXISTS (
                SELECT
                    1
                FROM
                    oe.orders ord
                WHERE
                        trunc(CAST(order_date AS DATE)) = date_ext
                    AND ord.promotion_id = prom.promo_id
            );

    rowct := SQL%rowcount;
    dbms_output.put_line('EXTRACT_STAGE ABLE==>'
                         || 'Number of promotions added: '
                         || to_char(SQL%rowcount));
END;
/
--------------------------------------------------------
--  DDL for Procedure SALESPEOPLE_EXTRACT
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."SALESPEOPLE_EXTRACT" (
    date_ext DATE
) AS
    count_null NUMBER(3) := 0;
    rowct      NUMBER(10);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SALESPEOPLE_STAGE';
    INSERT INTO salespeople_stage
        SELECT
            ( first_name
              || ' '
              || last_name ) AS "emp_name",
            email          AS "emp_email",
            phone_number   AS "emp_phone"
        FROM
            hr.employees emp
        WHERE
            EXISTS (
                SELECT
                    1
                FROM
                    oe.orders ord
                WHERE
                        trunc(CAST(order_date AS DATE)) = date_ext
                    AND ord.sales_rep_id = emp.employee_id
            );

    rowct := SQL%rowcount;
    SELECT
        COUNT(*)
    INTO count_null
    FROM
        oe.orders ord
    WHERE
            trunc(CAST(order_date AS DATE)) = date_ext
        AND ord.sales_rep_id IS NULL;

    IF ( count_null > 0 ) THEN
        INSERT INTO salespeople_stage VALUES ( DEFAULT, DEFAULT, DEFAULT );

        rowct := rowct + 1;
    END IF;

    dbms_output.put_line('EXTRACT_STAGE ABLE==>'
                         || 'Number of salespeople added: '
                         || to_char(rowct));
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('errors:' || sqlerrm);
END;
/
--------------------------------------------------------
--  DDL for Procedure ORDERS_EXTRACT
--------------------------------------------------------
CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."ORDERS_EXTRACT" (
    date_extract DATE
) AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE ORDERS_STAGE DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO orders_stage
        WITH order_cte (
            customer_id,
            product_id,
            sales_rep_id,
            promotion_id,
            chnl_name,
            orderdate,
            quantity,
            unitprice
        ) AS (
            SELECT
                ord.customer_id,
                oit.product_id,
                ord.sales_rep_id,
                ord.promotion_id,
                ord.order_mode,
                ord.order_date,
                oit.quantity,
                oit.unit_price
            FROM
                oe.orders      ord
                LEFT JOIN oe.order_items oit ON ord.order_id = oit.order_id
        )
        SELECT
            ( cust_first_name
              || ' '
              || cust_last_name )             AS "CUST_NAME",
            cus.nls_territory               AS "COUNTRY_NAME",
            cus.cust_address.state_province AS "STATE_NAME",
            cus.cust_address.city           AS "CITY_NAME",
            pr.product_name,
            ( nvl(first_name, 'Online')
              || ' '
              || nvl(last_name, 'Sale') )     AS "emp_name",
            prom.promo_id,
            chnl_name,
            orderdate,
            quantity,
            unitprice
        FROM
            order_cte              cte
            LEFT JOIN oe.customers           cus ON cte.customer_id = cus.customer_id
            LEFT JOIN oe.product_information pr ON cte.product_id = pr.product_id
            LEFT JOIN hr.employees           emp ON cte.sales_rep_id = emp.employee_id
            LEFT JOIN oe.promotions          prom ON cte.promotion_id = prom.promo_id
        WHERE
            trunc(CAST(cte.orderdate AS DATE)) = date_extract;

    rowct := SQL%rowcount;
    IF SQL%notfound THEN
        dbms_output.put_line('No records found. Check with source system.');
    ELSIF SQL%found THEN
        dbms_output.put_line('EXTRACT_STAGE ABLE==>'
                             || 'Number of orders added: '
                             || to_char(rowct));
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(v_sql);
END;
/

-----------------------------------------------------------------------------------------------------------------------------
--  ETL process- Transform
-------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Table CUSTOMERS_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."CUSTOMERS_PRELOAD" (
    "CUST_KEY"     NUMBER(10, 0),
    "CUST_NAME"    NVARCHAR2(100),
    "CUST_DOB"     DATE,
    "CUST_GENDER"  NVARCHAR2(1),
    "CUST_COUNTRY" NVARCHAR2(20),
    "CUST_STATE"   NVARCHAR2(50),
    "CUST_CITY"    NVARCHAR2(50),
    "STARTDATE"    DATE,
    "ENDDATE"      DATE
);
--------------------------------------------------------
--  DDL for Index UQ_CUSTOMERS_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UQ_CUSTOMERS_PRELOAD" ON
    "DWPR"."CUSTOMERS_PRELOAD" (
        "CUST_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_CUSTOMERS_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_CUSTOMERS_PRELOAD" ON
    "DWPR"."CUSTOMERS_PRELOAD" (
        "CUST_KEY"
    );
--------------------------------------------------------
--  Constraints for Table CUSTOMERS_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."CUSTOMERS_PRELOAD" MODIFY (
    "CUST_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."CUSTOMERS_PRELOAD" MODIFY (
    "STARTDATE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."CUSTOMERS_PRELOAD"
    ADD UNIQUE ( "CUST_NAME" )
        USING INDEX "DWPR"."UQ_CUSTOMERS_PRELOAD"
    ENABLE;

ALTER TABLE "DWPR"."CUSTOMERS_PRELOAD"
    ADD CONSTRAINT "PK_CUSTOMERS_PRELOAD" PRIMARY KEY ( "CUST_KEY" )
        USING INDEX "DWPR"."PK_CUSTOMERS_PRELOAD"
    ENABLE;

--------------------------------------------------------
--  DDL for Table LOCATION_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."LOCATION_PRELOAD" (
    "LOC_KEY"      NUMBER(10, 0),
    "COUNTRY_NAME" NVARCHAR2(20),
    "STATE_NAME"   NVARCHAR2(50),
    "CITY_NAME"    NVARCHAR2(50)
);
--------------------------------------------------------
--  DDL for Index PK_LOCATION_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_LOCATION_PRELOAD" ON
    "DWPR"."LOCATION_PRELOAD" (
        "LOC_KEY"
    );
--------------------------------------------------------
--  DDL for Index UQ_LOCATION_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UQ_LOCATION_PRELOAD" ON
    "DWPR"."LOCATION_PRELOAD" (
        "CITY_NAME",
        "STATE_NAME",
        "COUNTRY_NAME"
    );
--------------------------------------------------------
--  Constraints for Table LOCATION_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."LOCATION_PRELOAD" MODIFY (
    "COUNTRY_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."LOCATION_PRELOAD" MODIFY (
    "STATE_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."LOCATION_PRELOAD" MODIFY (
    "CITY_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."LOCATION_PRELOAD"
    ADD CONSTRAINT "PK_LOCATION_PRELOAD" PRIMARY KEY ( "LOC_KEY" )
        USING INDEX enable;

ALTER TABLE "DWPR"."LOCATION_PRELOAD"
    ADD CONSTRAINT "UQ_LOCATION_PRELOAD" UNIQUE ( "CITY_NAME",
                                                  "STATE_NAME",
                                                  "COUNTRY_NAME" )
        USING INDEX enable;
--------------------------------------------------------
--  DDL for Table PRODUCTS_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."PRODUCTS_PRELOAD" (
    "PROD_KEY"          NUMBER(10, 0),
    "PROD_NAME"         NVARCHAR2(1000),
    "PROD_NAMEDES"      NVARCHAR2(1000),
    "PROD_CATEGORY"     NVARCHAR2(1000),
    "PROD_CATEGORYDESC" NVARCHAR2(1000),
    "STARTDATE"         DATE,
    "ENDDATE"           DATE
);
--------------------------------------------------------
--  DDL for Index UQ_PRODUCTS_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UQ_PRODUCTS_PRELOAD" ON
    "DWPR"."PRODUCTS_PRELOAD" (
        "PROD_NAME"
    );
--------------------------------------------------------
--  DDL for Index PK_PRODUCTS_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_PRODUCTS_PRELOAD" ON
    "DWPR"."PRODUCTS_PRELOAD" (
        "PROD_KEY"
    );
--------------------------------------------------------
--  Constraints for Table PRODUCTS_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."PRODUCTS_PRELOAD" MODIFY (
    "PROD_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."PRODUCTS_PRELOAD" MODIFY (
    "STARTDATE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."PRODUCTS_PRELOAD"
    ADD CONSTRAINT "PK_PRODUCTS_PRELOAD" PRIMARY KEY ( "PROD_KEY" )
        USING INDEX enable;

ALTER TABLE "DWPR"."PRODUCTS_PRELOAD" ADD CONSTRAINT "UQ_PRODUCTS_PRELOAD" UNIQUE ( "PROD_NAME" )
    USING INDEX enable;
--------------------------------------------------------
--  DDL for Table PROMOTION_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."PROMOTION_PRELOAD" (
    "PROMO_KEY"      NUMBER(10, 0),
    "PROMO_ID"       NUMBER(10, 0),
    "PROMO_NAME"     NVARCHAR2(200),
    "PROMO_CATEGORY" NVARCHAR2(100)
);
--------------------------------------------------------
--  DDL for Index PK_PROMOTION_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_PROMOTION_PRELOAD" ON
    "DWPR"."PROMOTION_PRELOAD" (
        "PROMO_KEY"
    );
--------------------------------------------------------
--  DDL for Index UQ_PROMOTION_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UQ_PROMOTION_PRELOAD" ON
    "DWPR"."PROMOTION_PRELOAD" (
        "PROMO_ID"
    );
--------------------------------------------------------
--  Constraints for Table PROMOTION_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."PROMOTION_PRELOAD" MODIFY (
    "PROMO_ID"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."PROMOTION_PRELOAD"
    ADD CONSTRAINT "PK_PROMOTION_PRELOAD" PRIMARY KEY ( "PROMO_KEY" )
        USING INDEX enable;

ALTER TABLE "DWPR"."PROMOTION_PRELOAD" ADD CONSTRAINT "UQ_PROMOTION_PRELOAD" UNIQUE ( "PROMO_ID" )
    USING INDEX enable;
--------------------------------------------------------
--  DDL for Table SALECHANNEL_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."SALECHANNEL_PRELOAD" (
    "CHNL_KEY"  NUMBER(10, 0),
    "CHNL_NAME" NVARCHAR2(50)
);
--------------------------------------------------------
--  DDL for Index PK_SALECHANNEL_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_SALECHANNEL_PRELOAD" ON
    "DWPR"."SALECHANNEL_PRELOAD" (
        "CHNL_KEY"
    );
--------------------------------------------------------
--  DDL for Index UQ_SALECHANNEL_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UQ_SALECHANNEL_PRELOAD" ON
    "DWPR"."SALECHANNEL_PRELOAD" (
        "CHNL_NAME"
    );
--------------------------------------------------------
--  Constraints for Table SALECHANNEL_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."SALECHANNEL_PRELOAD" MODIFY (
    "CHNL_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."SALECHANNEL_PRELOAD"
    ADD CONSTRAINT "PK_SALECHANNEL_PRELOAD" PRIMARY KEY ( "CHNL_KEY" )
        USING INDEX enable;

ALTER TABLE "DWPR"."SALECHANNEL_PRELOAD" ADD CONSTRAINT "UQ_SALECHANNEL_PRELOAD" UNIQUE ( "CHNL_NAME" )
    USING INDEX enable;
--------------------------------------------------------
--  DDL for Table SALESPEOPLE_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."SALESPEOPLE_PRELOAD" (
    "EMP_KEY"   NUMBER(10, 0),
    "EMP_NAME"  NVARCHAR2(100),
    "EMP_EMAIL" NVARCHAR2(200),
    "EMP_PHONE" NVARCHAR2(100)
);
--------------------------------------------------------
--  DDL for Index PK_SALESPEOPLE_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."PK_SALESPEOPLE_PRELOAD" ON
    "DWPR"."SALESPEOPLE_PRELOAD" (
        "EMP_KEY"
    );
--------------------------------------------------------
--  DDL for Index UQ_SALESPEOPLE_PRELOAD
--------------------------------------------------------

CREATE UNIQUE INDEX "DWPR"."UQ_SALESPEOPLE_PRELOAD" ON
    "DWPR"."SALESPEOPLE_PRELOAD" (
        "EMP_NAME"
    );
--------------------------------------------------------
--  Constraints for Table SALESPEOPLE_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."SALESPEOPLE_PRELOAD" MODIFY (
    "EMP_NAME"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."SALESPEOPLE_PRELOAD"
    ADD CONSTRAINT "PK_SALESPEOPLE_PRELOAD" PRIMARY KEY ( "EMP_KEY" )
        USING INDEX enable;

ALTER TABLE "DWPR"."SALESPEOPLE_PRELOAD" ADD CONSTRAINT "UQ_SALESPEOPLE_PRELOAD" UNIQUE ( "EMP_NAME" )
    USING INDEX enable;

--------------------------------------------------------
--  DDL for Table FACTORDERS_PRELOAD
--------------------------------------------------------

CREATE TABLE "DWPR"."FACTORDERS_PRELOAD" (
    "CUST_KEY"   NUMBER(10, 0),
    "LOC_KEY"    NUMBER(10, 0),
    "PROD_KEY"   NUMBER(10, 0),
    "EMP_KEY"    NUMBER(10, 0),
    "PROMO_KEY"  NUMBER(10, 0),
    "CHNL_KEY"   NUMBER(10, 0),
    "DATEKEY"    NUMBER(10, 0),
    "QUANTITY"   NUMBER(4, 0),
    "UNITPRICE"  NUMBER(18, 2),
    "TOTALPRICE" NUMBER(18, 2)
);
--------------------------------------------------------
--  Constraints for Table FACTORDERS_PRELOAD
--------------------------------------------------------

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "CUST_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "LOC_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "PROD_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "EMP_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "PROMO_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "CHNL_KEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "DATEKEY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "QUANTITY"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "UNITPRICE"
        NOT NULL ENABLE
);

ALTER TABLE "DWPR"."FACTORDERS_PRELOAD" MODIFY (
    "TOTALPRICE"
        NOT NULL ENABLE
);
  
--------------------------------------------------------
--  DDL for Create Required Sequences in Preload Tables
--------------------------------------------------------
CREATE SEQUENCE sq_customers_key_preload;

CREATE SEQUENCE sq_location_key_preload;

CREATE SEQUENCE sq_products_key_preload;

CREATE SEQUENCE sq_salespeople_key_preload;

CREATE SEQUENCE sq_promotion_key_preload;

CREATE SEQUENCE sq_salechannel_key_preload;

--------------------------------------------------------
--  DDL for Procedure CUSTOMERS_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."CUSTOMERS_TRANSFORM" (
    date_transform DATE
) AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE CUSTOMERS_PRELOAD DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO customers_preload
        SELECT
            sq_customers_key_preload.NEXTVAL,
            stg.cust_name,
            stg.cust_dob,
            stg.cust_gender,
            stg.cust_country,
            stg.cust_state,
            stg.cust_city,
            date_transform,
            NULL
        FROM
                 customers_stage stg
            INNER JOIN dimcustomers cu ON stg.cust_name = cu.cust_name
        WHERE
            stg.cust_dob <> cu.cust_dob
            OR stg.cust_gender <> cu.cust_gender
            OR stg.cust_country <> cu.cust_country
            OR stg.cust_state <> cu.cust_state
            OR stg.cust_city <> cu.cust_city;

    rowct := SQL%rowcount;
    INSERT INTO customers_preload
        SELECT
            cu.cust_key,
            cu.cust_name,
            cu.cust_dob,
            cu.cust_gender,
            cu.cust_country,
            cu.cust_state,
            cu.cust_city,
            cu.startdate,
            ( date_transform - 1 )
        FROM
                 customers_stage stg
            INNER JOIN dimcustomers cu ON stg.cust_name = cu.cust_name
        WHERE
            stg.cust_dob <> cu.cust_dob
            OR stg.cust_gender <> cu.cust_gender
            OR stg.cust_country <> cu.cust_country
            OR stg.cust_state <> cu.cust_state
            OR stg.cust_city <> cu.cust_city;

    rowct := rowct + SQL%rowcount;
    INSERT INTO customers_preload
        SELECT
            sq_customers_key_preload.NEXTVAL,
            stg.cust_name,
            stg.cust_dob,
            stg.cust_gender,
            stg.cust_country,
            stg.cust_state,
            stg.cust_city,
            date_transform,
            NULL
        FROM
            customers_stage stg
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    dimcustomers cu
                WHERE
                    stg.cust_name = cu.cust_name
            );

    rowct := rowct + SQL%rowcount;
    INSERT /*+ ignore_row_on_dupkey_index(CUSTOMERS_PRELOAD,PK_CUSTOMERS_PRELOAD) */ INTO customers_preload
        SELECT
            cu.cust_key,
            cu.cust_name,
            cu.cust_dob,
            cu.cust_gender,
            cu.cust_country,
            cu.cust_state,
            cu.cust_city,
            cu.startdate,
            NULL
        FROM
            dimcustomers cu;

    rowct := rowct + SQL%rowcount;
    COMMIT;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of customers added: '
                         || to_char(rowct));

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
END;
/

--------------------------------------------------------
--  DDL for Procedure LOCATIONS_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."LOCATIONS_TRANSFORM" AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE Location_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT /*+ ignore_row_on_dupkey_index(Location_Preload,UQ_LOCATION_PRELOAD) */ INTO location_preload
        SELECT
            sq_location_key_preload.NEXTVAL AS locationkey,
            stg.cust_country,
            stg.cust_state,
            stg.cust_city
        FROM
            customers_stage stg
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    dimlocation lo
                WHERE
                        stg.cust_country = lo.country_name
                    AND stg.cust_state = lo.state_name
                    AND stg.cust_city = lo.city_name
            );

    rowct := SQL%rowcount;
    INSERT /*+ ignore_row_on_dupkey_index(Location_Preload,UQ_LOCATION_PRELOAD) */ INTO location_preload
        SELECT
            lo.loc_key,
            lo.country_name,
            lo.state_name,
            lo.city_name
        FROM
            dimlocation lo;

    rowct := rowct + SQL%rowcount;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of location added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No records found. Check with source system.');
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(v_sql);
        ROLLBACK;
END;
/
--------------------------------------------------------
--  DDL for Procedure PRODUCTS_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."PRODUCTS_TRANSFORM" (
    date_transform DATE
) AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE PRODUCTS_PRELOAD DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO products_preload
        SELECT
            sq_products_key_preload.NEXTVAL,
            stg.prod_name,
            stg.prod_namedes,
            stg.prod_category,
            stg.prod_categorydesc,
            date_transform,
            NULL
        FROM
                 products_stage stg
            INNER JOIN dimproducts pr ON stg.prod_name = pr.prod_name
        WHERE
            stg.prod_category <> pr.prod_category;

    rowct := SQL%rowcount;
    INSERT INTO products_preload
        SELECT
            pr.prod_key,
            pr.prod_name,
            pr.prod_namedes,
            pr.prod_category,
            pr.prod_categorydesc,
            pr.startdate,
            ( date_transform - 1 )
        FROM
                 products_stage stg
            INNER JOIN dimproducts pr ON stg.prod_name = pr.prod_name
        WHERE
            stg.prod_category <> pr.prod_category;

    rowct := rowct + SQL%rowcount;
    INSERT INTO products_preload
        SELECT
            sq_products_key_preload.NEXTVAL,
            stg.prod_name,
            stg.prod_namedes,
            stg.prod_category,
            stg.prod_categorydesc,
            date_transform,
            NULL
        FROM
            products_stage stg
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    dimproducts pr
                WHERE
                    stg.prod_name = pr.prod_name
            );

    rowct := rowct + SQL%rowcount;
    INSERT /*+ ignore_row_on_dupkey_index(PRODUCTS_PRELOAD,PK_PRODUCTS_PRELOAD) */ INTO products_preload
        SELECT
            pr.prod_key,
            pr.prod_name,
            pr.prod_namedes,
            pr.prod_category,
            pr.prod_categorydesc,
            pr.startdate,
            NULL
        FROM
            dimproducts pr;

    rowct := rowct + SQL%rowcount;
    COMMIT;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of products added: '
                         || to_char(rowct));

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
END;
/
--------------------------------------------------------
--  DDL for Procedure PROMOTION_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."PROMOTION_TRANSFORM" AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE PROMOTION_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO promotion_preload
        SELECT
            sq_promotion_key_preload.NEXTVAL,
            stg.promo_id,
            stg.promo_name,
            stg.promo_category
        FROM
            promotion_stage stg
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    dimpromotion dprom
                WHERE
                    stg.promo_id = dprom.promo_id
            );

    rowct := SQL%rowcount;
    INSERT INTO promotion_preload
        SELECT
            dprom.promo_key,
            stg.promo_id,
            stg.promo_name,
            stg.promo_category
        FROM
                 promotion_stage stg
            JOIN dimpromotion dprom ON stg.promo_id = dprom.promo_id;

    rowct := rowct + SQL%rowcount;
    INSERT /*+ ignore_row_on_dupkey_index(PROMOTION_PRELOAD,PK_PROMOTION_PRELOAD) */ INTO promotion_preload
        SELECT
            dprom.promo_key,
            dprom.promo_id,
            dprom.promo_name,
            dprom.promo_category
        FROM
            dimpromotion dprom;

    rowct := rowct + SQL%rowcount;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of PROMOTION added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No records found. Check with source system.');
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(v_sql);
        ROLLBACK;
END;
/
--------------------------------------------------------
--  DDL for Procedure SALECHANNEL_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."SALECHANNEL_TRANSFORM" AS

    rowct   NUMBER(10) := 0;
    v_sql   VARCHAR(255) := 'TRUNCATE TABLE SALECHANNEL_preload DROP STORAGE';
    count_x NUMBER(4) := 0;
    CURSOR channel IS
    SELECT DISTINCT
        ( chnl_name )
    FROM
        orders_stage stg;

BEGIN
    EXECUTE IMMEDIATE v_sql;
    FOR item IN channel LOOP
        SELECT
            COUNT(*)
        INTO count_x
        FROM
            dimsalechannel dim
        WHERE
            dim.chnl_name = item.chnl_name;

        IF ( count_x = 0 ) THEN
            INSERT INTO salechannel_preload VALUES (
                sq_salechannel_key_preload.NEXTVAL,
                item.chnl_name
            );

            rowct := rowct + 1;
        END IF;

    END LOOP;

    INSERT /*+ ignore_row_on_dupkey_index(SALECHANNEL_PRELOAD,PK_SALECHANNEL_PRELOAD) */ INTO salechannel_preload
        SELECT
            dim.chnl_key,
            dim.chnl_name
        FROM
            dimsalechannel dim;

    rowct := rowct + SQL%rowcount;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of SALECHANNEL added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No records found. Check with source system.');
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(v_sql);
        ROLLBACK;
END;
/
--------------------------------------------------------
--  DDL for Procedure SALESPEOPLE_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."SALESPEOPLE_TRANSFORM" AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE Salespeople_Preload DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO salespeople_preload
        SELECT
            sq_salespeople_key_preload.NEXTVAL,
            sp.emp_name,
            sp.emp_email,
            sp.emp_phone
        FROM
            salespeople_stage sp
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    dimsalespeople dsp
                WHERE
                    sp.emp_name = dsp.emp_name
            );

    rowct := SQL%rowcount;
    INSERT INTO salespeople_preload
        SELECT
            dsp.emp_key,
            sp.emp_name,
            sp.emp_email,
            sp.emp_phone
        FROM
                 salespeople_stage sp
            JOIN dimsalespeople dsp ON sp.emp_name = dsp.emp_name;

    rowct := rowct + SQL%rowcount;
    INSERT /*+ ignore_row_on_dupkey_index(SALESPEOPLE_PRELOAD,PK_SALESPEOPLE_PRELOAD) */ INTO salespeople_preload
        SELECT
            dsp.emp_key,
            dsp.emp_name,
            dsp.emp_email,
            dsp.emp_phone
        FROM
            dimsalespeople dsp;

    rowct := rowct + SQL%rowcount;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of salespeople added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No records found. Check with source system.');
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(v_sql);
        ROLLBACK;
END;
/
--------------------------------------------------------
--  DDL for Procedure FACTORDERS_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."FACTORDERS_TRANSFORM" (
    date_transform DATE
) AS
    rowct NUMBER(10);
    v_sql VARCHAR(255) := 'TRUNCATE TABLE FACTORDERS_PRELOAD DROP STORAGE';
BEGIN
    EXECUTE IMMEDIATE v_sql;
    INSERT INTO factorders_preload
        SELECT
            cu.cust_key,
            lo.loc_key,
            pr.prod_key,
            sp.emp_key,
            prom.promo_key,
            chn.chnl_key,
            to_number(to_char(date_transform, 'YYYYMMDD')),
            SUM(ord.quantity),
            AVG(ord.unitprice),
            SUM(ord.quantity * ord.unitprice)
        FROM
                 orders_stage ord
            INNER JOIN customers_preload   cu ON ord.cust_name = cu.cust_name
            INNER JOIN location_preload    lo ON ord.city_name = lo.city_name
                                              AND ord.state_name = lo.state_name
                                              AND ord.country_name = lo.country_name
            INNER JOIN products_preload    pr ON ord.prod_name = pr.prod_name
            INNER JOIN salespeople_preload sp ON ord.emp_name = sp.emp_name
            INNER JOIN promotion_preload   prom ON ord.promo_id = prom.promo_id
            INNER JOIN salechannel_preload chn ON ord.chnl_name = chn.chnl_name
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    factorders fo
                WHERE
                        fo.cust_key = cu.cust_key
                    AND fo.loc_key = lo.loc_key
                    AND fo.prod_key = pr.prod_key
                    AND fo.emp_key = sp.emp_key
                    AND fo.promo_key = prom.promo_key
                    AND fo.chnl_key = chn.chnl_key
                    AND fo.datekey = to_number(to_char(date_transform, 'YYYYMMDD'))
            )
        GROUP BY
            to_number(to_char(date_transform, 'YYYYMMDD')),
            cust_key,
            loc_key,
            prod_key,
            emp_key,
            promo_key,
            chnl_key;

    rowct := SQL%rowcount;
    COMMIT;
    dbms_output.put_line('Transfom_preload==>'
                         || ''
                         || 'Number of orders added: '
                         || to_char(rowct));

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
END;
/
-----------------------------------------------------------------------------------------------------------------------------
--  ETL process- Load
-------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Procedure CUSTOMERS_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."CUSTOMERS_LOAD" AS
    rowct NUMBER(10);
BEGIN
    MERGE INTO dimcustomers dim
    USING (
              SELECT
                  *
              FROM
                  customers_preload
          )
    pr ON ( dim.cust_key = pr.cust_key )
    WHEN MATCHED THEN UPDATE
    SET dim.cust_name = pr.cust_name,
        dim.cust_dob = pr.cust_dob,
        dim.cust_gender = pr.cust_gender,
        dim.cust_country = pr.cust_country,
        dim.cust_state = pr.cust_state,
        dim.cust_city = pr.cust_city,
        dim.startdate = pr.startdate,
        dim.enddate = pr.enddate
    WHEN NOT MATCHED THEN
    INSERT
    VALUES
        ( pr.cust_key,
          pr.cust_name,
          pr.cust_dob,
          pr.cust_gender,
          pr.cust_country,
          pr.cust_state,
          pr.cust_city,
          pr.startdate,
          pr.enddate );

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of customers added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/
--------------------------------------------------------
--  DDL for Procedure LOCATION_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."LOCATION_LOAD" AS
    rowct NUMBER(10);
BEGIN
    MERGE INTO dimlocation dim
    USING (
              SELECT
                  *
              FROM
                  location_preload
          )
    pr ON ( dim.loc_key = pr.loc_key )
    WHEN MATCHED THEN UPDATE
    SET dim.city_name = pr.city_name,
        dim.state_name = pr.state_name,
        dim.country_name = pr.country_name
    WHEN NOT MATCHED THEN
    INSERT
    VALUES
        ( pr.loc_key,
          pr.country_name,
          pr.state_name,
          pr.city_name );

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of location added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/
--------------------------------------------------------
--  DDL for Procedure PRODUCTS_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."PRODUCTS_LOAD" AS
    rowct NUMBER(10);
BEGIN
    MERGE INTO dimproducts dim
    USING (
              SELECT
                  *
              FROM
                  products_preload
          )
    pr ON ( dim.prod_key = pr.prod_key )
    WHEN MATCHED THEN UPDATE
    SET dim.prod_name = pr.prod_name,
        dim.prod_namedes = pr.prod_namedes,
        dim.prod_category = pr.prod_category,
        dim.prod_categorydesc = pr.prod_categorydesc
    WHEN NOT MATCHED THEN
    INSERT
    VALUES
        ( pr.prod_key,
          pr.prod_name,
          pr.prod_namedes,
          pr.prod_category,
          pr.prod_categorydesc,
          pr.startdate,
          pr.enddate );

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of products added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/
--------------------------------------------------------
--  DDL for Procedure PROMOTION_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."PROMOTION_LOAD" AS
    rowct NUMBER(10);
BEGIN
    MERGE INTO dimpromotion dim
    USING (
              SELECT
                  *
              FROM
                  promotion_preload
          )
    pr ON ( dim.promo_key = pr.promo_key )
    WHEN MATCHED THEN UPDATE
    SET dim.promo_id = pr.promo_id,
        dim.promo_name = pr.promo_name,
        dim.promo_category = pr.promo_category
    WHEN NOT MATCHED THEN
    INSERT
    VALUES
        ( pr.promo_key,
          pr.promo_id,
          pr.promo_name,
          pr.promo_category );

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of PROMOTION added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/

--------------------------------------------------------
--  DDL for Procedure SALECHANNEL_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."SALECHANNEL_LOAD" AS
    rowct NUMBER(10);
BEGIN
    MERGE INTO dimsalechannel dim
    USING (
              SELECT
                  *
              FROM
                  salechannel_preload
          )
    pr ON ( dim.chnl_key = pr.chnl_key )
    WHEN MATCHED THEN UPDATE
    SET dim.chnl_name = pr.chnl_name
    WHEN NOT MATCHED THEN
    INSERT
    VALUES
        ( pr.chnl_key,
          pr.chnl_name );

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of SALECHANNEL added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/

--------------------------------------------------------
--  DDL for Procedure SALESPEOPLE_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."SALESPEOPLE_LOAD" AS
    rowct NUMBER(10);
BEGIN
    MERGE INTO dimsalespeople dim
    USING (
              SELECT
                  *
              FROM
                  salespeople_preload
          )
    pr ON ( dim.emp_key = pr.emp_key )
    WHEN MATCHED THEN UPDATE
    SET dim.emp_name = pr.emp_name,
        dim.emp_email = pr.emp_email,
        dim.emp_phone = pr.emp_phone
    WHEN NOT MATCHED THEN
    INSERT
    VALUES
        ( pr.emp_key,
          pr.emp_name,
          pr.emp_email,
          pr.emp_phone );

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of salespeople added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/

--------------------------------------------------------
--  DDL for Procedure FACTORDERS_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."FACTORDERS_LOAD" AS
    rowct NUMBER(10);
BEGIN
    rowct := SQL%rowcount;
    INSERT INTO factorders
        SELECT
            *
        FROM
            factorders_preload;

    rowct := SQL%rowcount;
    dbms_output.put_line('Load ==>'
                         || ''
                         || 'Number of orders added: '
                         || to_char(rowct));

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERRORS:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/
-----------------------------------------------------------------------------------------------------------------------------
--  ETL process- Execute ETL
-------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure EXCEUTE_ETL_EXTRACT
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."EXCEUTE_ETL_EXTRACT" (
    date_ext DATE
) AS
BEGIN
    dimdate_load(date_ext);
    customers_extract(date_ext);
    products_extract(date_ext);
    salespeople_extract(date_ext);
    promotion_extract(date_ext);
    orders_extract(date_ext);
    dbms_output.put_line('Extract process was successfully done for the date: ' || date_ext);
    dbms_output.put_line('------------------------------------------------');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('errors:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/
--------------------------------------------------------
--  DDL for Procedure EXCEUTE_ETL_TRANSFORM
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."EXCEUTE_ETL_TRANSFORM" (
    date_transfomation DATE
) AS
BEGIN
    customers_transform(date_transfomation);
    products_transform(date_transfomation);
    salespeople_transform();
    promotion_transform();
    locations_transform();
    salechannel_transform();
    factorders_transform(date_transfomation);
    dbms_output.put_line('Transform process was successfully done for the date: ' || date_transfomation);
    dbms_output.put_line('------------------------------------------------');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('errors:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/

--------------------------------------------------------
--  DDL for Procedure EXCEUTE_ETL_LOAD
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE PROCEDURE "DWPR"."EXCEUTE_ETL_LOAD" (
    date_load DATE
) AS
BEGIN
    customers_load;
    products_load;
    salespeople_load;
    promotion_load;
    location_load;
    salechannel_load;
    factorders_load;
    dbms_output.put_line('Loading process was successfully done for the date: ' || date_load);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('errors:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;
/

--------------------------------------------------------
--  TRUNCATE TABLES AND RESET SEQUENCE NUMBERS (JUST MAKING SURE
--  THAT EVERY THING IS IN THE FIRST STEP)
--------------------------------------------------------
TRUNCATE TABLE dimcustomers;

TRUNCATE TABLE dimdate;

TRUNCATE TABLE dimlocation;

TRUNCATE TABLE dimproducts;

TRUNCATE TABLE dimsalespeople;

TRUNCATE TABLE dimpromotion;

TRUNCATE TABLE dimsalechannel;

TRUNCATE TABLE factorders;

DROP SEQUENCE sq_customers_key_preload;

DROP SEQUENCE sq_location_key_preload;

DROP SEQUENCE sq_products_key_preload;

DROP SEQUENCE sq_salespeople_key_preload;

DROP SEQUENCE sq_promotion_key_preload;

DROP SEQUENCE sq_salechannel_key_preload;

CREATE SEQUENCE sq_customers_key_preload;

CREATE SEQUENCE sq_location_key_preload;

CREATE SEQUENCE sq_products_key_preload;

CREATE SEQUENCE sq_salespeople_key_preload;

CREATE SEQUENCE sq_promotion_key_preload;

CREATE SEQUENCE sq_salechannel_key_preload;

--------------------------------------------------------
--  EXECUTING THE WHOLE ETL PROCESS for all dates of available in table OE.ORDER
--------------------------------------------------------

SET SERVEROUTPUT ON;

DECLARE
    CURSOR ord_cur IS
    SELECT DISTINCT
        ( trunc(CAST(order_date AS DATE)) ) orderdate
    FROM
        oe.orders
    ORDER BY
        orderdate ASC;

BEGIN
    FOR item IN ord_cur LOOP
        exceute_etl_extract(item.orderdate);
        exceute_etl_transform(item.orderdate);
        exceute_etl_load(item.orderdate);
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('errors:' || sqlerrm);
        ROLLBACK;
        RAISE;
END;