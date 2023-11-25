drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-- Q1.what is the total amount that each customer spent on zomato 
-- A1 (user 1 with 5230rs), (user 2 with 2510rs), (user 3 with 4750rs)
SELECT cus_spending.userid,  SUM(cus_spending.price) AS spending
FROM (SELECT s.*, p.price
FROM sales AS s
JOIN product AS p
ON s.product_id = p.product_id) AS cus_spending
GROUP BY cus_spending.userid;


-- Q2.how many days each customers visit zomato
-- A2 user 1 visited 7days, user 2 visited 4 days, user 3 visited 5 days

SELECT userid, COUNT( DISTINCT(created_date)) AS days_visited
FROM sales
GROUP BY userid;

-- Q3.what was the first product purchased by each customer
-- A3. all the three customer purchased the first product 

SELECT po.userid, po.product_id
FROM (SELECT *, RANK() OVER(PARTITION BY userid ORDER BY created_date) AS rnk
FROM sales) AS po
WHERE po.rnk = 1;



-- Q4. what is the most purchased item on the menu and how many times was it purchased by all customers ?
-- A5. The most purchased item is product 2, user1 purchased it for 3 times and user2 for 1 and user3 for 3 times

SELECT userid ,product_id, COUNT(product_id) AS purchased
FROM sales
WHERE product_id = (SELECT product_id
FROM sales 
GROUP BY product_id
ORDER BY COUNT(product_id) DESC
LIMIT 1)
GROUP BY userid,product_id;


-- Q5. which is the most favourite item for each customer?
-- A5. user1 fav item is product2 and for user2 it is product3 and for user3 its product2

SELECT c.userid, c.product_id
FROM (
SELECT userid, product_id, RANK() OVER(PARTITION BY userid ORDER BY (COUNT(product_id)) DESC) AS rnk
FROM sales
GROUP BY userid,product_id) AS c
WHERE rnk = 1;

-- Q6. what item was first purchased by the customer?
-- A6. all the user purchased product1 as their first purchase

SELECT po.userid, po.product_name
FROM (SELECT s.*, p.product_name, RANK() OVER(PARTITION BY userid ORDER BY created_date) AS rnk
FROM sales AS s
JOIN product AS p
ON s.product_id = p.product_id) AS po
WHERE po.rnk = 1;

-- Q7. what item was purchased first by the customer after premium member
-- A7. user1 and 3 are premium members and they purchased p3 for 330rs and p2 for 870 respectievely after they became premium members

WITH pl AS(
SELECT s.userid, gs.gold_signup_date, s.created_date,s.product_id,p.product_name, p.price
, RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date) AS rnk
FROM goldusers_signup AS gs
JOIN sales AS s
JOIN product AS p
ON s.userid = gs.userid
AND s.created_date >= gs.gold_signup_date
AND p.product_id = s.product_id)

SELECT pl.userid, pl.product_name ,pl.price
FROM pl
WHERE pl.rnk = 1;


-- Q8. which item was purchased just before the customer became a premium member?
-- A8. user1 and user3 pruchased product 2 before the

WITH pd AS 
(SELECT s.userid, gs.gold_signup_date, s.created_date,p.product_id,p.product_name
, RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date DESC) AS rnk
FROM goldusers_signup AS gs
JOIN sales AS s
JOIN product AS p 
ON s.userid = gs.userid
AND gs.gold_signup_date >= s.created_date
AND s.product_id = p.product_id)

SELECT pd.userid, pd.product_id,Pd.product_name
FROM pd
WHERE pd.rnk = 1;

-- Q.9. what is the total orders and amount spent for each member before they became a premium member?
-- A.9. (user 1 with 5 purchases and 4030rs spent) , (user 2 with 3 purchases and 2720rs spent)

WITH pd AS
(SELECT gs.userid,gs.gold_signup_date,s.created_date,p.product_id, p.product_name,p.price
FROM goldusers_signup AS gs
JOIN sales AS s
JOIN product AS p
ON gs.userid = s.userid
AND gs.gold_signup_date > s.created_date
AND s.product_id = p.product_id)

SELECT pd.userid, COUNT(pd.product_name) AS total_purchased , SUM(pd.price) AS amount_spent
FROM pd
GROUP BY pd.userid
ORDER BY pd.userid;

/*if buying each product generates points for eg 5rs=2 zomato points and each product has different purchasing points for
eg for product 1  5rs = 1 zomato points, for product 2 10 rs =5 zomato points and p3 5 rs = 1 zomatio points   */

-- 10. calculate the points collected by each customers and for which product most points have been given till now
-- Q.a) points collected by each customers and their cashback
-- A10.10a) (user 1 with 1829 points and 4572.5 rs) ,(user 2 with 1697 points and 4242.5rs) ,(user 3 with 763 points and 1907.5 rs)

WITH pd AS(
SELECT cal.*, ROUND(cal.price/cal.product_points) AS points
FROM(
SELECT s.userid,s.created_date,s.product_id,p.product_name,p.price,
(CASE WHEN p.product_id = 1 THEN 5
WHEN p.product_id = 2 THEN 2
WHEN p.product_id = 3 THEN 5
ELSE 0
END) AS product_points
FROM sales AS s
JOIN product AS p
ON s.product_id =  p.product_id) AS cal)

SELECT pd.userid, SUM(pd.points) AS total_points, SUM(pd.points)*2.5 AS cashback
FROM pd
GROUP BY pd.userid;

-- Q10.b) which product has given most points
-- A10.b) Product 2 with total points 3045
WITH cal AS (
SELECT points.*, ROUND(points.price/points.rs_to_get_points) AS points
FROM (SELECT s.userid, s.product_id,p.product_name, p.price,
(CASE WHEN p.product_id = 1 THEN 5
WHEN p.product_id = 2 THEN 2
WHEN p.product_id = 3 THEN 5
ELSE 0
END) AS rs_to_get_points
FROM sales AS s
JOIN product AS p
ON s.product_id = p.product_id) AS points)

SELECT cal.product_id, SUM(cal.points) AS total_points
FROM cal
GROUP BY cal.product_id
ORDER BY total_points DESC
LIMIT 1;


/* Q11.  IN THE FIRST ONE YEAR AFTER A CUSTOMER JOINS THE GOLD PROGRAM (INCLUDING THEIR JOIN DATE) IRRESPECTIVE
OF WHAT THE CUSTOMER PURCHASED THEY EARN 5 ZOMATO POINTS FOR EVERY 10RS SPENT WHO EARNED MORE 1 OR 3 AND WHAT WAS 
THEIR POINTS EARNING IN THERI FIRST YEAR? , 1 ZOMATO POINTS = 2 RS -- THEN 0.5 ZOMATO POINTS = 1RS
*/

SELECT s.userid, gs.gold_signup_date, s.created_date,s.product_id,p.product_name, p.price
, p.price*0.5 AS points
FROM goldusers_signup AS gs
JOIN sales AS s
JOIN product AS p
ON s.userid = gs.userid
AND s.created_date >= gs.gold_signup_date
AND s.created_date<= DATE_ADD(gs.gold_signup_date, INTERVAL 1 YEAR)
AND p.product_id = s.product_id
ORDER BY points DESC;

-- Q12. RANK ALL THE TRASACTIONS OF THE CUSTOMERS

SELECT s.userid,s.created_date,p.product_id,p.price,p.product_name, RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date) AS rnk
FROM sales AS s
JOIN product AS p
ON s.product_id = p.product_id;


-- Q13.RANK ALL THE TRANSACTIONS FOR EACH MEMBER WHENEVER THEY ARE A ZOMATO GOLD MEMBER FOR EVERY NON GOLD MEMBER TRANSACTION MARK AS NA
WITH ms AS(
SELECT s.userid, s.created_date, s.product_id,p.price,p.product_name
, (CASE WHEN s.userid = gs.userid AND s.created_date >= gs.gold_signup_date THEN "YES"
	ELSE "NO"
    END) AS gold_member
FROM sales AS s
LEFT JOIN goldusers_signup AS gs ON s.userid = gs.userid
LEFT JOIN product AS p ON p.product_id = s.product_id
)

SELECT ms.userid, ms.created_date, ms.product_id,ms.price, ms.product_name
, (CASE WHEN ms.gold_member = "YES" THEN RANK() OVER(PARTITION BY ms.userid ORDER BY ms.created_date DESC)
	ELSE "NA"
    END) AS rnk
FROM ms
