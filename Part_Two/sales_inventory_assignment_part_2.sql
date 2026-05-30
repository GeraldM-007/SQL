

select current_schema();


-- =====================================================
-- PART 2
-- =====================================================
-- =====================================================
-- SUBQUERY QUESTIONS
-- =====================================================

-- 51. Which customers have spent more than the average spending of all customers?

-- 52. Which products are priced higher than the average price of all products?

-- 53. Which customers have never made a purchase?

-- 54. Which products have never been sold?

-- 55. Which customer made the single most expensive purchase?

-- 56. Which products have total sales greater than the average total sales across all products?

-- 57. Which customers registered earlier than the average registration date?

-- 58. Which products have a price higher than the average price within their own category?

-- 59. Which customers have spent more than the customer with ID = 10?

-- 60. Which products have total quantity sold greater than the overall average quantity sold?


-- =====================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================

-- 61. Create an intermediate result that calculates the total amount spent by each customer,
--     then determine which customers are the top 5 highest spenders.

-- 62. Create an intermediate result that calculates total quantity sold per product,
--     then determine which products are the top 3 most sold.

-- 63. Create an intermediate result showing total sales per product category,
--     then determine which category generates the highest revenue.

-- 64. Create an intermediate result that calculates the number of purchases per customer,
--     then identify customers who purchased more than twice.

-- 65. Create an intermediate result that calculates the total quantity sold per product,
--     then determine which products sold more than the average quantity sold.

-- 66. Create an intermediate result that calculates total spending per customer,
--     then determine which customers spent more than the average spending.

-- 67. Create an intermediate result that calculates total revenue per product,
--     then list the products ordered from highest revenue to lowest.

-- 68. Create an intermediate result showing monthly sales totals,
--     then determine which month had the highest revenue.

-- 69. Create an intermediate result that calculates the number of sales per product,
--     then determine which products were purchased by more than three customers.

-- 70. Create an intermediate result showing total quantity sold per product,
--     then identify products that sold less than the average quantity sold.


-- =====================================================
-- WINDOW FUNCTION QUESTIONS
-- =====================================================

-- 71. Rank customers based on the total amount they have spent.

-- 72. Rank products based on total quantity sold.

-- 73. Identify the 3rd highest spending customer.

-- 74. Identify the 2nd most expensive product.

-- 75. Show the ranking of products within each category based on price.

-- 76. Show the ranking of customers based on the number of purchases they made.

-- 77. Show the running total of sales amounts ordered by sale_date.

-- 78. Show the previous sale amount for each sale ordered by sale_date.

-- 79. Show the next sale amount for each sale ordered by sale_date.

-- 80. Divide customers into 4 groups based on total spending.


-- =====================================================
-- ADVANCED ANALYTICAL QUESTIONS
-- =====================================================

-- 81. Which customers bought products in more than one category?

-- 82. Which customers purchased products within 7 days of registering?

-- 83. Which products have lower stock remaining than the average stock quantity?

-- 84. Which customers purchased the same product more than once?

-- 85. Which product categories generated the highest total revenue?

-- 86. Which products are among the top 3 most sold products?

-- 87. Which customers purchased the most expensive product?

-- 88. Which products were purchased by the highest number of unique customers?

-- 89. Which customers made purchases above the average sale amount?

-- 90. Which customers purchased more products than the average quantity purchased per customer?


-- =====================================================
-- ADVANCED WINDOW + ANALYTICAL PROBLEMS
-- =====================================================

-- 91. Which customers rank in the top 10% of spending?

-- 92. Which products contribute to the top 50% of total revenue?

-- 93. Which customers made purchases in consecutive months?

-- 94. Which products experienced the largest difference between stock quantity and total quantity sold?

-- 95. Which customers have spending above the average spending of their membership tier?

-- 96. Which products have higher sales than the average sales within their category?

-- 97. Which customer made the largest single purchase relative to their total spending?

-- 98. Which products rank among the top 3 most sold products within each category?

-- 99. Which customers are tied for the highest total spending?

-- 100. Which products generated sales every year present in the dataset?

