**SQL Foundations: Concept Check**

**1. What problem does SQL solve that CSV files cannot?**

SQL helps us easily search, filter, sort, and analyze large amounts of data. CSV files are good for storing data, but they become difficult to manage when the data is very large.

**2. What is the difference between a database table and a spreadsheet?**

Both store data in rows and columns. A database table is better for storing and working with large amounts of data, while spreadsheets are usually used for smaller data and calculations.

**3. What is a Primary Key?**

A Primary Key is a column that uniquely identifies each row in a table.

For example, `Customer ID` can identify a customer.

**4. What is a Foreign Key?**

A Foreign Key is a column that connects one table to another table.

It usually refers to the Primary Key of another table.

**5. What is the difference between WHERE and HAVING?**

`WHERE` filters individual rows.

`HAVING` filters groups after using `GROUP BY`.

Simple way to remember:

* WHERE → filters rows
* HAVING → filters groups

**6. What is the difference between ORDER BY and GROUP BY?**

`ORDER BY` is used to sort data.

`GROUP BY` is used to make groups of similar data.

Simple way to remember:

* ORDER BY → Sort
* GROUP BY → Group

**7. What does DISTINCT do?**

`DISTINCT` removes duplicate values and shows each value only once.

Example:

```sql
SELECT DISTINCT "Category"
FROM superstore_sales;
```

**8. When should you use LIMIT?**

`LIMIT` is used when we only want a specific number of rows.

For example:

```sql
SELECT *
FROM superstore_sales
LIMIT 10;
```

This shows only 10 rows.

**9. What are aggregate functions?**

Aggregate functions are used to calculate values from many rows.

Common aggregate functions are:

* `COUNT()` → counts rows
* `SUM()` → calculates total
* `AVG()` → calculates average
* `MIN()` → finds smallest value
* `MAX()` → finds largest value

**10. Why do Data Scientists prefer databases over Excel for large datasets?**

Databases can handle very large amounts of data more efficiently. SQL also makes it easy to search, filter, sort,
and analyze the data without loading everything into memory.
