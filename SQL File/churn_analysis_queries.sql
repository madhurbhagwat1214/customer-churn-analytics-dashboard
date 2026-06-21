USE churn_analysis;

-- ==========================================
-- SECTION 1: DATA QUALITY CHECKS
-- ==========================================

-- Q1 Total Records
SELECT COUNT(*) AS total_records
FROM customers;

-- Q2 Null Value Check
SELECT *
FROM customers
WHERE Customer_ID IS NULL
OR Customer_Name IS NULL
OR Region IS NULL
OR Churn_Status IS NULL;

-- Q3 Duplicate Customer IDs
SELECT Customer_ID,
COUNT(*) AS duplicate_count
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Q4 Distinct Regions
SELECT DISTINCT Region
FROM customers;

-- ==========================================
-- SECTION 2: CUSTOMER OVERVIEW
-- ==========================================

-- Q5 Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q6 Active Customers
SELECT COUNT(*) AS active_customers
FROM customers
WHERE Churn_Status='No';

-- Q7 Churned Customers
SELECT COUNT(*) AS churned_customers
FROM customers
WHERE Churn_Status='Yes';

-- Q8 Churn Rate
SELECT
ROUND(
100.0 *
SUM(CASE WHEN Churn_Status='Yes' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS churn_rate
FROM customers;

-- Q9 Average Orders Per Customer
SELECT
ROUND(AVG(Orders_Count),2)
AS avg_orders_per_customer
FROM customers;

-- ==========================================
-- SECTION 3: REVENUE ANALYSIS
-- ==========================================

-- Q10 Total Revenue
SELECT
ROUND(SUM(Total_Spend),2)
AS total_revenue
FROM customers;

-- Q11 Average Revenue Per Customer
SELECT
ROUND(AVG(Total_Spend),2)
AS avg_customer_revenue
FROM customers;

-- Q12 Revenue Lost Due To Churn
SELECT
ROUND(SUM(Total_Spend),2)
AS lost_revenue
FROM customers
WHERE Churn_Status='Yes';

-- Q13 Revenue By Region
SELECT
Region,
ROUND(SUM(Total_Spend),2) AS revenue
FROM customers
GROUP BY Region
ORDER BY revenue DESC;

-- Q14 Revenue By Subscription Type
SELECT
Subscription_Type,
ROUND(SUM(Total_Spend),2) AS revenue
FROM customers
GROUP BY Subscription_Type
ORDER BY revenue DESC;

-- ==========================================
-- SECTION 4: REGION ANALYSIS
-- ==========================================

-- Q15 Customers By Region
SELECT
Region,
COUNT(*) AS customers
FROM customers
GROUP BY Region
ORDER BY customers DESC;

-- Q16 Churned Customers By Region
SELECT
Region,
SUM(CASE WHEN Churn_Status='Yes'
THEN 1 ELSE 0 END) AS churned_customers
FROM customers
GROUP BY Region
ORDER BY churned_customers DESC;

-- Q17 Churn Rate By Region
SELECT
Region,
ROUND(
100.0 *
SUM(CASE WHEN Churn_Status='Yes'
THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS churn_rate
FROM customers
GROUP BY Region
ORDER BY churn_rate DESC;

-- ==========================================
-- SECTION 5: SUBSCRIPTION ANALYSIS
-- ==========================================

-- Q18 Customers By Subscription
SELECT
Subscription_Type,
COUNT(*) AS customers
FROM customers
GROUP BY Subscription_Type;

-- Q19 Churn By Subscription
SELECT
Subscription_Type,
SUM(CASE WHEN Churn_Status='Yes'
THEN 1 ELSE 0 END) AS churned_customers
FROM customers
GROUP BY Subscription_Type;

-- Q20 Churn Rate By Subscription
SELECT
Subscription_Type,
ROUND(
100.0 *
SUM(CASE WHEN Churn_Status='Yes'
THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS churn_rate
FROM customers
GROUP BY Subscription_Type
ORDER BY churn_rate DESC;

-- ==========================================
-- SECTION 6: PRODUCT CATEGORY ANALYSIS
-- ==========================================

-- Q21 Revenue By Product Category
SELECT
Product_Category,
ROUND(SUM(Total_Spend),2) AS revenue
FROM customers
GROUP BY Product_Category
ORDER BY revenue DESC;

-- Q22 Churn By Product Category
SELECT
Product_Category,
SUM(CASE WHEN Churn_Status='Yes'
THEN 1 ELSE 0 END) AS churned_customers
FROM customers
GROUP BY Product_Category
ORDER BY churned_customers DESC;

-- Q23 Churn Rate By Product Category
SELECT
Product_Category,
ROUND(
100.0 *
SUM(CASE WHEN Churn_Status='Yes'
THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS churn_rate
FROM customers
GROUP BY Product_Category
ORDER BY churn_rate DESC;

-- ==========================================
-- SECTION 7: CUSTOMER SEGMENTATION
-- ==========================================

-- Q24 Customer Segmentation
SELECT
Customer_ID,
Customer_Name,
Total_Spend,
CASE
WHEN Total_Spend >= 80000 THEN 'High Value'
WHEN Total_Spend >= 40000 THEN 'Medium Value'
ELSE 'Low Value'
END AS customer_segment
FROM customers;

-- Q25 Revenue By Segment
SELECT
CASE
WHEN Total_Spend >= 80000 THEN 'High Value'
WHEN Total_Spend >= 40000 THEN 'Medium Value'
ELSE 'Low Value'
END AS customer_segment,
COUNT(*) AS customers,
ROUND(SUM(Total_Spend),2) AS revenue
FROM customers
GROUP BY customer_segment
ORDER BY revenue DESC;

-- ==========================================
-- SECTION 8: ADVANCED SQL
-- ==========================================

-- Q26 Top 10 Customers By Revenue
SELECT *
FROM
(
SELECT
Customer_ID,
Customer_Name,
Total_Spend,
DENSE_RANK()
OVER(ORDER BY Total_Spend DESC) AS customer_rank
FROM customers
) t
WHERE customer_rank <= 10;

-- Q27 Revenue Contribution Percentage
SELECT
Customer_ID,
Customer_Name,
Total_Spend,
ROUND(
100 * Total_Spend /
SUM(Total_Spend) OVER(),
2
) AS revenue_contribution_pct
FROM customers;
