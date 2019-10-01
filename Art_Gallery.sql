IF NOT EXISTS(SELECT * from SYS.DATABASES WHERE NAME = 'NU_ART_GALLERY')
    CREATE DATABASE NU_ART_GALLERY
GO

USE NU_ART_GALLERY;

IF NOT EXISTS (
SELECT  schema_name
FROM    information_schema.schemata
WHERE   schema_name = 'ART_GALLERY' ) 
BEGIN
EXEC sp_executesql N'CREATE SCHEMA ART_GALLERY'  
END

-----------------------------------------------------------------------------
CREATE TABLE  ARTISTS 
(
   "Artist_ID" INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  "Artist_Name" VARCHAR(35) NOT NULL,
  "Nationality" VARCHAR(45) NOT NULL,
  "Art_Style" VARCHAR(45) NOT NULL,
 );


 -----------------------------------------------------------------------------
 
 CREATE TABLE ADDRESSES
 (
	"Address_ID" INT NOT NULL PRIMARY KEY,
	"Stret_Name" VARCHAR(6) NOT NULL,
	"Line_Number_1" VARCHAR(45) NOT NULL,
	"Line_Number_2" VARCHAR(45),
	"City" VARCHAR(45) NOT NULL,
	"State" VARCHAR(45),
	"Zip_Code" INT NOT NULL,
	"Country" VARCHAR(45) NOT NULL,
	"Per_Line_Number_1" VARCHAR(45),
	"Per_Line_Number_2" VARCHAR(45),
	"Per_City" VARCHAR(45) ,
	"Per_State" VARCHAR(45),
	"Per_Zip_Code" INT NULL,
	"Per_Country" VARCHAR(45) ,
 );

 SELECT * FROM ADDRESSES

---------------------------------------------------------------

CREATE TABLE GALLERY 
(
  "Gallery_ID" INT PRIMARY KEY NOT NULL,
  "Gallery_Name" VARCHAR(45),
  "Addresses_ID" INT NOT NULL REFERENCES ADDRESSES
);

-----------------------------------------------------------------

CREATE TABLE ARTS 
(
	"Art_ID" INT NOT NULL PRIMARY KEY,
  "Art_Title" VARCHAR(20) NOT NULL,
  "Art_Year" DATE NOT NULL,
  "Art_Type" VARCHAR(45) NOT NULL,
  "Artist_ID" INT NOT NULL REFERENCES ARTISTS,
  "Gallery_Id" INT NOT NULL REFERENCES GALLERY
  );

  -------------------------------------------------------------------

  CREATE TABLE CUSTOMERS
  (
	"Customer_ID" INT NOT NULL PRIMARY KEY,
	"Addresses_ID" INT NOT NULL REFERENCES ADDRESSES
  );

  ---------------------------------------------------------------------

  CREATE TABLE EXHIBITIONS 
  (
	"Exhibition_ID" INT NOT NULL PRIMARY KEY,
	"Exhibition_Name" VARCHAR(45) NOT NULL,
	"Exhibition_Type" VARCHAR(45) NOT NULL,
	"Start_Date" DATE NOT NULL,
	"End_Date" DATE NOT NULL,
	"Location" VARCHAR(45),
	"Gallery_Id" INT NOT NULL REFERENCES GALLERY	
);

SELECT * FROM EXHIBITIONS
----------------------------------------------------------------------------

CREATE TABLE PAYMENT_METHOD
(
	"Payment_ID" INT NOT NULL PRIMARY KEY,
	"Card_Type" VARCHAR(50) NOT NULL,
	"Payment_Date" DATE NOT NULL,
	"Payment_Received" DATE NULL,
	"Payment_Balance" FLOAT NULL,
	"Order_ID" INT NOT NULL REFERENCES Orders
	);


CREATE INDEX index_payment_dt
ON PAYMENT_METHOD("Payment_Date");

----------------------------------------------------------------------------

CREATE TABLE BILLS 
(
  "Bill_ID" INT NOT NULL PRIMARY KEY,
  "Bill_Date" DATE NOT NULL,
  "Art_Title" VARCHAR(45) NOT NULL,
  "Amount" FLOAT NOT NULL,
  "Customer_ID" INT NOT NULL REFERENCES CUSTOMERS,
  "Payment_ID" INT NOT NULL REFERENCES PAYMENT_METHOD,
  "Exhibition_ID" INT NOT NULL REFERENCES EXHIBITIONS,
);


---------------------------------------------------------------------------------

CREATE TABLE EMPLOYEES
(
	"Employee_ID" INT NOT NULL PRIMARY KEY,
	"First_Name" VARCHAR(45) NOT NULL,
	"Last_Name" VARCHAR(45) NOT NULL,
	"Joining_Date" DATE NOT NULL,
	"Gender" VARCHAR(45) NOT NULL,
	"Cell_Phone_Number" INT NOT NULL,
	"Residence_Number" INT,
	"Gallery_Id" INT NOT NULL REFERENCES GALLERY,
	"Address_ID" INT NOT NULL REFERENCES ADDRESSES,
	CONSTRAINT CHK_Gender CHECK (Gender IN ('M','F'))
);

-------------------------------------------------------------------------------------

CREATE TABLE WAGES
(
	"Wages_Id" INT NOT NULL PRIMARY KEY,
	"Hourly_Wages" INT,
	"Shift_Time" TIME NULL,
	"Total_Wage" FLOAT NOT NULL,
	"Employee_ID" INT NOT NULL REFERENCES EMPLOYEES,
	"Gallery_ID" INT NOT NULL REFERENCES GALLERY,
);

-----------------------------------------------------------------------------------------

CREATE TABLE ORDERS
(
	"Order_ID" INT NOT NULL PRIMARY KEY,
	"Order_Status" VARCHAR(40) NOT NULL,
	"Order_Total" FLOAT NOT NULL,
	"Customer_ID" INT NOT NULL REFERENCES CUSTOMERS
);


---------------------------------------------------------------------------------------------


CREATE TABLE ORDER_DETAILS
(
	"Order_Details_ID" INT NOT NULL PRIMARY KEY,
	"Line_Total" FLOAT NOT NULL ,
	"Order_ID" INT REFERENCES ORDERS,
	"Art_ID" INT REFERENCES ARTS
);

--------------------------------------------------------------------------------------------------

CREATE TABLE ARTS_EXHIBITIONS
(
	"Art_ID" INT NOT NULL ,
	"Exhibition_ID" INT NOT NULL,
	PRIMARY KEY("Art_ID","Exhibition_ID"),
	FOREIGN KEY(Art_ID) REFERENCES ARTS(Art_ID),
	FOREIGN KEY(Exhibition_ID) REFERENCES EXHIBITIONS(Exhibition_ID)
);

SELECT * FROM ARTS_EXHIBITIONS

------------------------------------------INSERT ARTISTS-----------------------------------------------

INSERT INTO ARTISTS  VALUES ('Stephen Smith', 'American', 'Contemporary');
INSERT INTO ARTISTS  VALUES ('Anish Surti', 'Indian', 'Cubism');
INSERT INTO ARTISTS  VALUES ('Nilank Sharma', 'Indian', 'Abstract Expressionism');
INSERT INTO ARTISTS  VALUES ('Sidharth Upadhyay', 'Indian', 'Pop Art');
INSERT INTO ARTISTS  VALUES ('Wuping Wang', 'American', 'Art Deco');
INSERT INTO ARTISTS  VALUES ('Paul Fernando', 'Brazilian', 'Art Nouveau');
INSERT INTO ARTISTS  VALUES ('Tata Escobar', 'Mexican', 'Post-Impressionism');
INSERT INTO ARTISTS  VALUES ('Eduardo Sandoval', 'Mexican', 'Contemporary');
INSERT INTO ARTISTS  VALUES ('Pablo Escobar', 'Mexican', 'Surrealism');
INSERT INTO ARTISTS  VALUES ('Philip Huges', 'Australian', 'Cubism');
INSERT INTO ARTISTS  VALUES ('Heisenberg', 'American', 'Scenic Decorative');
INSERT INTO ARTISTS  VALUES ('Leonardo Da Vinci', 'American', 'Figurative');

SELECT * FROM  ARTISTS;
--------------------------------------------INSERT ADDRESS-----------------------------------------------

INSERT INTO ADDRESSES VALUES(200,'McGrev', '49/C','Roxbury Crossing', 'Boston', 'MA', 02120, 'USA', '262 Shamshed Apt' , 'Andheri East','Mumbai' , 'Maharashtra', 42346, 'India');
INSERT INTO ADDRESSES VALUES(201,'Horada', '49/C','Roxbury Crossing', 'Boston', 'MA', 02120, 'USA', '62 Sai Vihar' , 'Saket','Indore' , 'Madhya Pradesh', 42001, 'India');
INSERT INTO ADDRESSES VALUES(202,'Bill', '400 ','Dorhester', 'Boston', 'MA', 02120, 'USA', '62 Manavta Nagar' , 'Kanadiya Road','Noida' , 'New Delhi', 62235, 'India');
INSERT INTO ADDRESSES VALUES(203,'Harley', '638 ','Back Bay', 'Boston', 'MA', 02120, 'USA', '694 Mexican Apartments ' , 'Escobar Colony','Leon' , 'Chiapas', 78220, 'Mexico');
INSERT INTO ADDRESSES VALUES(204,'Hughes', '1114 ','Downton', 'Boston', 'MA', 02108, 'USA', '111 Harrier' , 'Salochna Road', 'Tijuana' , 'Mexico City', 82976, 'Mexico');
INSERT INTO ADDRESSES VALUES(205,'Auburn', '101 Old Suite ','Charlestown', 'Boston', 'MA', 02134, 'USA', '108 C Janerio Villa ' , 'Belo Road','Manaus' , 'Acre', 99265, 'Brazil');
INSERT INTO ADDRESSES VALUES(206,'Dane', '300 Punk Villa','Cambridge', 'Boston', 'MA', 02151, 'USA', '2 Balor Hob ' , 'Arthur Colony','Sydney' , 'Victoria', 23265, 'Australia');
INSERT INTO ADDRESSES VALUES(207,'Trump', '832 M','Concord', 'Boston', 'MA', 02203, 'USA', '75 Saint Alphonsus' , 'Roxbury Crossing','Boston' , 'MA', 02120, 'USA');
INSERT INTO ADDRESSES VALUES(208,'Clintn', '1 A','Brookline', 'Boston', 'MA', 02127, 'USA', '49 Smith Street' , 'Mission Main','Boston' , 'MA', 02120, 'USA');

select * from ADDRESSES
-------------------------------------------------INSERT GALLERY-------------------------------------------------------

INSERT INTO GALLERY VALUES(300, 'COE Art Gallery', 200);
INSERT INTO GALLERY VALUES(301, 'Boston Art Show', 201);
INSERT INTO GALLERY VALUES(302, 'CPS Art Attack', 202);
INSERT INTO GALLERY VALUES(303, 'Arifibers', 203);
INSERT INTO GALLERY VALUES(304, 'Artsy Wish', 204);
INSERT INTO GALLERY VALUES(305, 'Clay & Paper', 205);
INSERT INTO GALLERY VALUES(306, 'Color Secrets', 206);
INSERT INTO GALLERY VALUES(307, 'Craft Valley', 207);
INSERT INTO GALLERY VALUES(308, 'Creative Mass', 208);
INSERT INTO GALLERY VALUES(309, 'Crimson Created', 201);
INSERT INTO GALLERY VALUES(310, 'Crescent Crew', 204);
INSERT INTO GALLERY VALUES(311, 'Crossdale', 202);

SELECT * FROM GALLERY

---------------------------------------------------INSERT ARTS---------------------------------------------------------

INSERT INTO ARTS VALUES(400,'Smiling Eyes', '07/19/2019', 'Contemporary', 1, 300 );
INSERT INTO ARTS VALUES(401,'Finesse Nature', '06/01/2017', 'Contemporary', 2, 302 );
INSERT INTO ARTS VALUES(402,'Nonchalant Society', '01/01/2019', 'Abstract Expressionism', 3, 303 );
INSERT INTO ARTS VALUES(403,'The Starry Night', '02/20/2008', 'Pop Art', 4, 301 );
INSERT INTO ARTS VALUES(404,'Guernica', '09/29/2007', 'Art Deco', 5, 305 );
INSERT INTO ARTS VALUES(405,'Las Meninas', '12/12/2012', 'Art Nouveau', 6, 301 );
INSERT INTO ARTS VALUES(406,'The Night Watch', '03/09/2001', 'Post-Impressionism', 7, 308 );
INSERT INTO ARTS VALUES(407,'The Last Supper', '05/02/2008', 'Contemporary', 8, 306 );
INSERT INTO ARTS VALUES(408,'The Kiss', '02/02/2019', 'Pop Art', 3, 303 );
INSERT INTO ARTS VALUES(409,'Impression Sunrise', '11/06/2003', 'Art Deco', 4, 302 );
INSERT INTO ARTS VALUES(410,'The Birth of Venus', '08/30/2007', 'Scenic Decorative', 11, 309 );

SELECT * FROM ARTS
-------------------------------------------------INSERT CUSTOMERS-------------------------

INSERT INTO CUSTOMERS VALUES(500,200 );
INSERT INTO CUSTOMERS VALUES(501, 201 );
INSERT INTO CUSTOMERS VALUES(502, 202 );
INSERT INTO CUSTOMERS VALUES(503,203 );
INSERT INTO CUSTOMERS VALUES(504, 204);
INSERT INTO CUSTOMERS VALUES(505, 205 );
INSERT INTO CUSTOMERS VALUES(506, 206 );
INSERT INTO CUSTOMERS VALUES(507, 201 );
INSERT INTO CUSTOMERS VALUES(508, 200 );
INSERT INTO CUSTOMERS VALUES(509, 206);
INSERT INTO CUSTOMERS VALUES(510, 203 );

SELECT * FROM CUSTOMERS
ALTER TABLE ORDERS ADD Exhibition_ID INT REFERENCES EXHIBITIONS(Exhibition_ID)
-------------------------------------------------INSERT EXHIBITIONS---------------------------------------

INSERT INTO EXHIBITIONS VALUES(600, 'On the Horizon', 'Contemporary Cuban Art Jorge M. Pérez', '04/08/2018', '05/02/2018', 'Boston', 300);
INSERT INTO EXHIBITIONS VALUES(601, 'A Dangerous Woman', 'Subversion and Surrealism Art Honoré Sharrer', '04/08/2017', '05/02/2018', 'Boston', 301);
INSERT INTO EXHIBITIONS VALUES(602, 'DUOX4Odells', 'You’ll Know If You Belong Wickerham & Lomax', '03/10/2019', '03/18/2019', 'Boston', 302);
INSERT INTO EXHIBITIONS VALUES(603, 'Eye Fruit', 'Art of Franklin Williams', '01/03/2006', '01/23/2006', 'Boston', 303);
INSERT INTO EXHIBITIONS VALUES(604, 'Zhang Peili', 'Record, Repeat Art Institute of Chicago', '04/08/2016', '05/12/2016', 'Boston', 304);
INSERT INTO EXHIBITIONS VALUES(605, 'R.I.S.E.', 'Nothing is Natural at Reed College', '10/10/2002', '11/11/2002', 'Boston', 305);
INSERT INTO EXHIBITIONS VALUES(606, 'Cassils', 'Phantom Revenant Contemporary Art', '09/23/2013', '10/15/2013', 'Boston', 306);
INSERT INTO EXHIBITIONS VALUES(607, 'Roger Brown', 'Estate Paintings', '05/16/2012', '06/17/2012', 'Boston', 307);
INSERT INTO EXHIBITIONS VALUES(608, 'E Is For Elephants', 'Etchings of Edward Gorey', '11/01/2014', '11/25/2014', 'Boston', 308);
INSERT INTO EXHIBITIONS VALUES(609, 'Nick Cave', 'Until at MASS MoCA', '07/08/2019', '08/08/2019', 'Boston', 309);

---------------------------------------------------INSERT ORDERS-----------------------------------------
INSERT INTO ORDERS VALUES(800,'Initial', 501)
INSERT INTO ORDERS VALUES(801,'Initial', 502)
INSERT INTO ORDERS VALUES(802,'Initial', 503)
INSERT INTO ORDERS VALUES(803,'Initial', 504)
INSERT INTO ORDERS VALUES(804,'Initial', 501)
INSERT INTO ORDERS VALUES(805,'Initial', 505)
INSERT INTO ORDERS VALUES(806,'Initial', 502)
INSERT INTO ORDERS VALUES(807,'Initial', 503)
INSERT INTO ORDERS VALUES(808,'Initial', 505)

SELECT * FROM ORDERS

UPDATE ORDERS SET Order_Status = 'COMPLETE' WHERE Order_ID IN (801, 803, 805, 807);
UPDATE ORDERS SET order_date = GETDATE()-2 WHERE Order_ID IN (803, 806, 808);
UPDATE ORDERS SET order_date = GETDATE()-3 WHERE Order_ID IN (804);
UPDATE ORDERS SET order_date = GETDATE()-4 WHERE Order_ID IN (801);
UPDATE ORDERS SET order_date = GETDATE()-5 WHERE Order_ID IN (805);
UPDATE ORDERS SET order_date = GETDATE()-6 WHERE Order_ID IN (807);

alter table orders add order_date datetime;
--------INSERT ORDER DETAILS------------------------
SELECT * FROM ORDER_DETAILS;
INSERT INTO ORDER_DETAILS VALUES(900, 40, 800,400)
INSERT INTO ORDER_DETAILS VALUES(901, 60, 801, 401)
INSERT INTO ORDER_DETAILS VALUES(902, 30, 802,402)
INSERT INTO ORDER_DETAILS VALUES(903, 80, 803,402)
INSERT INTO ORDER_DETAILS VALUES(904, 120, 804,403)
INSERT INTO ORDER_DETAILS VALUES(905, 8888, 805,404)
INSERT INTO ORDER_DETAILS VALUES(906, 1990, 806,405)
INSERT INTO ORDER_DETAILS VALUES(907, 8000, 807,405)
INSERT INTO ORDER_DETAILS VALUES(908, 8000, 808,406)
INSERT INTO ORDER_DETAILS VALUES(909, 2220, 809,406)

SELECT * FROM ORDER_DETAILS
---------------------------------------------------INSERT PAYMENT METHOD----------------------------------

SELECT * FROM PAYMENT_METHOD

INSERT INTO PAYMENT_METHOD VALUES(700, 'Debit Card', '07/27/2019', '08/02/2019', 2100.76, 800, 0);

INSERT INTO PAYMENT_METHOD VALUES(701, 'Credit Card', '08/10/2019', '08/15/2019', 3000, 801, 0);
INSERT INTO PAYMENT_METHOD VALUES(702, 'Master Card', '09/02/2019', '09/10/2019', 1324, 802, 0);
INSERT INTO PAYMENT_METHOD VALUES(703, 'Venmo Card', '10/05/2019', '10/10/2019', 6400, 803, 0);
INSERT INTO PAYMENT_METHOD VALUES(704, 'Credit Card', '11/13/2019', '11/20/2019', 9932, 804, 0);
INSERT INTO PAYMENT_METHOD VALUES(705, 'Debit Card', '12/22/2019', '12/29/2019', 8967, 805, 0);
INSERT INTO PAYMENT_METHOD VALUES(706, 'Debit Card', '01/21/2019', '01/28/2019', 5421, 806, 0);
INSERT INTO PAYMENT_METHOD VALUES(707, 'Master Card', '03/17/2019', '03/23/2019', 7832, 807, 0);
INSERT INTO PAYMENT_METHOD VALUES(708, 'Venmo Card', '04/11/2019', '04/16/2019', 1234, 808, 0);
INSERT INTO PAYMENT_METHOD VALUES(709, 'Credit Card', '06/30/2019', '07/02/2019', 4321.76, 809, 0);

UPDATE PAYMENT_METHOD SET Card_Type = 'M' WHERE Card_Type = 'Master Card';
------------------------------------------------------------------------------------------------------------------
SELECT * FROM BILLS

INSERT INTO BILLS VALUES(110, '07/21/2019','Smiling Eyes', 7772.90, 500, 700, 600 )
INSERT INTO BILLS VALUES(112, '08/23/2019','Impression Sunrise', 3450, 502, 702, 602 )
INSERT INTO BILLS VALUES(113, '03/25/2019','Nonchalant Society', 7840, 503, 703, 603 )
INSERT INTO BILLS VALUES(114, '02/26/2019','The Starry Night', 1120, 504, 704, 604 )
INSERT INTO BILLS VALUES(115, '05/27/2019','Guernica', 4850, 505, 705, 605 )
INSERT INTO BILLS VALUES(116, '01/28/2019','Las Meninas', 1400, 506, 706, 606 )
INSERT INTO BILLS VALUES(117, '11/29/2019','The Night Watch', 800, 507, 707, 607 )
INSERT INTO BILLS VALUES(118, '12/11/2019','The Last Supper', 9823, 508, 708, 608 )

---------------------------------------------------------INSERT EMPLOYEES---------------------------------------------
SELECT * FROM EMPLOYEES;

ALTER TABLE EMPLOYEES ALTER COLUMN Cell_Phone_Number BIGINT NOT NULL;
ALTER TABLE EMPLOYEES ALTER COLUMN Residence_Number BIGINT;

INSERT INTO EMPLOYEES VALUES(2000, 'Anish', 'Surti', '08/11/2016', 'M', 9876543210, 8897898965, 300, 200);
INSERT INTO EMPLOYEES VALUES(2001, 'Nilank', 'Sharma', '08/20/2016', 'M', 876512309, 5459892310, 301, 201);
INSERT INTO EMPLOYEES VALUES(2002, 'Sidharth', 'Upadhyay', '08/25/2016', 'M', 6754328901, 9876098231, 302, 202);
INSERT INTO EMPLOYEES VALUES(2003, 'Lisa', 'Hayden', '01/08/2018', 'F', 89986743, 9876098231, 303, 203);
INSERT INTO EMPLOYEES VALUES(2004, 'Rita', 'Suzen', '08/25/2016', 'F', 7652131023, 9876098231, 304, 204);
INSERT INTO EMPLOYEES VALUES(2005, 'Paul', 'Coeloh', '08/25/2016', 'M', 2314327761, 9876098231, 305, 205);
INSERT INTO EMPLOYEES VALUES(2006, 'Adam', 'Gilchrist', '08/25/2016', 'M', 7768985432, 6655331231, 306, 206);
INSERT INTO EMPLOYEES VALUES(2007, 'Jasmine', 'Amanda', '08/25/2016', 'F', 6448780072, 7775532120, 307, 207);
INSERT INTO EMPLOYEES VALUES(2008, 'Smriti', 'Waghle', '08/25/2016', 'F', 2438798550, 4445556661, 308, 208);
INSERT INTO EMPLOYEES VALUES(2009, 'Mikel', 'Ben', '08/25/2016', 'M', 8543126652, 1112223334, 309, 202);

---------------------------------------------------------INSERT WAGES------------------------------------------

SELECT * FROM WAGES

INSERT INTO WAGES VALUES(3000, 30, '09:00', 240, 2000, 300);
INSERT INTO WAGES VALUES(3001, 25, '10:00', 200, 2001, 301);
INSERT INTO WAGES VALUES(3002, 20, '08:00', 160, 2002, 302);
INSERT INTO WAGES VALUES(3003, 30, '08:00', 240, 2003, 303);
INSERT INTO WAGES VALUES(3004, 30, '10:40', 240, 2004, 304);
INSERT INTO WAGES VALUES(3005, 20, '09:00', 160, 2005, 305);
INSERT INTO WAGES VALUES(3006, 22, '11:00', 176, 2006, 306);
INSERT INTO WAGES VALUES(3007, 40, '09:00', 320, 2007, 307);
INSERT INTO WAGES VALUES(3008, 21, '09:30', 168, 2008, 308);
INSERT INTO WAGES VALUES(3009, 44, '08:30', 352, 2009, 309);

---------------------------------------------------------------------------------------------------
SELECT * FROM ARTS_EXHIBITIONS

INSERT INTO ARTS_EXHIBITIONS VALUES(400,600)

INSERT INTO ARTS_EXHIBITIONS VALUES(400,601)
INSERT INTO ARTS_EXHIBITIONS VALUES(400,602)

INSERT INTO ARTS_EXHIBITIONS VALUES(401,603)
INSERT INTO ARTS_EXHIBITIONS VALUES(402,603)

INSERT INTO ARTS_EXHIBITIONS VALUES(403,604)
INSERT INTO ARTS_EXHIBITIONS VALUES(403,605)

INSERT INTO ARTS_EXHIBITIONS VALUES(404,606)
INSERT INTO ARTS_EXHIBITIONS VALUES(404,607)

INSERT INTO ARTS_EXHIBITIONS VALUES(405,608)
INSERT INTO ARTS_EXHIBITIONS VALUES(406,609)

-------------------------------------------------

alter table PAYMENT_METHOD add Order_Id INT;

alter table PAYMENT_METHOD add foreign key (Order_Id) references Orders(Order_Id);

alter table PAYMENT_METHOD add status int;


SELECT * FROM EMPLOYEES
---------------------------------------------COLUMN COMPUTATIONS---------------------------------

alter table orders drop column Order_Total

alter table orders add Order_Total as (dbo.fn_order_total(Order_Id))


create function fn_order_total(@order_id int)
RETURNS int
AS
BEGIN

DECLARE @ord_total int
SELECT @ord_total=SUM(Line_Total) 
FROM order_details 
WHERE Order_ID=@order_id

RETURN @ord_total
END

--------------------------------------------------CHECK CONSTRAINTS----------------------------------------

create function dbo.fn_order_status(@order_id int, @stat varchar(50))
RETURNS int
AS
BEGIN

DECLARE @payment_status int
DECLARE @func_res int

SELECT @payment_status=status 
FROM PAYMENT_METHOD 
WHERE Order_ID=@order_id

IF @stat='COMPLETE'
	IF @payment_status=1
		SELECT @func_res = 1;	
	ELSE
		SELECT @func_res = 0;

IF @stat='INITIAL'
	SELECT @func_res = 1;

RETURN @func_res
END

--

alter table orders add constraint chk_pay_stat CHECK(dbo.fn_order_status(order_id,order_status)=1)


----------------------------------------------------VIEWS-----------------------------------------------------------

CREATE VIEW VW_ORDER_REPORT AS
SELECT TOP 100 PERCENT ADDR.State,
CUST.CUST_NAME AS "Customer Name",
SUM(ORD.Order_Total) AS "Order Amount"
FROM CUSTOMERS CUST INNER JOIN ORDERS ORD 
ON ORD.Customer_ID = CUST.Customer_ID
INNER JOIN ADDRESSES ADDR
ON ADDR.Address_Id = CUST.Addresses_Id
WHERE ORD.Order_Status='COMPLETE' AND
ORD.order_date>= DATEADD(MONTH, -3, GETDATE())
GROUP BY ADDR.State,cust.CUST_NAME
HAVING SUM(ORD.Order_Total)>100
ORDER BY SUM(ORD.Order_Total) DESC

SELECT * FROM VW_ORDER_REPORT

----------------------------------------------------VIEWS------------------------------------------------------------------

CREATE VIEW VW_Exhibition_Sales AS
SELECT exb.Exhibition_Name AS "Exhibition Name", SUM(ORD.Order_Total) AS "Order Total"
FROM ORDERS ORD INNER JOIN EXHIBITIONS exb
ON ORD.Exhibition_ID = exb.Exhibition_ID
GROUP BY exb.Exhibition_Name

SELECT * FROM VW_Exhibition_Sales

-------------------------------------------------	To prolong (enter, update, and delete) data on expenditures --------------------------------------------------------------------

/*SELECT cust.Customer_ID,cust.CUST_NAME, SUM(ord.Order_Total) AS [Expenditure in $]
FROM CUSTOMERS cust 
INNER JOIN ORDERS ord ON cust.Customer_ID = ord.Customer_ID
GROUP BY cust.Customer_ID,cust.CUST_NAME
ORDER BY SUM(ord.Order_Total) DESC; 
*/

SELECT DISTINCT o.Customer_ID, cust.CUST_Name, o.Order_ID, ord.Art_ID, SUM(o.Order_Total) AS [Expenditure in $]
FROM ORDERS o
INNER JOIN ORDER_DETAILS ord 
ON o.Order_ID = ord.Order_ID
INNER JOIN CUSTOMERS cust 
ON cust.Customer_ID = o.Customer_ID
GROUP BY o.Customer_ID, ord.Art_ID, cust.CUST_Name, o.Order_ID
ORDER BY SUM(o.Order_Total) DESC;

-----------------------------------------------------	To execute search queries on artist’s name-------------------------------

CREATE INDEX ix_artist_id
ON ARTISTS(Artist_Name)

CREATE INDEX ix_art_titile
ON ARTS(Art_Title);

CREATE INDEX ix_art_id
ON ARTS(Art_Id);

SELECT artst.Artist_ID, artst.Artist_Name, art.Art_ID,  art.Art_Title, art.Art_Type, 
ord.Line_Total AS [Cost of Art in $]
FROM ARTISTS artst
INNER JOIN ARTS art ON
artst.Artist_ID = art.Artist_ID
INNER JOIN ORDER_DETAILS ord ON
art.Art_ID = ord.Art_ID
WHERE artst.Artist_Name = 'Wuping Wang' AND art.Art_Title = 'Guernica'
ORDER BY ord.Line_Total ASC;

------------------------------------------------------ TOTAL EXHIBITION SELL DATE WISE---------------------

SELECT CAST(o.order_date AS date) [Order Date], ex.Exhibition_Name, SUM(o.Order_Total) AS [Total Of Exhibition Earned in $]
FROM ORDERS o
INNER JOIN EXHIBITIONS ex
ON
o.Exhibition_ID = ex.Exhibition_ID
GROUP BY o.order_date, ex.Exhibition_Name
ORDER BY o.order_date;

--------------------------------------------query to add a rank without gaps in the
 ---------------------------------ranking based on total orders in the descending order partition by address------------------------------------------------------------------------

SELECT c.Customer_ID, c.Addresses_ID,
 COUNT(o.Order_ID) [Total Orders],
 DENSE_RANK() OVER
 (PARTITION BY c.Addresses_ID ORDER BY COUNT(o.Order_ID) DESC) AS Rank
FROM CUSTOMERS c
LEFT OUTER JOIN ORDERS o
 ON c.Customer_ID = o.Customer_ID
WHERE DATEPART(year, order_date) = 2019
GROUP BY c.Addresses_ID, c.Customer_ID;

---------------------------------------------------------------------------------------------------------------------------------------
/*
query to list the most popular art_type for each month
 of 2019, considering all products sold in each month. The most
 popular art_type had the highest total quantity sold for
 all products in that art.
*/

 WITH Result_Table  AS (	SELECT DATEPART(MONTH, o.order_date) OrderMonth,	ord.Art_ID, o.Order_Total,	(SELECT a.Art_Type FROM ARTS a WHERE a.Art_ID = ord.Art_ID) ArtType,	o.Order_Total [Sales in $]	FROM ORDERS o	INNER JOIN ORDER_DETAILS ord	ON o.Order_ID = ord.Order_ID	WHERE DATEPART(year, order_date) = 2019	GROUP BY o.order_date, ord.Art_ID, o.Order_Total ) SELECT ArtType, SUM(Order_Total) [Sales in $], OrderMonth FROM Result_Table WHERE ArtType IS NOT NULL GROUP BY OrderMonth, ArtType ORDER BY OrderMonth, [Sales in $] DESC;

-------------------------------------------------------EMPLOYEE & WAGES---------------------------------------------------
/*DECLARE @startDate DATETIME, @endDate DATETIME, @currentDate DATETIME, @currentDay INT, @PerDaycount INT, @Monthcount INT

   DECLARE @currentMonth INT, @lastDayOfStartMonth INT 
  CREATE TABLE #VacationDays ([Month] VARCHAR(10), [DaysSpent] INT,[MonthDays] VARCHAR(10),[PerdayAmt] decimal(8,2),[TotalAmt] decimal(8,2))

 DECLARE @Salary decimal(8,0)


 SET @Salary  = 7000

 SET @startDate = '07/20/2016'
  SET @endDate = '05/30/2019'
  SET @currentMonth = DATEPART(mm, @startDate)
 SET @currentDay = DATEPART(dd, @startDate)
 SET @currentDate = @startDate

 WHILE @currentMonth <= DATEPART(mm, @endDate)
BEGIN
  SELECT @lastDayOfStartMonth =
  DATEPART(dd, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@currentDate)+1,0)))
PRINT @lastDayOfStartMonth
IF(@currentMonth != DATEPART(mm, @endDate))
BEGIN
INSERT INTO #VacationDays
SELECT DATENAME(month, @currentDate) AS [Month],
    @lastDayOfStartMonth - @currentDay + 1 AS [DaysSpent],@lastDayOfStartMonth as a,@Salary/@lastDayOfStartMonth As dayammt,(@Salary/@lastDayOfStartMonth ) * @lastDayOfStartMonth - @currentDay + 1 AS totamt
END
ELSE
BEGIN
INSERT INTO #VacationDays
   SELECT DATENAME(month, @endDate) AS [Month],
   DATEPART(dd, @endDate) AS [DaysSpent],@lastDayOfStartMonth as a,@Salary/@lastDayOfStartMonth As dayammt,(@Salary/@lastDayOfStartMonth ) * DATEPART(dd, @endDate) AS totamt
END
SET @currentDate = DATEADD(mm, 1, @currentDate)
SET @currentMonth = @currentMonth + 1
SET @currentDay = 1
END

SELECT * FROM #VacationDays
DROP TABLE #VacationDays
*/

--Working on this one to calculate pay rate salary----

WITH cteLastRaiseDate(Employee_ID, Gallery_ID) 
     AS (SELECT   Employee_ID,
				  Gallery_Id
         FROM     EMPLOYEES 
         GROUP BY Employee_ID,Gallery_Id), 
     ctePayRate(Employee_ID,Rate) 
     AS (SELECT eph.Employee_ID, 
                eph.Hourly_Wages 
         FROM   WAGES eph 
                INNER JOIN cteLastRaiseDate lrd 
                  ON eph.Employee_ID  = lrd.Employee_ID  
                     AND eph.Gallery_ID = lrd.Gallery_ID) 
SELECT   Gallery = g.Gallery_Name, 
         Members = COUNT(* ), 
-- SQL Server currency formatting - format money
         [Average Salary] = '$'+CONVERT(varchar,AVG(Rate),1), 
         [Maximum Salary] = '$'+CONVERT(varchar,MAX(Rate),1), 
         [Minimum Salary] = '$'+CONVERT(varchar,MIN(Rate),1),  
         [Standard Deviation] = '$'+CONVERT(varchar,convert(MONEY,ISNULL(STDEV(Rate),0)),1)
FROM     ctePayRate eph 
         INNER JOIN EMPLOYEES e 
           ON eph.Employee_ID = e.Employee_ID
         INNER JOIN WAGES edh 
           ON edh.Employee_ID = e.Employee_ID 
         INNER JOIN GALLERY g
           ON edh.Gallery_ID = g.Gallery_ID          
GROUP BY g.Gallery_Name 
ORDER BY Gallery

GO

---------------------------------------------------------------------------------------------------

CREATE PROCEDURE InsertOrder
	@cust_id int,
	@exhibition_id int
AS
BEGIN
	INSERT INTO ORDERS
	(
	Order_ID, 
	Order_Status, 
	Customer_ID, 
	Exhibition_ID, 
	order_date
	) VALUES
	(
		NEXT VALUE FOR ord_seq,
		'Initial',
		@cust_id,
		@exhibition_id,
		GETDATE()
	)

END
GO

EXEC InsertOrder 
	@cust_id = 500,
	@exhibition_id = 600
GO

SELECT * FROM ORDERS
---------------------------

CREATE PROCEDURE InsertOrdDetail
	@order_id INT,
	@art_id INT,
	@line_total FLOAT
AS
BEGIN
	INSERT INTO ORDER_DETAILS
	(
	Order_Details_ID,
	Line_Total,
	Order_ID,
	Art_ID
	)
	VALUES
	(
		NEXT VALUE FOR ord_detail_seq,
		@line_total,
		@order_id,
		@art_id
	)
END
GO

EXEC InsertOrdDetail
	@line_total = 200,
	@order_id = 810,
	@art_id = 400
GO


DROP PROCEDURE InsertOrdDetail






