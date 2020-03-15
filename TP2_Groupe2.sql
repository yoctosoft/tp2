--TCH055-01
--Groupe 2 (Lab)
--TP2
--Membres:
--Chatigny-Salit, Jacob
--Grib, Nadir
--Pham, Glen
--Regis, Herby
--Trepanier, Simon

--Section 1
--1.1
SELECT country_name FROM countries;

--1.2
SELECT product_name FROM products
WHERE list_price > 1.4*standard_cost;

--1.3
SELECT name FROM customers
WHERE address LIKE '%IN'
AND credit_limit > 150;

--1.4
SELECT first_name||' '||last_name AS "Nom Complet" FROM contacts
WHERE phone LIKE '+49 %';

--1.5
SELECT DISTINCT SUBSTR(address,-2,2) FROM customers
WHERE address LIKE '%, __';

--Section 2
--2.1
SELECT product_name FROM products
INNER JOIN product_categories ON products.category_id = product_categories.category_id
WHERE category_name = 'Mother Board';

--2.2
SELECT warehouse_name from warehouses
INNER JOIN locations on warehouses.location_id = locations.location_id
INNER JOIN countries on locations.country_id = countries.country_id
INNER JOIN regions on countries.region_id = regions.region_id
WHERE region_name = 'Asia';

--2.3
SELECT DISTINCT employee_id FROM employees
INNER JOIN orders ON employees.employee_id = orders.salesman_id
WHERE orders.status='Shipped'
AND orders.order_date <= ADD_MONTHS(employees.hire_date,3)
AND orders.order_date >= employees.hire_date;

--2.4
--Question pas clair
--Selon l'enonce la requete doit donner une liste:
SELECT item_id,product_id,quantity FROM order_items
INNER JOIN orders on order_items.order_id = orders.order_id
WHERE orders.order_date >= DATE '2017-01-01'
AND orders.order_date <= DATE '2017-12-31';
--Voici une interpretation alternative qui donne simplement la somme totale des produits commandes
SELECT SUM(quantity)
FROM order_items
INNER JOIN orders
ON order_items.order_id = orders.order_id
WHERE orders.order_date >= DATE '2017-01-01'
AND orders.order_date <= DATE '2017-12-31';

--2.5
SELECT last_name||', '||first_name||' id :'||employee_id||' date embauche:'||hire_date
AS "Infos employes" FROM employees
WHERE hire_date >= DATE '2017-01-01';

--Section 3
--3.1
SELECT employee_id FROM employees
LEFT JOIN orders ON employees.employee_id = orders.salesman_id
WHERE salesman_id IS NULL;

--3.2
SELECT DISTINCT region_name FROM regions
WHERE region_name NOT IN
    (SELECT DISTINCT region_name FROM regions
    INNER JOIN countries ON regions.region_id = countries.region_id
    INNER JOIN locations ON countries.country_id = locations.country_id
    INNER JOIN warehouses ON locations.location_id = warehouses.location_id);

--3.3
SELECT customers.customer_id, name, address
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
WHERE customers.customer_id NOT IN (SELECT customer_id FROM orders);

--3.4
SELECT address FROM customers
UNION
SELECT address || state || ' ' || postal_code AS new_address
FROM locations
ORDER BY address;

--3.5
SELECT name, 'CUSTOMERS' AS type_pers
FROM customers
UNION ALL
SELECT first_name || last_name AS name, 'EMPLOYEES' AS type_pers
FROM employees
ORDER BY name;

--Section 4
--4.1
SELECT COUNT(product_name)
FROM products
WHERE product_name LIKE '%i7%';

--4.2
--Pas reussi
--SUBSTR() ???, INSTR() ???
SELECT phone, COUNT(*) as "COUNT"
FROM contacts
--WHERE phone LIKE '+% % %'
GROUP BY phone;

--4.3
SELECT regions.region_name, COUNT(DISTINCT country_name)
from countries
INNER JOIN regions on regions.region_id = countries.region_id
group by regions.region_name;

--4.4
SELECT product_id, product_name, list_price
FROM products
WHERE list_price >= (SELECT AVG(list_price) FROM products);

--4.5
--Je ne sais pas vraiment si c'est la bonne reponse
SELECT distinct employee_id
FROM employees
INNER JOIN orders
ON employees.employee_id=orders.salesman_id
INNER JOIN order_items 
ON orders.order_id=order_items.order_id
WHERE order_items.quantity > (SELECT AVG(quantity) FROM order_items);

--section 5
--5.1
SELECT distinct last_name || ','  || first_name  AS "Nom complet"
FROM employees
WHERE employee_id IN (SELECT DISTINCT manager_id from employees);

--5.2
--Pas reussi
SELECT employee_id
FROM employees
INNER JOIN orders ON employees.employee_id = orders.salesman_id
INNER JOIN order_items ON orders.order_id = order_items.order_id
--WHERE SUM
;

--5.3
SELECT product_name FROM products
WHERE product_name NOT IN
    (SELECT product_name FROM products
    INNER JOIN order_items ON products.product_id = order_items.product_id);

--5.4
--pas reussi
SELECT count(CATEGORY_ID) as nb
, CATEGORY_ID
, WAREHOUSE_ID
FROM ORDER_ITEMS
INNER JOIN PRODUCTS P on ORDER_ITEMS.PRODUCT_ID = P.PRODUCT_ID
INNER JOIN INVENTORIES I on P.PRODUCT_ID = I.PRODUCT_ID
GROUP BY CATEGORY_ID, WAREHOUSE_ID
order by count(CATEGORY_ID) desc;
