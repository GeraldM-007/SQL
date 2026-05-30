
set search_path to assignment;

show search_path;

select current_schema();


-- =====================================================
-- PART 2
-- =====================================================
-- =====================================================
-- SUBQUERY QUESTIONS
-- =====================================================

-- 51. Which customers have spent more than the average spending of all customers?
select c.first_name, c.last_name, sum(s.total_amount) as total_spent, 
(select avg(total_amount) from sales) as avg_spending
from customers c
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name
having sum(s.total_amount) > (select avg(total_amount) from sales);

-- 52. Which products are priced higher than the average price of all products?
select product_name, price,
(select avg(price) from products) as avg_price
from products 
where price > (select avg(price) from products);

-- 53. Which customers have never made a purchase?
select c.first_name, c.last_name
from customers c 
where c.customer_id not in (select distinct customer_id from sales);

--using concat
select concat(c.first_name, ' ', c.last_name) as customer_name
from customers c
where c.customer_id not in (select distinct customer_id from sales);

-- 54. Which products have never been sold?
select p.product_name
from products p
where p.product_id not in (select distinct product_id from sales);

-- 55. Which customer made the single most expensive purchase?
select c.first_name, c.last_name,
(select max(total_amount) from sales) as highest_purchase
from sales s
join customers c on s.customer_id = c.customer_id
where s.total_amount = (select max(total_amount) from sales);

-- 56. Which products have total sales greater than the average total sales across all products?
select p.product_name, sum(s.total_amount) as total_sales,
(select avg(total_amount) from sales) as avg_total_sales
from products p 
join sales s on p.product_id = s.product_id
group by p.product_name
having sum(s.total_amount) > (select avg(total_amount) from sales);


-- 57. Which customers registered earlier than the average registration date?
select first_name, last_name, registration_date,
(select avg(registration_date) from customers) as avg_reg_date
from customers
where registration_date < (select avg(registration_date) from customers);

-- 58. Which products have a price higher than the average price within their own category?
select p.product_name, p.category, p.price, avg_price
from(
select category, avg(price) as avg_price
from products
group by category
) as average
join products p on p.category = average.category
where p.price > avg_price;


-- 59. Which customers have spent more than the customer with ID = 10?

select c.customer_id, concat(c.first_name, ' ', c.last_name)as customer_name, sum(s.total_amount) as cust_spend,
(select total_amount from sales where customer_id = 10) as cust_10_spend
from sales s
join customers c on s.customer_id = c.customer_id
where s.total_amount > (select total_amount from sales where customer_id = 10)
group by c.customer_id
order by c.customer_id;


-- 60. Which products have total quantity sold greater than the overall average quantity sold?
select p.product_name, s.product_id, sum(s.quantity_sold) as total_quantity_sold,
(select avg(quantity_sold) from sales) as avg_quantity_sold
from sales s
join products p on p.product_id = s.product_id
group by s.product_id,p.product_name
having sum(quantity_sold) > (select avg(quantity_sold) from sales);


-- =====================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================

-- 61. Create an intermediate result that calculates the total amount spent by each customer,
--     then determine which customers are the top 5 highest spenders.
with total_amount_spent as (
select c.first_name, c.last_name, sum(s.total_amount) as total_spent
from customers c
join sales s on s.customer_id = c.customer_id
group by c.first_name, c.last_name
order by sum(s.total_amount) desc
)
select * from total_amount_spent
limit 5;


-- 62. Create an intermediate result that calculates total quantity sold per product,
--     then determine which products are the top 3 most sold.
with total_quantity_per_product as (
select p.product_name, sum(s.quantity_sold) as total_sold
from products p
join sales s on p.product_id = s.product_id
group by p.product_name
order by sum(s.quantity_sold) desc
)
select * from total_quantity_per_product
limit 3;

-- 63. Create an intermediate result showing total sales per product category,
--     then determine which category generates the highest revenue.
with total_sales_by_category as(
select p.category, sum(s.total_amount) as total_sales
from products p
join sales s on p.product_id = s.product_id
group by p.category
order by sum(s.total_amount) desc
)
select * from total_sales_by_category
limit 1;

-- 64. Create an intermediate result that calculates the number of purchases per customer,
--     then identify customers who purchased more than twice.
with no_of_purchases_per_customers as (
select c.first_name, c.last_name, count(sale_id) as no_of_purchases
from customers c
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name
having  count(sale_id) > 2
)
select * from no_of_purchases_per_customers;

-- 65. Create an intermediate result that calculates the total quantity sold per product,
--     then determine which products sold more than the average quantity sold.
with total_quantity_per_product as (
select p.product_id, p.product_name, sum(s.quantity_sold) as quantity_sold
from products p
join sales s on p.product_id = s.product_id
group by p.product_id, p.product_name
),
avg_quantity_sold as(
select avg(quantity_sold) as avg_quantity
from sales
)
select t.product_name, t.quantity_sold, a.avg_quantity
from total_quantity_per_product t
cross join avg_quantity_sold a
where t.quantity_sold > a.avg_quantity;

-- 66. Create an intermediate result that calculates total spending per customer,
--     then determine which customers spent more than the average spending.
with total_spending as (
select c.customer_id, c.first_name, c.last_name, sum(s.total_amount) as total_spend
from customers c
join sales s on c.customer_id = s.customer_id
group by c.customer_id, c.first_name, c.last_name
),
avg_spending as (
select avg(total_amount) as avg_spend
from sales
)
select t.first_name, t.last_name, t.total_spend, a.avg_spend
from total_spending t
cross join avg_spending a
where t.total_spend > a.avg_spend;

-- 67. Create an intermediate result that calculates total revenue per product,
--     then list the products ordered from highest revenue to lowest.
with total_rev_per_product as (
select p.product_id, p.product_name, sum(s.total_amount) as total_revenue
from sales s 
join products p on s.product_id = p.product_id
group by p.product_id, p.product_name
)
select * from total_rev_per_product t
order by t.total_revenue desc;

-- 68. Create an intermediate result showing monthly sales totals,
--     then determine which month had the highest revenue.
with total_monthly_sales as (
select date_trunc('month', sale_date) as sale_month,
count(sale_id) as number_of_sales,
sum(total_amount) as total_revenue
from sales
group by date_trunc('month', sale_date)
)
select sale_month, number_of_sales, total_revenue
from total_monthly_sales
order by total_revenue desc
limit 1;

-- 69. Create an intermediate result that calculates the number of sales per product,
--     then determine which products were purchased by more than three customers.
with number_of_sales_per_product as (
select p.product_id, p.product_name, count(s.sale_id) as number_of_sales
from products p
join sales s on p.product_id = s.product_id
group by p.product_id, p.product_name
),
customer_product_purchase_count as(
select product_id, count(sale_id) as purchase_count
from sales
group by product_id
)
select n.product_name, n.number_of_sales, c.purchase_count
from number_of_sales_per_product n
join customer_product_purchase_count c on n.product_id = c.product_id
where c.purchase_count >= 3;

-- 70. Create an intermediate result showing total quantity sold per product,
--     then identify products that sold less than the average quantity sold.
with total_quantity_per_product as (
select p.product_name, sum(s.quantity_sold) as quantity_sold
from products p
join sales s on p.product_id = s.product_id
group by p.product_name
),
avg_quantity_sold as(
select avg(quantity_sold) as avg_quantity
from sales
)
select t.product_name, t.quantity_sold, a.avg_quantity
from total_quantity_per_product t
cross join avg_quantity_sold a
where t.quantity_sold < a.avg_quantity;


-- =====================================================
-- WINDOW FUNCTION QUESTIONS
-- =====================================================

-- 71. Rank customers based on the total amount they have spent.
select c.first_name, c.last_name, s.total_amount,
rank() over(order by s.total_amount desc) as rank_by_amount
from customers c
join sales s on c.customer_id = s.customer_id;

-- 72. Rank products based on total quantity sold.
select p.product_name, sum(s.quantity_sold),
dense_rank () over(order by sum(s.quantity_sold) desc) as rank_by_quantity_sold
from products p
join sales s on p.product_id = s.product_id
group by p.product_name;

-- 73. Identify the 3rd highest spending customer.
select c.first_name, c.last_name, s.total_amount,
rank() over(order by s.total_amount desc) as rank_by_amount
from customers c
join sales s on c.customer_id = s.customer_id;

-- 74. Identify the 2nd most expensive product.
select product_name, price, 
rank() over(order by price desc) as rank_by_price
from products;

-- Not complete

-- 75. Show the ranking of products within each category based on price.
select product_name, category, price,
rank() over(partition by category order by price desc) as rank_by_price
from products;

-- 76. Show the ranking of customers based on the number of purchases they made.
select c.first_name, c.last_name,
dense_rank() over(order by count(s.sale_id) desc) as rank_by_purchase_count
from sales s
join customers c on s.customer_id = c.customer_id
group by c.first_name, c.last_name;

-- 77. Show the ranking total of sales amounts ordered by sale_date.
select sale_date, total_amount,
rank() over(order by sale_date desc) as rank_by_date
from sales;

-- 78. Show the previous sale amount for each sale ordered by sale_date.
select sale_date, total_amount,
lag(total_amount) over(order by sale_date desc) as rank_by_date
from sales;

-- 79. Show the next sale amount for each sale ordered by sale_date.
select sale_date, total_amount,
lead(total_amount) over(order by sale_date desc) as rank_by_date
from sales;

-- 80. Divide customers into 4 groups based on total spending.
select c.first_name, c.last_name, sum(s.total_amount) as total_spending,
ntile(4) over(order by sum(s.total_amount) desc) as spending_tile
from customers c
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name;

-- =====================================================
-- ADVANCED ANALYTICAL QUESTIONS
-- =====================================================

-- 81. Which customers bought products in more than one category?
select c.customer_id, c.first_name, c.last_name, p.category, count(distinct p.category) as product_categories
from customers c 
left join sales s on c.customer_id = s.customer_id
left join products p on s.product_id = p.product_id
group by c.customer_id, c.first_name, c.last_name, p.category
having count(distinct p.category) > 0 --used 0 to show an output as there are no customers who bought from more than one category
order by product_categories desc;

-- 82. Which customers purchased products within 7 days of registering?
select c.first_name, c.last_name, c.registration_date, p.product_name, s.sale_date as purchase_date,
s.sale_date - c.registration_date as days_after_registration
from customers c 
join sales s on c.customer_id = s.customer_id
join products p on s.product_id = p.product_id
where s.sale_date >= c.registration_date and s.sale_date <= c.registration_date + interval '365 days'
order by c.customer_id, s.sale_date;

-- 83. Which products have lower stock remaining than the average stock quantity?
with avg_stock_qty as (
select avg(stock_quantity) as avg_stock 
from inventory
)
select p.product_name, i.stock_quantity, a.avg_stock
from products p
join inventory i on p.product_id = i.product_id
cross join avg_stock_qty a
where i.stock_quantity < a.avg_stock;

-- 84. Which customers purchased the same product more than once?
select c.customer_id, c.first_name || ' ' || c.last_name as customer_name, p.product_name, count(distinct p.product_name) as distinct_product_count
from customers c
join sales s on c.customer_id = s.customer_id
join products p on s.product_id = p.product_id
group by c.customer_id, p.product_name
having count(distinct p.product_name) > 0
order by distinct_product_count desc;
-- what if the quantity sold per product is > 1? does that count as same product bought more than once? Consider that factor.


-- 85. Which product categories generated the highest total revenue?
select p.category, sum(s.total_amount) as total_revenue
from products p
join sales s on p.product_id = s.product_id
group by p.category
order by total_revenue desc
limit 1;

-- 86. Which products are among the top 3 most sold products?
select p.product_name, sum(s.quantity_sold) as quantity_sold
from products p
join sales s on p.product_id = s.product_id
group by p.product_name
order by quantity_sold desc
limit 3;

-- 87. Which customers purchased the most expensive product?
with expensive_product as (
select max(price) as highest_price
from products
)
select c.first_name, c.last_name, p.product_name, e.highest_price
from customers c
join sales s on c.customer_id = s.customer_id
join products p on s.product_id = p.product_id
cross join expensive_product e
where p.price = e.highest_price;

-- 88. Which products were purchased by the highest number of unique customers?


-- 89. Which customers made purchases above the average sale amount?
with avg_sale_amount as (
select avg(total_amount) as avg_sale_amount
from sales
)
select c.first_name, c.last_name, sum(s.total_amount) as customer_total_amount, a.avg_sale_amount
from customers c
join sales s on c.customer_id = s.customer_id
cross join avg_sale_amount a
group by c.first_name, c.last_name, a.avg_sale_amount
having sum(s.total_amount) > a.avg_sale_amount;

-- 90. Which customers purchased more products than the average quantity purchased per customer?
with avg_qty_per_customer as (
select avg(quantity_sold) as avg_quantity
from sales
)
select c.first_name, c.last_name, sum(s.quantity_sold) as qty_purchased, a.avg_quantity
from customers c
join sales s on c.customer_id = s.customer_id
cross join avg_qty_per_customer a
group by c.first_name, c.last_name, a.avg_quantity
having sum(s.quantity_sold) > a.avg_quantity;

-- =====================================================
-- ADVANCED WINDOW + ANALYTICAL PROBLEMS
-- =====================================================

-- 91. Which customers rank in the top 10% of spending?
select c.first_name, c.last_name, s.total_amount,
rank() over(order by s.total_amount desc) as rank_by_amount
from customers c
join sales s on c.customer_id = s.customer_id;

select c.first_name, c.last_name, sum(s.total_amount) as total_spending,
ntile(2) over(order by sum(s.total_amount) desc) as spending_tile
from customers c
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name;
-- helps explain ntiles

with n_tile as (
select c.first_name, c.last_name, sum(s.total_amount) as total_spending,
ntile(10) over(order by sum(s.total_amount) desc) as spending_tile
from customers c
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name
)
select * from n_tile
where spending_tile = 1;

-- 92. Which products contribute to the top 50% of total revenue?
with product_contribution as (
select p.product_name, sum(s.total_amount) as total_revenue_per_product,
ntile(2) over(order by sum(s.total_amount) desc) as spending_tile
from products p
join sales s on p.product_id = s.product_id
group by p.product_name
)
select sum(total_revenue_per_product) as total
from product_contribution 
where spending_tile = 1;

-- it might be higher, but they are still contributing the top 50% of the revenue
--approach one
with product_contribution as (
select p.product_name, sum(s.total_amount) as total_revenue_per_product,
percent_rank() over(order by sum(s.total_amount) desc) as spending_tile
from products p
join sales s on p.product_id = s.product_id
group by p.product_name
)
select product_name, sum(total_revenue_per_product) as total, spending_tile
from product_contribution 
where spending_tile <= 0.5
group by product_name, spending_tile;

--approach two
with productrev_ as (
select product_name, sum(total_amount) as rev, sum(total_amount) over (order by sum(total_amount) desc) as runningrev_,
sum(sum(total_amount)) over (order by sum(total_amount) desc) /
sum(sum(total_amount)) over () as runningpct_
from assignment.sales s
join assignment.products p on s.product_id = p.product_id
group by product_name, total_amount
)
select product_name, rev as productrevenue_ 
from productrev_ 
where runningpct_ >= 0.50;

-- 93. Which customers made purchases in consecutive months?

with monthly_sales as(
select c.customer_id, concat(c.first_name, ' ' , c.last_name) as customer_name, s.sale_date, date_trunc('month', s.sale_date) as sale_month
from assignment.customers c 
join assignment.sales s on c.customer_id = s.customer_id
)
select ms1.customer_id, ms1.sale_month, ms2.sale_month
from monthly_sales ms1
join monthly_sales ms2 on ms1.customer_id = ms2.customer_id
where ms1.sale_month = ms2.sale_month + INTERVAL'1 month';

-- 94. Which products experienced the largest difference between stock quantity and total quantity sold?

select p.product_name, p.stock_quantity, s.quantity_sold, (p.stock_quantity - sum(s.quantity_sold)) as difference
from products p
join sales s on p.product_id = s.product_id
group by p.product_name, p.stock_quantity, s.quantity_sold
order by difference desc
limit 1;

-- 95. Which customers have spending above the average spending of their membership tier?

with tier_spending as (
select c.membership_status, avg(s.total_amount) as avg_per_tier
from customers c
join sales s on c.customer_id = s.customer_id
group by c.membership_status
)
select concat(c.first_name, ' ', c.last_name) as customer_name, sum(s.total_amount) as total_spent, avg_per_tier, c.membership_status
from customers c 
join sales s on c.customer_id = s.customer_id
join tier_spending t on c.membership_status = t.membership_status
group by c.first_name, c.last_name, c.membership_status, t.avg_per_tier
having sum(s.total_amount) > t.avg_per_tier;

-- 96. Which products have higher sales than the average sales within their category?

with sales_per_category as (
select p.category, avg(s.total_amount) as avg_per_category
from customers c
join sales s on c.customer_id = s.customer_id
join products p on s.product_id = p.product_id
group by p.category
)
select p.product_name, p.category, sum(s.total_amount) as total_sold, avg_per_category
from products p 
join sales s on p.product_id = s.product_id
join sales_per_category spc on p.category = spc.category
group by p.product_name, p.category, spc.avg_per_category
having sum(s.total_amount) > avg_per_category;


-- 97. Which customer made the largest single purchase relative to their total spending?

select c.first_name, c.last_name, sum(s.total_amount) as total_spending, (max(s.total_amount)/sum(s.total_amount)) as result
from customers c 
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name;

-- 98. Which products rank among the top 3 most sold products within each category?

with products_rank as(
select p.product_name, p.category, s.quantity_sold,
dense_rank() over (partition by category order by s.quantity_sold desc)
from products p
join sales s on p.product_id = s.product_id
)
select product_name, category, quantity_sold, dense_rank
from products_rank
where dense_rank <= 3;

-- 99. Which customers are tied for the highest total spending?

select concat(c.first_name, ' ', c.last_name) as customer_name, sum(s.total_amount) as total_spending,
dense_rank() over (order by sum(s.total_amount) desc)
from customers c
join sales s on c.customer_id = s.customer_id
group by c.first_name, c.last_name;

-- 100. Which products generated sales every year present in the dataset?

select p.product_name, s.sale_date, extract(year from s.sale_date)::text as sale_year 
from products p
join sales s on p.product_id = s.product_id
where extract(year from s.sale_date)::text in (select distinct  extract(year from sale_date)::text from sales);


