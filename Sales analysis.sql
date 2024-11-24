-- Create Sales table

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    total_price DECIMAL(10, 2)
);

-- Insert sample data into Sales table

INSERT INTO Sales (sale_id, product_id, quantity_sold, sale_date, total_price) VALUES
(1, 101, 5, '2024-01-01', 2500.00),
(2, 102, 3, '2024-01-02', 900.00),
(3, 103, 2, '2024-01-02', 60.00),
(4, 104, 4, '2024-01-03', 80.00),
(5, 105, 6, '2024-01-03', 90.00);


-- Create Products table

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

-- Insert sample data into Products table

INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
(101, 'Laptop', 'Electronics', 500.00),
(102, 'Smartphone', 'Electronics', 300.00),
(103, 'Headphones', 'Electronics', 30.00),
(104, 'Keyboard', 'Electronics', 20.00),
(105, 'Mouse', 'Electronics', 15.00);

SELECT *
FROM sales

SELECT *
FROM Products

 ----Find the product category with the highest average unit price.
SELECT TOP 1 category
FROM Products
GROUP BY category
ORDER BY AVG(unit_price) ASC

----Identify products with total sales exceeding 30
SELECT product_name
FROM sales
JOIN products on products.product_id=sales.product_id
GROUP BY product_name
HAVING SUM(sales.total_price)>30

---Count the number of sales made in each month.
select FORMAT(sale_date, 'MM') as month, COUNT(*) AS Sales_count
FROM SALES
GROUP BY FORMAT(sale_date, 'MM');

-----Determine the average quantity sold for products with
---a unit price greater than $100.
SELECT AVG(sales.quantity_sold) AS average_quantity_sold
FROM sales
JOIN products on products.product_id=sales.product_id
WHERE products.unit_price>100

----Retrieve the product name and total sales revenue for each product.
select products.product_name, SUM(sales.total_price) as total_sales_revenue
From sales
JOIN products on products.product_id=sales.product_id
GROUP BY products.product_name;

---List all sales along with the corresponding product names.
SELECT sales.sale_id, products.product_name
from sales
JOIN products on products.product_id=sales.product_id

---Rank Products Based on Total Sales Revenue
SELECT products.product_name, SUM(sales.total_price) AS total_sales_revenue,
    RANK() OVER (ORDER BY SUM(sales.total_price) DESC) AS product_rank
FROM sales
JOIN products ON products.product_id = sales.product_id
GROUP BY products.product_name
---Calculate the running total revenue for each product category.
SELECT 
    products.category, 
    products.product_name, 
    SUM(sales.total_price) AS total_sales_revenue,
    SUM(SUM(sales.total_price)) OVER (PARTITION BY products.category ORDER BY products.product_name) AS running_total_revenue
FROM sales
JOIN products ON products.product_id = sales.product_id
GROUP BY products.category, products.product_name
ORDER BY products.category, products.product_name;
---Categorize sales as “High”, “Medium”, or “Low”
---based on total price (e.g., > $200 is High, $100-$200 is Medium, < $100 is Low)
SELECT 
    sales.sale_id, 
    sales.total_price,
    CASE 
        WHEN sales.total_price > 200 THEN 'High'
        WHEN sales.total_price BETWEEN 100 AND 200 THEN 'Medium'
        WHEN sales.total_price < 100 THEN 'Low'
    END AS sales_category
FROM sales;
---Identify sales where the quantity sold is greater than the average quantity sold.
select *
from sales
WHERE quantity_sold>(SELECT AVG(quantity_sold) FROM SALES);
-----Extract the month and year 
--from the sale date and count the number of sales for each month.

SELECT 
    sales.sale_id,
    sales.sale_date,
    DATEDIFF(DAY, sales.sale_date, GETDATE()) AS DaysSinceSale
FROM 
    sales;

	SELECT 
    sales.sale_id, 
    sales.sale_date,
    CASE 
        WHEN DATEPART(WEEKDAY, sales.sale_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS SaleDayType
FROM 
    sales;

