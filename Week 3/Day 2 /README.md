**JOINs Used**

**INNER JOIN**

I used INNER JOIN to combine related tables and get only the records that have matching values in both tables.

For example, I used JOIN between `customer` and `payment` using `customer_id`.

**LEFT JOIN**

LEFT JOIN shows all records from the left table and the matching records from the right table. If there is no match, NULL is shown.

**RIGHT JOIN**

RIGHT JOIN shows all records from the right table and the matching records from the left table.

**FULL OUTER JOIN**

FULL OUTER JOIN shows all records from both tables. It also includes records that do not have a match.

**Multiple JOINs**

Some questions needed more than two tables. For example, to find the film related to a payment, I used:

`payment → rental → inventory → film`

This helped me get information from different related tables.


**Relationship Diagram Explanation **

This ER diagram shows the structure of a DVD rental database. It contains different tables that store information
about movies, customers, staff, stores, rentals, and payments. The tables are connected through Primary Keys (PK) 
and Foreign Keys (FK).

**Main Tables**
Country – Stores country information such as country ID and country name.
City – Stores city information and connects each city to a country.
Address – Stores customer, staff, and store address information.
Customer – Stores customer details such as name, email, address, and active status.
Staff – Stores staff information such as name, email, username, password, and store.
Store – Stores information about rental stores and their managers.
Actor – Stores information about actors, including first and last names.
Film – Stores movie information such as title, description, release year, language, rental price, duration, rating, and special features.
Language – Stores the languages available for movies.
Category – Stores movie categories such as Action, Comedy, Drama, etc.
Film_Actor – Connects films with actors. One film can have many actors, and one actor can appear in many films.
Film_Category – Connects films with categories. A film can belong to multiple categories.
Inventory – Keeps track of the copies of each film available at different stores.
Rental – Records when a customer rents an inventory item and which staff member processes the rental.
Payment – Stores payment information related to customers, staff, and rentals.
Relationships

The database uses relationships between tables to avoid storing the same information repeatedly.

For example:

Country → City: One country can have many cities.

City → Address: One city can have many addresses.

Address → Customer/Staff/Store: An address can be associated with customers, staff, or stores.

Language → Film: One language can be used for many films.

Film → Inventory: A film can have multiple copies in the inventory.

Store → Inventory: A store can have many inventory items.

Film ↔ Actor: This is a many-to-many relationship handled by the film_actor table.

Film ↔ Category: This is a many-to-many relationship handled by the film_category table.

Customer → Rental: A customer can make many rentals.

Staff → Rental: A staff member can process many rentals.

Rental → Payment: A rental can have a related payment record.

Primary Keys and Foreign Keys

Primary Key (PK) uniquely identifies each record in a table.

For example:

customer_id
film_id
actor_id
rental_id

Foreign Key (FK) connects one table to another.

For example:

customer.address_id connects Customer with Address.

film.language_id connects Film with Language.

rental.customer_id connects Rental with Customer.

rental.inventory_id connects Rental with Inventory.

**Purpose of the ER Diagram**

The main purpose of this ER diagram is to show how the different parts of the rental database are connected.
It makes it easier to understand the database structure and write SQL queries using JOINs to get information from multiple tables.


**How Each Business Question Was Solved**

**Question 1: Customer Name, Email, City and Country**

I joined `customer`, `address`, `city`, and `country`.

The relationship is:

`customer → address → city → country`

This allowed me to display the customer's name, email, city, and country together.

**Question 2: Payment, Customer Name, Film Title and Amount**

I joined `payment`, `customer`, `rental`, `inventory`, and `film`.

The payment is connected to the customer directly. To find the film, I followed:

`payment → rental → inventory → film`

This allowed me to display the customer name, film title, and payment amount.

**Question 3: Payment, Customer Name, Film Title and Amount**

Question 3 has the same requirement as Question 2, so I used the same JOINs.

I connected:

`payment → customer`

and:

`payment → rental → inventory → film`

**Question 4: Top 10 Customers by Total Spending**

I joined the `customer` and `payment` tables.

I used `SUM()` to calculate the total amount spent by each customer.

I used `GROUP BY` to calculate the total for each customer and `ORDER BY DESC` to show the highest amounts first.

Finally, I used `LIMIT 10` to display the top 10 customers.

**Question 5: Films with Category and Rental Rate**

I joined:

`film → film_category → category`

The `film_category` table connects films with categories.

This allowed me to display each film, its category, and its rental rate.

**Question 6: Actors in Each Film**

I joined:

`film → film_actor → actor`

The `film_actor` table connects films and actors.

This allowed me to find which actors appeared in each film.

**Question 7: Number of Films in Each Category**

I joined the `category` and `film_category` tables.

I used `COUNT()` to count the number of films in each category.

I used `GROUP BY` to get a separate count for every category.

**Question 8: Category Revenue**

I used multiple JOINs:

`payment → rental → inventory → film → film_category → category`

I used `SUM()` to calculate the total revenue for each category.

Then I used `ORDER BY DESC` to show the categories from highest revenue to lowest revenue.

**Question 9: Customers with More Than 20 Rentals**

I joined the `customer` and `rental` tables.

I used `COUNT()` to count how many rentals each customer had.

I used `HAVING COUNT(...) > 20` to show only customers who rented more than 20 films.

**Question 10: Cities with Highest Rental Revenue**

I joined:

`payment → customer → address → city`

I used `SUM()` to calculate the total rental revenue for each city.

Then I sorted the results from highest revenue to lowest revenue.

**Three Business Insights**

After checking the query results, I found these business insights:

1. **Customer spending is different:** Some customers spent much more money than others,
showing that a small group of customers contributes a large amount of rental revenue.

2. **Categories have different revenue:** Some film categories generated more revenue than
other categories. This shows that customers have different rental preferences.

3. **Cities have different rental revenue:** Some cities generated more rental revenue than
others, showing that rental activity is different across locations.


