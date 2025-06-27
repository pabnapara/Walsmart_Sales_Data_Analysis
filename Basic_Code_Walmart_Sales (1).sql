CREATE DATABASE SALES_WALMART;
CREATE TABLE SALES(
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL, 
  city VARCHAR(30) NOT NULL, 
  customer_type VARCHAR(30) NOT NULL, 
  gender VARCHAR(30) NOT NULL, 
  product_line VARCHAR(100) NOT NULL, 
  unit_price DECIMAL(10, 2) NOT NULL, 
  quantity INT NOT NULL, 
  tax_pct FLOAT(6, 4) NOT NULL, 
  total DECIMAL(12, 4) NOT NULL, 
  date DATETIME NOT NULL, 
  time TIME NOT NULL, 
  payment VARCHAR(15) NOT NULL, 
  cogs DECIMAL(10, 2) NOT NULL, 
  gross_margin_pct FLOAT(11, 9), 
  gross_income DECIMAL(12, 4), 
  rating FLOAT(2, 1)
);
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- FEATURE ENGINEERING---------------------------------------------------------------------------------------------------------------
-- time_of_day
SELECT 
  time, 
  (
    CASE WHEN 'time' BETWEEN "00:00:00" 
    AND "12:00:00" THEN "Morning" WHEN 'time' BETWEEN "12:01:00" 
    AND "16:00:00" THEN "Afternoon" ELSE "Evening" END
  ) AS time_of_date 
FROM 
  SALES;
ALTER TABLE 
  SALES 
ADD 
  COLUMN time_of_day VARCHAR(20);
UPDATE 
  SALES 
SET 
  time_of_day =(
    CASE WHEN 'time' BETWEEN "00:00:00" 
    AND "12:00:00" THEN "Morning" WHEN 'time' BETWEEN "12:01:00" 
    AND "16:00:00" THEN "Afternoon" ELSE "Evening" END
  );
-- day_name
SELECT 
  date, 
  DAYNAME(date) AS day_name 
FROM 
  SALES;
ALTER TABLE 
  SALES 
ADD 
  COLUMN day_name VARCHAR(10);
UPDATE 
  SALES 
SET 
  day_name = DAYNAME(date);
-- month_name
SELECT 
  date, 
  MONTHNAME(date) AS month_name 
FROM 
  SALES;
ALTER TABLE 
  SALES 
ADD 
  COLUMN month_name VARCHAR(10);
UPDATE 
  SALES 
SET 
  month_name = MONTHNAME(date);
-----------------------------------------------------------------------------------------------------------------------------------
-- EXPLORATORY DATA ANALYSIS-------------------------------------------------------------------------------------------------------
-- business questions to answer----------------------------------------------------------------------------------------------------
-- ------------------------------------------Generic Question--------------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
  DISTINCT CITY 
FROM 
  SALES;
-- In which city is each branch?
SELECT 
  DISTINCT BRANCH 
FROM 
  SALES;
SELECT 
  DISTINCT CITY, 
  BRANCH 
FROM 
  SALES;
--------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------Product Question---------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT 
  DISTINCT PRODUCT_LINE 
FROM 
  SALES;
-- To get the count of distinct products
SELECT 
  COUNT(DISTINCT PRODUCT_LINE) 
FROM 
  SALES;
-- What is the most common payment method? #SUM OF ALL THE PAYMENT METHODS,BIGGEST OF ALL WILL BE CONSIDERED
SELECT 
  PAYMENT, 
  COUNT(PAYMENT) AS CNT 
FROM 
  SALES 
GROUP BY 
  PAYMENT 
ORDER BY 
  CNT DESC;
-- What is the most selling product line?
SELECT 
  PRODUCT_LINE, 
  COUNT(PRODUCT_LINE) AS CNT 
FROM 
  SALES 
GROUP BY 
  PRODUCT_LINE 
ORDER BY 
  CNT DESC;
-- What is the total revenue by month?
SELECT 
  MONTH_NAME AS MONTH, 
  SUM(TOTAL) AS TOTAL_REVENUE 
FROM 
  SALES 
GROUP BY 
  MONTH_NAME 
ORDER BY 
  TOTAL_REVENUE DESC;
-- What month had the largest COGS? #REVENUE HAS POSITIVE RELATION WITH COGS
SELECT 
  MONTH_NAME AS MONTH, 
  SUM(COGS) AS COGS 
FROM 
  SALES 
GROUP BY 
  MONTH_NAME 
ORDER BY 
  COGS;
-- What product line had the largest revenue?
SELECT 
  PRODUCT_LINE, 
  SUM(TOTAL) AS TOTAL_REVENUE 
FROM 
  SALES 
GROUP BY 
  PRODUCT_LINE 
ORDER BY 
  TOTAL_REVENUE;
-- What is the city with the largest revenue?
SELECT 
  BRANCH, 
  CITY, 
  SUM(TOTAL) AS TOTAL_REVENUE 
FROM 
  SALES 
GROUP BY 
  CITY, 
  BRANCH 
ORDER BY 
  TOTAL_REVENUE DESC;
-- What product line had the largest VAT?
SELECT 
  PRODUCT_LINE, 
  AVG(TAX_PCT) AS AVG_TAX 
FROM 
  SALES 
GROUP BY 
  PRODUCT_LINE 
ORDER BY 
  AVG_TAX DESC;
-- Which branch sold more products than average product sold?
SELECT 
  BRANCH, 
  SUM(QUANTITY) AS QTY 
FROM 
  SALES 
GROUP BY 
  BRANCH 
HAVING 
  SUM(QUANTITY) > (
    SELECT 
      AVG(QUANTITY) 
    FROM 
      SALES
  );
-- What is the most common product line by gender?
SELECT 
  GENDER, 
  PRODUCT_LINE, 
  COUNT(GENDER) AS TOTAL_CNT 
FROM 
  SALES 
GROUP BY 
  GENDER, 
  PRODUCT_LINE 
ORDER BY 
  TOTAL_CNT DESC;
-- What is the average rating of each product line?
SELECT 
  AVG(RATING) AS AVG_RATING, 
  PRODUCT_LINE 
FROM 
  SALES 
GROUP BY 
  PRODUCT_LINE 
ORDER BY 
  AVG_RATING DESC;
--------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------Sales Question------------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
SELECT 
  time_of_day, 
  COUNT(*) AS TOTAL_SALES 
FROM 
  SALES 
WHERE 
  DAY_NAME = "SUNDAY" 
GROUP BY 
  time_of_day 
ORDER BY 
  TOTAL_SALES DESC;
.-- Which of the customer types brings the most revenue?
SELECT 
  CUSTOMER_TYPE, 
  SUM(TOTAL) AS TOTAL_REV 
FROM 
  SALES 
GROUP BY 
  CUSTOMER_TYPE 
ORDER BY 
  TOTAL_REV DESC;
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
  CITY, 
  AVG(TAX_PCT) AS VAT 
FROM 
  SALES 
GROUP BY 
  CITY 
ORDER BY 
  VAT DESC;
-- Which customer type pays the most in VAT?
SELECT 
  CUSTOMER_TYPE, 
  AVG(TAX_PCT) AS VAT 
FROM 
  SALES 
GROUP BY 
  CUSTOMER_TYPE 
ORDER BY 
  VAT DESC;
--------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------Customer Question-----------------------------------------------------------------
-- How many unique customer types does the data have?
SELECT 
  DISTINCT CUSTOMER_TYPE 
FROM 
  SALES;
-- How many unique payment methods does the data have?
SELECT 
  DISTINCT PAYMENT 
FROM 
  SALES;
-- What is the most common customer type?
-- Which customer type buys the most?
SELECT 
  CUSTOMER_TYPE, 
  COUNT(*) AS CSTM_CNT 
FROM 
  SALES 
GROUP BY 
  CUSTOMER_TYPE;
-- What is the gender of most of the customers?
SELECT 
  GENDER, 
  COUNT(*) AS GENDER_CNT 
FROM 
  SALES 
GROUP BY 
  GENDER 
ORDER BY 
  GENDER_CNT DESC;
-- What is the gender distribution per branch?
SELECT 
  GENDER, 
  COUNT(*) AS GENDER_CNT 
FROM 
  SALES 
WHERE 
  BRANCH = "C" 
GROUP BY 
  GENDER 
ORDER BY 
  GENDER_CNT DESC;
-- Which time of the day do customers give most ratings?
SELECT 
  time_of_day, 
  AVG(RATING) AS AVG_RATING 
FROM 
  SALES 
GROUP BY 
  TIME_OF_DAY 
ORDER BY 
  AVG_RATING DESC;
-- Which time of the day do customers give most ratings per branch?
SELECT 
  time_of_day, 
  AVG(RATING) AS AVG_RATING 
FROM 
  SALES 
WHERE 
  BRANCH = "C" 
GROUP BY 
  TIME_OF_DAY 
ORDER BY 
  AVG_RATING DESC;
-- Which day fo the week has the best avg ratings?
SELECT 
  DAY_NAME, 
  AVG(RATING) AS AVG_RATING 
FROM 
  SALES 
GROUP BY 
  DAY_NAME 
ORDER BY 
  AVG_RATING DESC;
-- Which day of the week has the best average ratings per branch?
SELECT 
  DAY_NAME, 
  AVG(RATING) AS AVG_RATING 
FROM 
  SALES 
WHERE 
  BRANCH = "A" 
GROUP BY 
  DAY_NAME 
ORDER BY 
  AVG_RATING DESC;
#SIMILARLY WE CAN CHECK FOR ALL THE OTHER BRANCHES 
SELECT 
  BRANCH, 
  SUM(COGS) AS TOTAL_SALES 
FROM 
  SALES 
GROUP BY 
  BRANCH 
ORDER BY 
  TOTAL_SALES;
SELECT 
  CITY, 
  TAX_PCT 
FROM 
  SALES 
GROUP BY 
  CITY 
ORDER BY 
  TAX_PCT DESC;
