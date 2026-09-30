**Week 3 Day 3: SQL Aggregation, Subqueries & CTEs**

**Overview**

This task focuses on advanced SQL concepts using the **DVD Rental Database**.

The main topics covered are:

**Aggregate Functions**

**GROUP BY**

**HAVING**

**Subqueries**

**CTEs**

**Window Functions**

**PARTITION BY**

**RANK()**

**ROW_NUMBER()**

**LAG()**

**CASE WHEN**

**1. Aggregate Functions**

Aggregate functions are used to calculate a summary from multiple rows.

Common aggregate functions are:

**`COUNT()`:** counts rows

**`SUM()`:** adds values

**`AVG()`:** calculates the average

**`MIN()`:** finds the smallest value

**`MAX()`:** finds the largest value

For example, `SUM(amount)` is used to calculate total revenue.

**2. GROUP BY**

`GROUP BY` is used when we want to calculate a result separately for each group.

For example, if we want total revenue for each store, we use:

```sql
GROUP BY store_id
```

This gives a separate result for each store.

**3. WHERE vs HAVING**

`WHERE` filters individual rows before grouping.

`HAVING` filters groups after `GROUP BY`.

**Example:**

```sql
WHERE amount > 5
```

filters individual payments.

```sql
HAVING SUM(amount) > 100
```

filters groups whose total amount is greater than 100.

**Subquery vs CTE vs Window Function**

**Subquery**

A subquery is a query inside another query.

**When to use it?**

Use a subquery when one query needs the result of another query.

For example, finding customers who spent more than the average customer spending requires calculating the average first and then comparing customers against it.

**Simple idea:**

**Subquery = Query inside another query**

**CTE**

CTE stands for **Common Table Expression**.

It is created using the `WITH` keyword.

**When to use it?**

Use a CTE when a problem has multiple steps or when a query becomes difficult to read.

A CTE allows us to create a temporary result first and then use that result in another query.

**Simple idea:**

**CTE = Break a complex query into clear steps**

**Window Function**

A window function performs a calculation across related rows without removing the original rows.

**Examples include:**

* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* `LAG()`

**When to use it?**

Use window functions when you need ranking, previous/next values, or calculations across related rows while keeping the individual rows.

**Simple idea:**

**Window Function = Calculate across rows without grouping them into one row**

**GROUP BY vs PARTITION BY**

**GROUP BY**

`GROUP BY` combines rows into groups and normally returns fewer rows.

**Example:**

```sql
GROUP BY customer_id
```

This can return one row for each customer.

**PARTITION BY**

`PARTITION BY` divides rows into groups for a window function but keeps the individual rows.

**For example:**

```sql
RANK() OVER (
    PARTITION BY city
    ORDER BY total_spent DESC
)
```

This ranks customers separately within each city.

**Simple difference:**

**GROUP BY → combines rows**

**PARTITION BY → keeps rows but divides them into groups for calculations**

**Business Questions**

**Part 1 — Aggregation Basics**

**Question 1: Total Revenue per Store**

We joined the `payment`, `rental`, and `inventory` tables to identify which store was connected to each payment.

Then we used:

```sql
SUM(amount)
```

to calculate total revenue.

Finally, `GROUP BY store_id` gave us the total revenue for each store.

**Question 2: Average Rental Duration per Film Category**

We joined the `film`, `film_category`, and `category` tables.

Then we used:

```sql
AVG(rental_duration)
```

to calculate the average rental duration.

`GROUP BY category` gave us a separate average for each film category.

**Question 3: Number of Rentals Each Month**

We used the `rental_date` from the rental table.

`DATE_TRUNC('month', rental_date)` was used to group rentals by month.

Then:

```sql
COUNT(*)
```

counted the number of rentals in each months.

**Question 4: Categories with More Than 50 Films**

We counted the films in each category using:

```sql
COUNT(film_id)
```

Then we used:

```sql
HAVING COUNT(film_id) > 50
```

to keep only categories containing more than 50 films.

`HAVING` was used because we were filtering an aggregated result.

**Part 2: Subquery Challenges**

**Question 5: Customers Who Spent More Than Average**

First, we calculated the total amount spent by each customer.

Then we calculated the average of all customer spending.

Finally, we used a subquery to find customers whose total spending was greater than the average.

This question demonstrates how a subquery can be used when one calculation depends on another calculation.

**Question 6: Highest Rental Rate Film in Each Category**

We used a correlated subquery.

For every film, the subquery checked the highest rental rate inside that film's category.

The outer query then returned the film whose rental rate matched that maximum value.

The subquery is called **correlated** because it uses the category from the outer query.

**Question 7 — Customers Who Never Rented a Film**

We used `NOT EXISTS`.

For every customer, the query checked whether a matching rental record existed.

If no rental was found, the customer was included in the result.

This helps identify customers who have never rented a film.

**Question 8: Store with the Highest Total Revenue**

First, we calculated the total revenue for each store.

Then a subquery found the maximum store revenue.

The outer query compared each store's revenue with that maximum value and returned the store with the highest revenue.

**Part 3: CTE & Window Function Challenges**

**Question 9: Rank Customers by Total Spend Within Each City**

First, a CTE calculated the total spending of each customer and their city.

Then we used:

```sql
RANK()
```

to rank customers according to their spending.

We used:

```sql
PARTITION BY city
```

so that the ranking starts again for each city.

**Question 10: Most Recently Rented Film for Each Customer**

We used `ROW_NUMBER()` to number each customer's rentals.

The rentals were ordered by rental date from newest to oldest.

The newest rental received:

```text
row_number = 1
```

Then we selected only:

```sql
WHERE row_num = 1
```

This gave the most recently rented film for each customer.

**Question 11: Month-over-Month Rental Revenue Growth**

First, a CTE calculated the total revenue for each month.

Then we used:

```sql
LAG()
```

to get the revenue from the previous month.

Finally, we calculated the percentage growth using:

```text
(Current Revenue - Previous Revenue)
------------------------------------ × 100
       Previous Revenue
```

This shows whether revenue increased or decreased compared with the previous month.

**Question 12: Top 3 Highest-Grossing Films per Category**

First, a CTE calculated the total revenue generated by each film.

Another CTE used:

```sql
RANK()
```

to rank films within each category.

We used:

```sql
PARTITION BY category
```

so that each category had its own ranking.

Finally, we selected:

```sql
WHERE revenue_rank <= 3
```

to get the top 3 films in each category.

**Bonus Challenge**

**Highest-Revenue Staff Member in Each Store**

This query used multiple SQL concepts together.

**Step 1**

A CTE calculated the revenue processed by each staff member in each store.

**Step 2**

`RANK()` ranked staff members within each store.

**Step 3**

Another CTE calculated the total revenue of each store.

**Step 4**

The highest-ranked staff member was selected.

**Step 5**

The staff member's revenue was divided by the store's total revenue to calculate their percentage contribution.

This challenge combines:

* Aggregation
* CTEs
* `RANK()`
* `PARTITION BY`
* JOIN
* Percentage calculation
  
**RANK() vs DENSE_RANK()**

`RANK()` gives the same rank to tied values but leaves a gap after the tie.

**Example:**

```text
100 → 1
100 → 1
90  → 3
```

`DENSE_RANK()` does not leave a gap.

**Example:**

```text
100 → 1
100 → 1
90  → 2
```

So:

* `RANK()` → gaps after ties
* `DENSE_RANK()` → no gaps

**CASE WHEN**

`CASE WHEN` works like an IF condition in SQL.

It is useful when we want to create categories or perform conditional calculations.

For example:

```sql
CASE
    WHEN amount >= 5 THEN 'High'
    ELSE 'Low'
END
```

This classifies payments as High or Low.

It can also be used inside aggregate functions to count specific types of records.

**Three Business Insights**

The following insights can be taken from the results of the queries:

**1. Store Revenue**

The total revenue per store allows us to compare the financial performance of different stores and identify which store
generates more revenue.

**2. Customer Spending**

Customers who spend more than the average customer can be identified as high-value customers. This information can help a
business understand its most valuable customers.

**3. Film and Category Performance**

The top-grossing films and categories show which types of films generate more rental revenue. This information can help the 
business understand customer demand and make better decisions about its film inventory.


# SQL Skills Practiced

During this task, I practiced:

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`
* `GROUP BY`
* `HAVING`
* `WHERE`
* Subqueries
* Correlated subqueries
* `NOT EXISTS`
* CTEs using `WITH`
* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* `LAG()`
* `PARTITION BY`
* `CASE WHEN`
* `JOIN`
* Percentage calculations

---

# Conclusion

This task helped me understand how SQL can be used for more than just retrieving data.

I learned how to:

* Summarize data using aggregate functions.
* Group data using `GROUP BY`.
* Filter grouped results using `HAVING`.
* Use subqueries for multi-step questions.
* Use CTEs to make complex queries easier to read.
* Use window functions for ranking and comparisons.
* Use `PARTITION BY` to perform calculations within groups.
* Solve real business questions using SQL.
