---**primary key **
SELECT
    tc.table_name,
    kcu.column_name AS primary_key
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

---**foreign key**
SELECT
    tc.table_name AS table_name,
    kcu.column_name AS foreign_key,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
    AND tc.table_schema = ccu.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

---**Part 2 — SQL JOIN Challenges**
---**1.Display Customer Name, Email, City, and Country.**
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    ci.city,
    co.country
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id;

---**2.Display every payment with Customer Name, Film Title, and Amount Paid.**
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    f.title AS film_title,
    p.amount AS amount_paid
FROM payment AS p
JOIN customer AS c
    ON p.customer_id = c.customer_id
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id;
---**3.Display every payment with Customer Name, Film Title, and Amount Paid.**
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    f.title AS film_title,
    p.amount AS amount_paid
FROM payment AS p
JOIN customer AS c
    ON p.customer_id = c.customer_id
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id;

---**4.Find the Top 10 customers based on total amount spent.**
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(p.amount) AS total_spent
FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;

---**5.Display each film with its Category and Rental Rate.**
SELECT
    f.title AS film_title,
    c.name AS category,
    f.rental_rate
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
ORDER BY f.title;

---**6.Find all actors who appeared in each film.**
SELECT
    f.title AS film_title,
    a.first_name || ' ' || a.last_name AS actor_name
FROM film AS f
JOIN film_actor AS fa
    ON f.film_id = fa.film_id
JOIN actor AS a
    ON fa.actor_id = a.actor_id
ORDER BY f.title, actor_name;

---**7.Count how many films belong to each category.**
SELECT
    c.name AS category,
    COUNT(fc.film_id) AS film_count
FROM category AS c
JOIN film_category AS fc
    ON c.category_id = fc.category_id
GROUP BY
    c.category_id,
    c.name
ORDER BY film_count DESC;

---**8.Which categories generated the highest revenue? (Hint: This requires joining multiple tables.**
SELECT
    c.name AS category,
    SUM(p.amount) AS total_revenue
FROM payment AS p
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
GROUP BY
    c.category_id,
    c.name
ORDER BY total_revenue DESC;


---**9.Find customers who have rented more than 20 films**
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(r.rental_id) > 20
ORDER BY total_rentals DESC;

---**10.Which cities generated the highest rental revenue?**
SELECT
    ci.city,
    SUM(p.amount) AS total_revenue
FROM payment AS p
JOIN customer AS c
    ON p.customer_id = c.customer_id
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
GROUP BY
    ci.city_id,
    ci.city
ORDER BY total_revenue DESC;

---**Bonus Challenge**
---**Which actor has generated the highest total rental revenue?**
SELECT
    a.actor_id,
    a.first_name || ' ' || a.last_name AS actor_name,
    SUM(p.amount) AS total_revenue
FROM actor AS a
JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
JOIN film AS f
    ON fa.film_id = f.film_id
JOIN inventory AS i
    ON f.film_id = i.film_id
JOIN rental AS r
    ON i.inventory_id = r.inventory_id
JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY
    a.actor_id,
    a.first_name,
    a.last_name
ORDER BY total_revenue DESC
LIMIT 1;








	

