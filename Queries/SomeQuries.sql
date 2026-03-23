--Highest cities by revenue
SELECT 
    dpl.city,
    Round(Sum(ps.revenue_eur)) as Total_Revenue
FROM pharmacy_sales as ps
INNER JOIN dim_pharmacy_location as dpl ON dpl.pharmacy_id = ps.pharmacy_id
GROUP BY dpl.city 
ORDER BY Round(Sum(ps.revenue_eur)) DESC;

--------------------------------------------------------------------------------------------------------------

--Urban vs Suburban vs Rural
SELECT 
    dpl.pharmacy_type,
    Round(Sum(ps.revenue_eur)) as Total_Revenue,
    Round(Sum(ps.cost_eur)) as Total_Cost,
    Round(Sum(ps.margin_eur)) as Total_Margin
FROM pharmacy_sales as ps
INNER JOIN dim_pharmacy_location  as dpl ON dpl.pharmacy_id = ps.pharmacy_id
GROUP BY dpl.pharmacy_type 
ORDER BY Round(Sum(ps.revenue_eur)) DESC;

--------------------------------------------------------------------------------------------------------------

--Most sold brand in every country
SELECT
    dpl.country,
    dp.brand,
    count(dp.brand)
From pharmacy_sales as ps
INNER JOIN dim_pharmacy_location as dpl ON dpl.pharmacy_id =  ps.pharmacy_id
INNER JOIN dim_product as dp On dp.product_id = ps.product_id
GROUP BY dpl.country,dp.brand
ORDER BY dpl.country,count(dp.brand) DESC;

--------------------------------------------------------------------------------------------------------------

--Highest sales by category 
SELECT
    dp.category,
    Round(Sum(ps.revenue_eur))
From pharmacy_sales as ps
INNER JOIN dim_product as dp on dp.product_id = ps.product_id
GROUP BY dp.category
ORDER BY Sum(ps.revenue_eur) DESC;

--------------------------------------------------------------------------------------------------------------

--Highest producets by profit  
SELECT
    dp.product_name,
    dp.category,
    dp.list_price_eur,
    dp.standard_cost_eur,
    dp.list_price_eur - dp.standard_cost_eur as profit
From dim_product as dp
ORDER BY profit DESC;

--------------------------------------------------------------------------------------------------------------

--Monthly Pharmacy Sales Summary
with base_Table as 
(
    SELECT
        ddp.year,
        ddp.month_number,
        ddp.month_name,
        Round(Sum(ps.revenue_eur)) as Total_Revenue,
        Round(Sum(ps.cost_eur)) as Total_Cost,
        Round(Sum(ps.margin_eur)) as Total_Margin
    From pharmacy_sales as ps
    INNER JOIN dim_date_pharmacy as ddp on ddp.date_key = ps.date_key
    GROUP BY ddp.year,ddp.month_number,ddp.month_name
    ORDER BY ddp.year , ddp.month_number ASC
)
SELECT 
bt.year,
bt.month_name,
bt.Total_Revenue,
bt.Total_Cost,
bt.Total_Margin
FROM base_Table as bt;

--------------------------------------------------------------------------------------------------------------

--Impact of Promotion Products on Sales
With base_Table AS 
(
    SELECT
        ps.promo_flag,
        Sum(ps.revenue_eur) as Total_Revenue
    From pharmacy_sales as ps
    GROUP BY ps.promo_flag
)
,Second_Table AS
(
    SELECT 
        Sum(ps.revenue_eur) as Total_Revenue
    FROM pharmacy_sales as ps
)
SELECT
bt.promo_flag,
bt.Total_Revenue,
round((bt.Total_Revenue / st.Total_Revenue)*100) as Percentagee
From base_Table as bt
Cross Join Second_Table as st;

--------------------------------------------------------------------------------------------------------------

--Impact of Generic Products on Sales
With base_Table AS
(
    SELECT
        dp.isgeneric,
        SUM(ps.revenue_eur) as Total_Revenue
    FROM pharmacy_sales as ps
    INNER JOIN dim_product as dp 
        ON dp.product_id = ps.product_id
    GROUP BY dp.isgeneric
)
,Second_Table AS
(
    SELECT
        SUM(ps.revenue_eur) as Total_Revenue
    FROM pharmacy_sales as ps
    INNER JOIN dim_product as dp 
        ON dp.product_id = ps.product_id
)
SELECT
    bt.isgeneric,
    bt.Total_Revenue,
    ROUND((bt.Total_Revenue / st.Total_Revenue) * 100, 2) as Percentage
FROM base_Table as bt
CROSS JOIN Second_Table as st;

--------------------------------------------------------------------------------------------------------------

--Impact of Discounts on Sales
With base_Table AS
(
    SELECT
        dp.is_discontinued,
        SUM(ps.revenue_eur) as Total_Revenue
    FROM pharmacy_sales as ps
    INNER JOIN dim_product as dp 
        ON dp.product_id = ps.product_id
    GROUP BY dp.is_discontinued
)
,Second_Table AS
(
    SELECT
        SUM(ps.revenue_eur) as Total_Revenue
    FROM pharmacy_sales as ps
    INNER JOIN dim_product as dp 
        ON dp.product_id = ps.product_id
)
SELECT
    bt.is_discontinued,
    bt.Total_Revenue,
    ROUND((bt.Total_Revenue / st.Total_Revenue) * 100, 2) as Percentage
FROM base_Table as bt
CROSS JOIN Second_Table as st;

--------------------------------------------------------------------------------------------------------------

