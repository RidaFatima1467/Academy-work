**PART 1:Aggregation Basics**
  
--1. How much money did each store generate?
  
SELECT
    i.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r
    ON p.rental_id = r.rental_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
GROUP BY i.store_id
ORDER BY total_revenue DESC;

--2. Find the average rental duration per film category.

SELECT
    c.name AS category,
    AVG(f.rental_duration) AS average_rental_duration
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY average_rental_duration DESC;

--3. Find the number of rentals made each month.

SELECT
    DATE_TRUNC('month', rental_date) AS month,
    COUNT(*) AS rental_count
FROM rental
GROUP BY DATE_TRUNC('month', rental_date)
ORDER BY month;

--4. Find categories with more than 50 films (use HAVING).

SELECT
    c.name AS category,
    COUNT(f.film_id) AS film_count
FROM category c
JOIN film_category fc
    ON c.category_id = fc.category_id
JOIN film f
    ON fc.film_id = f.film_id
GROUP BY c.name
HAVING COUNT(f.film_id) > 50
ORDER BY film_count DESC;


**--Part 2: Subquery Challenges**

--5. Find customers who spent more than the average customer spend.
  
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING SUM(p.amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT
            customer_id,
            SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_spent DESC;

--6. Find the film(s) with the highest rental rate in each category (use a correlated subquery).

SELECT
    f.film_id,
    f.title,
    f.rental_rate,
    c.name AS category
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
WHERE f.rental_rate = (
    SELECT MAX(f2.rental_rate)
    FROM film f2
    JOIN film_category fc2
        ON f2.film_id = fc2.film_id
    WHERE fc2.category_id = fc.category_id
)
ORDER BY c.name, f.title;

--7. Find customers who have never rented a film (use NOT IN / NOT EXISTS).

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental r
    WHERE r.customer_id = c.customer_id
);

--8. Find the store with the highest total revenue using a subquery in the WHERE clause.

SELECT
    i.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r
    ON p.rental_id = r.rental_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
GROUP BY i.store_id
HAVING SUM(p.amount) = (
    SELECT MAX(store_revenue)
    FROM (
        SELECT
            i2.store_id,
            SUM(p2.amount) AS store_revenue
        FROM payment p2
        JOIN rental r2
            ON p2.rental_id = r2.rental_id
        JOIN inventory i2
            ON r2.inventory_id = i2.inventory_id
        GROUP BY i2.store_id
    ) AS store_totals
);

**--Part 3: CTE & Window Function Challenges**


--9. Using a CTE, rank customers by total spend within each city.

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        ci.city,
        SUM(p.amount) AS total_spent
    FROM customer c
    JOIN address a
        ON c.address_id = a.address_id
    JOIN city ci
        ON a.city_id = ci.city_id
    JOIN payment p
        ON c.customer_id = p.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        ci.city
)
SELECT
    customer_id,
    first_name,
    last_name,
    city,
    total_spent,
    RANK() OVER (
        PARTITION BY city
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM customer_spending
ORDER BY city, spending_rank;

--10. Using ROW_NUMBER(), find the most recently rented film for each customer.

WITH ranked_rentals AS (
    SELECT
        r.customer_id,
        r.rental_date,
        f.film_id,
        f.title,
        ROW_NUMBER() OVER (
            PARTITION BY r.customer_id
            ORDER BY r.rental_date DESC
        ) AS row_num
    FROM rental r
    JOIN inventory i
        ON r.inventory_id = i.inventory_id
    JOIN film f
        ON i.film_id = f.film_id
)
SELECT
    customer_id,
    film_id,
    title,
    rental_date
FROM ranked_rentals
WHERE row_num = 1
ORDER BY customer_id;

--11. Using a CTE, calculate month-over-month rental revenue growth.

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', p.payment_date) AS month,
        SUM(p.amount) AS revenue
    FROM payment p
    GROUP BY DATE_TRUNC('month', p.payment_date)
),
revenue_with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    previous_revenue,
    ROUND(
        ((revenue - previous_revenue) / NULLIF(previous_revenue, 0)) * 100,
        2
    ) AS growth_percentage
FROM revenue_with_previous
ORDER BY month;

--12. Find the top 3 highest-grossing films per category using RANK() inside a CTE.

WITH film_revenue AS (
    SELECT
        f.film_id,
        f.title,
        c.name AS category,
        SUM(p.amount) AS total_revenue
    FROM film f
    JOIN film_category fc
        ON f.film_id = fc.film_id
    JOIN category c
        ON fc.category_id = c.category_id
    JOIN inventory i
        ON f.film_id = i.film_id
    JOIN rental r
        ON i.inventory_id = r.inventory_id
    JOIN payment p
        ON r.rental_id = p.rental_id
    GROUP BY
        f.film_id,
        f.title,
        c.name
),
ranked_films AS (
    SELECT
        film_id,
        title,
        category,
        total_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM film_revenue
)
SELECT
    film_id,
    title,
    category,
    total_revenue,
    revenue_rank
FROM ranked_films
WHERE revenue_rank <= 3
ORDER BY category, revenue_rank;

**--Bonus Challenge**
  
WITH staff_store_revenue AS (
    SELECT
        i.store_id,
        p.staff_id,
        SUM(p.amount) AS staff_revenue
    FROM payment p
    JOIN rental r
        ON p.rental_id = r.rental_id
    JOIN inventory i
        ON r.inventory_id = i.inventory_id
    GROUP BY
        i.store_id,
        p.staff_id
),
ranked_staff AS (
    SELECT
        store_id,
        staff_id,
        staff_revenue,
        RANK() OVER (
            PARTITION BY store_id
            ORDER BY staff_revenue DESC
        ) AS revenue_rank
    FROM staff_store_revenue
),
store_totals AS (
    SELECT
        store_id,
        SUM(staff_revenue) AS store_total_revenue
    FROM staff_store_revenue
    GROUP BY store_id
)
SELECT
    rs.store_id,
    rs.staff_id,
    rs.staff_revenue,
    st.store_total_revenue,
    ROUND(
        (rs.staff_revenue / NULLIF(st.store_total_revenue, 0)) * 100,
        2
    ) AS percentage_of_store_revenue
FROM ranked_staff rs
JOIN store_totals st
    ON rs.store_id = st.store_id
WHERE rs.revenue_rank = 1
ORDER BY rs.store_id;
