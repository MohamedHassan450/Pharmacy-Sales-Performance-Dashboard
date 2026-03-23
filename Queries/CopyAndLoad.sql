--Table Pharmacy_Sales
CREATE Table Pharmacy_Sales 
(
    SalesID VARCHAR(200),
    DateKey VARCHAR(200),
    PharmacyID VARCHAR(200),
    ProductID VARCHAR(200),
    UnitsSold int,
    RevenueEUR text,
    CostEUR	text,
    MarginEUR text,
    PromoFlag VARCHAR(10)
);

\copy  Pharmacy_Sales from 'C:\Users\moham\OneDrive\Documents\Database\Pharmacy Sales\PharmacySales.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8'); 

UPDATE pharmacy_sales
set RevenueEUR = replace(RevenueEUR,'€',''),
    CostEUR = replace( CostEUR,'€',''),
    MarginEUR = replace(MarginEUR,'€','');

UPDATE pharmacy_sales
set RevenueEUR = replace(RevenueEUR,' ',''),
    CostEUR = replace( CostEUR,' ',''),
    MarginEUR = replace(MarginEUR,' ','');

UPDATE pharmacy_sales
set RevenueEUR = replace(RevenueEUR,',',''),
    CostEUR = replace( CostEUR,',',''),
    MarginEUR = replace(MarginEUR,',','');

ALTER TABLE pharmacy_sales
Alter Column RevenueEUR type decimal
USING trim(RevenueEUR)::decimal;

ALTER TABLE pharmacy_sales
Alter Column CostEUR type decimal
USING trim(CostEUR)::decimal;

ALTER TABLE pharmacy_sales
Alter Column MarginEUR type decimal
USING trim(MarginEUR)::decimal;

--Rename
Alter TABLE pharmacy_sales 
Rename  Column SalesID to Sales_ID
Alter TABLE pharmacy_sales 
Rename  Column DateKey to Date_Key; 

Alter TABLE pharmacy_sales 
Rename  Column  PharmacyID to Pharmacy_ID;

Alter TABLE pharmacy_sales 
Rename  Column  ProductID to Product_ID;

Alter TABLE pharmacy_sales 
Rename  Column   UnitsSold to Units_Sold;

Alter TABLE pharmacy_sales 
Rename  Column  RevenueEUR to Revenue_EUR;

Alter TABLE pharmacy_sales 
Rename  Column  CostEUR to Cost_EUR;

Alter TABLE pharmacy_sales 
Rename  Column  MarginEUR to Margin_EUR;

Alter TABLE pharmacy_sales 
Rename  Column  PromoFlag to Promo_Flag;

-------------------------------------------------------------------------------------------------------------------------------

--Date Table
CREATE TABLE Dim_Date_Pharmacy
(
    DateKey VARCHAR(200),
    Date Date,
    Year INT,
    Quarter int,
    MonthNumber int,
    MonthName VARCHAR(100),
    YearMonth VARCHAR(100)
)

\copy  Dim_Date_Pharmacy from 'C:\Users\moham\OneDrive\Documents\Database\Pharmacy Sales\DimDate.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

--Rename
ALTER TABLE dim_date_pharmacy
Rename column DateKey to Date_Key;


ALTER TABLE dim_date_pharmacy
Rename column  MonthNumber to Month_Number;

ALTER TABLE dim_date_pharmacy
Rename column  MonthName to Month_Name ;

ALTER TABLE dim_date_pharmacy
Rename column YearMonth to Year_Month;

-------------------------------------------------------------------------------------------------------------------------------

--Pharmacy Location Table

CREATE TABLE Dim_Pharmacy_location 
(
    PharmacyID VARCHAR(200),
    PharmacyName VARCHAR(200),
    Country VARCHAR(200),
    Region VARCHAR(200),
    City VARCHAR(200),
    PharmacyType VARCHAR(200),
    OpenDate Date,
    StoreSizeBand VARCHAR(10),
    Latitude decimal,
    Longitude decimal
)

\copy  Dim_Pharmacy_location from 'C:\Users\moham\OneDrive\Documents\Database\Pharmacy Sales\DimPharmacy.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

--Rename
ALTER TABLE dim_pharmacy_location
Rename column  PharmacyID to Pharmacy_ID ;


ALTER TABLE dim_pharmacy_location
Rename column  PharmacyName to Pharmacy_Name ;


ALTER TABLE dim_pharmacy_location
Rename column PharmacyType to Pharmacy_Type ;


ALTER TABLE dim_pharmacy_location
Rename column OpenDate to Open_Date ;


ALTER TABLE dim_pharmacy_location
Rename column  StoreSizeBand to Store_Size_Band ;

-------------------------------------------------------------------------------------------------------------------------------

--Product Table
CREATE TABLE Dim_Product 
(
ProductID VARCHAR(200),
ProductName VARCHAR(500),
Category VARCHAR(200),
Brand VARCHAR(200),
IsGeneric VARCHAR(20),
PackSize VARCHAR(200),
ListPriceEUR text,
StandardCostEUR text,
LaunchDate Date,
IsDiscontinued VARCHAR(10),
DiscontinuedDate Date
);

\copy  Dim_Product from 'C:\Users\moham\OneDrive\Documents\Database\Pharmacy Sales\DimProduct.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8'); 

UPDATE dim_product
Set listpriceeur  = replace(listpriceeur,'€',''),
    standardcosteur = replace(standardcosteur,'€','');

UPDATE dim_product
Set listpriceeur  = replace(listpriceeur,' ',''),
    standardcosteur = replace(standardcosteur,' ','');

ALTER TABLE dim_product
ALTER Column ListPriceEUR type decimal
USING trim(ListPriceEUR)::decimal;

ALTER TABLE dim_product
ALTER Column StandardCostEUR type decimal
USING trim(StandardCostEUR)::decimal;

--Rename
ALTER TABLE dim_product
Rename column ProductID to Product_ID ;


ALTER TABLE dim_product
Rename column ProductName to Product_Name ;


ALTER TABLE dim_product
Rename column  ListPriceEUR to List_Price_EUR ;


ALTER TABLE dim_product
Rename column  StandardCostEUR to Standard_Cost_EUR ;


ALTER TABLE dim_product
Rename column  LaunchDate to Launch_Date ;


ALTER TABLE dim_product
Rename column IsDiscontinued to Is_Discontinued ;


ALTER TABLE dim_product
Rename column  DiscontinuedDate to Discontinued_Date ;