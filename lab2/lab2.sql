/*
Lab 2 report <Hadi Ansari (hadan326) and Sayed Ismail Safwat (saysa289)>
*/

/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS jbitem2 CASCADE;
DROP VIEW IF EXISTS total_cost_view CASCADE;
DROP VIEW IF EXISTS total_cost_view2 CASCADE;
DROP VIEW IF EXISTS item_less_view CASCADE;
DROP VIEW IF EXISTS item_less CASCADE;
DROP VIEW IF EXISTS jbsale_supply_view CASCADE; 
DROP TABLE *;


/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/*
Question 1: List all employees, i.e., all tuples in the jbemployee relation.
*/

SELECT * FROM jbemployee;

/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
25 rows in set (0.01 sec)

*/


/*
Question 2: List the name of all departments in alphabetical order. Note: by “name”
we mean the name attribute in the jbdept relation. 
*/
SELECT name FROM jbdept ORDER BY name;

/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
19 rows in set (0.01 sec)
*/


/*
Question 3: What parts are not in store? Note that such parts have the value 0 (zero)
for the qoh attribute (qoh = quantity on hand).
*/
SELECT * FROM jbparts WHERE qoh = 0;

/*
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+
4 rows in set (0.00 sec)
*/

/*
Question 4: . List all employees who have a salary between 9000 (included) and
10000 (included)?
*/
SELECT * FROM jbemployee WHERE salary >= 9000 AND salary <= 10000;

/*
+-----+----------------+--------+---------+-----------+-----------+
| id  | name           | salary | manager | birthyear | startyear |
+-----+----------------+--------+---------+-----------+-----------+
|  13 | Edwards, Peter |   9000 |     199 |      1928 |      1958 |
|  32 | Smythe, Carol  |   9050 |     199 |      1929 |      1967 |
|  98 | Williams, Judy |   9000 |     199 |      1935 |      1969 |
| 129 | Thomas, Tom    |  10000 |     199 |      1941 |      1962 |
+-----+----------------+--------+---------+-----------+-----------+
4 rows in set (0.01 sec)
*/

/*
Question 5: List all employees together with the age they had when they started
working? Hint: use the startyear attribute and calculate the age in the
SELECT clause. 
*/
SELECT *, startyear - birthyear  as age FROM jbemployee;

/*
+------+--------------------+--------+---------+-----------+-----------+------+
| id   | name               | salary | manager | birthyear | startyear | age  |
+------+--------------------+--------+---------+-----------+-----------+------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |   18 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |    1 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |   30 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |   40 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |   38 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |   32 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |   22 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |   24 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |   49 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |   34 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |   21 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |   20 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |    0 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |   21 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |   21 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |   20 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |   26 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |   21 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |   19 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |   21 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |   23 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |   19 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |   19 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |   24 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |   15 |
+------+--------------------+--------+---------+-----------+-----------+------+
25 rows in set (0.01 sec)
*/

/*
Question 6: List all employees who have a last name ending with “son”.
*/
SELECT * FROM jbemployee WHERE name LIKE '%son';

/*
Empty set (0.01 sec)
*/

/*
Question 7: Which items (note items, not parts) have been delivered by a supplier
called Fisher-Price? Formulate this query by using a subquery in the
WHERE clause.
*/
SELECT * FROM jbitem  WHERE supplier IN (SELECT id FROM jbsupplier WHERE name = "Fisher-Price");

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
+-----+-----------------+------+-------+------+----------+
3 rows in set (0.01 sec)
*/


/*
Question 8: Formulate the same query as above, but without a subquery.  
*/
SELECT * FROM jbitem, jbsupplier WHERE jbitem.supplier = jbsupplier.id AND jbsupplier.name = "Fisher-Price" ;

/*
+-----+-----------------+------+-------+------+----------+----+--------------+------+
| id  | name            | dept | price | qoh  | supplier | id | name         | city |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
|  43 | Maze            |   49 |   325 |  200 |       89 | 89 | Fisher-Price |   21 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 | 89 | Fisher-Price |   21 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 | 89 | Fisher-Price |   21 |
+-----+-----------------+------+-------+------+----------+----+--------------+------+
3 rows in set (0.01 sec)
*/

/*
Question 9: List all cities that have suppliers located in them. Formulate this query
using a subquery in the WHERE clause. 
*/
SELECT * FROM jbcity WHERE id IN (SELECT city FROM jbsupplier);

/*
+-----+----------------+-------+
| id  | name           | state |
+-----+----------------+-------+
|  10 | Amherst        | Mass  |
|  21 | Boston         | Mass  |
| 100 | New York       | NY    |
| 106 | White Plains   | Neb   |
| 118 | Hickville      | Okla  |
| 303 | Atlanta        | Ga    |
| 537 | Madison        | Wisc  |
| 609 | Paxton         | Ill   |
| 752 | Dallas         | Tex   |
| 802 | Denver         | Colo  |
| 841 | Salt Lake City | Utah  |
| 900 | Los Angeles    | Calif |
| 921 | San Diego      | Calif |
| 941 | San Francisco  | Calif |
| 981 | Seattle        | Wash  |
+-----+----------------+-------+
15 rows in set (0.00 sec)
*/



/*
Question 10: What is the name and the color of the parts that are heavier than a card
reader? Formulate this query using a subquery in the WHERE clause.
(The query must not contain the weight of the card reader as a constant;
instead, the weight has to be retrieved within the query.) 
*/
SELECT name, color FROM jbparts WHERE weight > (SELECT weight FROM jbparts WHERE name = 'card reader');

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.01 sec)
*/

/*
Question 11: Formulate the same query as above, but without a subquery. Again, the
query must not contain the weight of the card reader as a constant. 
*/
SELECT p1.name, p1.color FROM jbparts as p1, jbparts as p2 WHERE p1.weight > p2.weight AND p2.name = 'card reader';

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)
*/



/*
Question 12: . What is the average weight of all black parts?
*/
SELECT AVG(weight) FROM jbparts WHERE color = 'black';

/*
+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.01 sec)
*/


/*
Question 13: For every supplier in Massachusetts (“Mass”), retrieve the name and the
total weight of all parts that the supplier has delivered? Do not forget to
take the quantity of delivered parts into account. Note that one row
should be returned for each supplier. 
*/
SELECT supplier.name, SUM(parts.weight * supply.quan), SUM(supply.quan) FROM jbsupplier AS supplier, jbsupply AS supply, jbparts as parts WHERE supplier.city IN (SELECT id FROM jbcity WHERE state = 'MASS') AND supplier.id = supply.supplier AND supply.part = parts.id GROUP BY supplier.name;

/*
+--------------+---------------------------------+------------------+
| name         | SUM(parts.weight * supply.quan) | SUM(supply.quan) |
+--------------+---------------------------------+------------------+
| DEC          |                            3120 |               69 |
| Fisher-Price |                         1135000 |             2000 |
+--------------+---------------------------------+------------------+
2 rows in set (0.01 sec)
*/


/*
Question 14: Create a new relation with the same attributes as the jbitems relation by
using the CREATE TABLE command where you define every attribute
explicitly (i.e., not as a copy of another table). Then, populate this new
relation with all items that cost less than the average price for all items.
Remember to define the primary key and foreign keys in your table! 
*/

/*
Following steps are needed:

(a) Show definition of the jbitem table: */

SHOW CREATE TABLE jbitem;

/*
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table  | Create Table                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| jbitem | CREATE TABLE `jbitem` (
  `id` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `dept` int(11) NOT NULL,
  `price` int(11) DEFAULT NULL,
  `qoh` int(10) unsigned DEFAULT NULL,
  `supplier` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_item_dept` (`dept`),
  KEY `fk_item_supplier` (`supplier`),
  CONSTRAINT `fk_item_dept` FOREIGN KEY (`dept`) REFERENCES `jbdept` (`id`),
  CONSTRAINT `fk_item_supplier` FOREIGN KEY (`supplier`) REFERENCES `jbsupplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 |
+--------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.01 sec)
*/

/* 
(b) Create new table named jbitem2: 
*/
CREATE TABLE jbitem2(id int(11) NOT NULL, name varchar(20) DEFAULT NULL, dept INT(11) NOT NULL, price INT(11) DEFAULT NULL, qoh INT(10) UNSIGNED DEFAULT NULL, supplier INT(11) NOT NULL, PRIMARY KEY (id), KEY fk_item_dept2 (dept), KEY fk_item_supplier2 (supplier), CONSTRAINT fk_item_dept2 FOREIGN KEY (dept) REFERENCES jbdept (id), CONSTRAINT fk_item_supplier2 FOREIGN KEY (supplier) REFERENCES jbsupplier (id));

/*
Query OK, 0 rows affected (0.03 sec)
*/

/*
(c) Insert all rows which satisfies the query:
*/

INSERT INTO jbitem2 (SELECT * FROM jbitem WHERE price < (SELECT AVG(price) FROM jbitem));

/*
Query OK, 14 rows affected (0.02 sec)
Records: 14  Duplicates: 0  Warnings: 0
*/

/*
Question 15: Create a view that contains the items that cost less than the average
price for items. 
*/
CREATE VIEW item_less_view AS SELECT * FROM jbitem WHERE price < (SELECT AVG(price) FROM jbitem);

/*
Query OK, 0 rows affected (0.01 sec)
*/

/*
Question 16: What is the difference between a table and a view? One is static and the
other is dynamic. Which is which and what do we mean by static
respectively dynamic? 
*/

/*
View is dynamic and the table is static. By dynamic we mean that a view can change as the tuples inside a table change.
We define a view upon a table and can be seen as a special query which filters some data (not necessarily) to create one 
layer of abstraction for a specific user.
*/

/*
Question 17: Create a view that calculates the total cost of each debit, by considering
price and quantity of each bought item. (To be used for charging
customer accounts). The view should contain the sale identifier (debit)
and the total cost. In the query that defines the view, capture the join
condition in the WHERE clause (i.e., do not capture the join in the
FROM clause by using keywords inner join, right join or left join).
*/
CREATE VIEW total_cost_view AS SELECT debit, (quantity * price) AS total_cost FROM jbsale, jbitem WHERE item = id;

/*
Query OK, 0 rows affected (0.01 sec)
*/


/*
Question 18: Do the same as in the previous point, but now capture the join conditions
in the FROM clause by using only left, right or inner joins. Hence, the
WHERE clause must not contain any join condition in this case. Motivate
why you use type of join you do (left, right or inner), and why this is the
correct one (in contrast to the other types of joins). 
*/
CREATE VIEW total_cost_view2 AS SELECT debit, quantity * price AS total_cost FROM jbsale LEFT JOIN jbitem ON item = id;

/*
Query OK, 0 rows affected (0.01 sec)
*/

/*
Motivation: We used the LEFT JOIN because we needed the data from the right table to be attached to the left table.
*/



/*
Question 19: Oh no! An earthquake!
a) Remove all suppliers in Los Angeles from the jbsupplier table. This
will not work right away. Instead, you will receive an error with error
code 23000 which you will have to solve by deleting some other related tuples.
However, do not delete more tuples from other tables
than necessary, and do not change the structure of the tables (i.e.,
do not remove foreign keys). Also, you are only allowed to use “Los
Angeles” as a constant in your queries, not “199” or “900”. 

b) Explain what you did and why
*/
/* Part a */
/* Step 1: */
DELETE FROM jbsale WHERE item IN (SELECT id FROM jbitem WHERE supplier IN (SELECT s.id FROM jbsupplier AS s, jbcity AS c WHERE s.city = c.id AND c.name = 'Los Angeles'));

/*
Query OK, 1 row affected (0.01 sec)
*/

/* Step2: */
DELETE FROM jbitem WHERE supplier IN (SELECT s.id FROM jbsupplier AS s, jbcity AS c WHERE s.city = c.id AND c.name = 'Los Angeles');

/*
Query OK, 2 rows affected (0.01 sec)
*/

/* Step3: */
DELETE FROM jbitem2 WHERE supplier IN (SELECT s.id FROM jbsupplier AS s, jbcity AS c WHERE s.city = c.id AND c.name = 'Los Angeles');

/*
Query OK, 1 row affected (0.01 sec)
*/

/* Step 4: */
DELETE FROM jbsupplier WHERE id IN(SELECT s.id FROM jbsupplier AS s, jbcity AS c WHERE s.city = c.id AND c.name = 'Los Angeles');

/*
Query OK, 1 row affected (0.01 sec)
*/

/* Part b */
/*
We need to delete some other tuples in other tables where foreign key is referring to the tuple we want to delete.
In order to delete a supplier we need to delete tuples in jbitem where supplier attribute is the same as 
that particular supplier. In the next step in order to delete those tuples in the jbitem table we need
 to delete tuples (same reason) in jbsale. Lastly we had to do the same for jbitem2 table which we created in question 14.
 */

/*
Question 20: An employee has tried to find out which suppliers have delivered items
that have been sold. To this end, the employee has created a view and
a query that lists the number of items sold from a supplier.

Now, the employee also wants to include the suppliers that have
delivered some items, although for whom no items have been sold so
far. In other words, he wants to list all suppliers that have supplied any
item, as well as the number of these items that have been sold. Help
him! Drop and redefine the jbsale_supply view to also consider suppliers
that have delivered items that have never been sold.
*/

CREATE VIEW jbsale_supply_view (supplier, item, quantity) AS SELECT jbsupplier.name, jbitem.name, jbsale.quantity FROM jbitem LEFT JOIN jbsupplier ON jbsupplier.id = jbitem.supplier LEFT
JOIN jbsale ON jbitem.id = jbsale.item;

/*
Query OK, 0 rows affected (0.01 sec)
*/

SELECT supplier, SUM(quantity) AS sum FROM jbsale_supply_view GROUP BY supplier;

/*
+--------------+------+
| supplier     | sum  |
+--------------+------+
| Cannon       |    6 |
| Fisher-Price | NULL |
| Levi-Strauss |    1 |
| Playskool    |    2 |
| White Stag   |    4 |
| Whitman's    |    2 |
+--------------+------+
6 rows in set (0.01 sec)
*/

