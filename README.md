# Zomato Data Analysis Project

## Overview
This project involves the analysis of a simulated dataset representing user signups, transactions, and product details for a fictional food delivery platform, Zomato. The dataset includes information about user signups, purchases, product details, and the Zomato Gold membership program.

## Data Schema
The project includes the following tables:

goldusers_signup: Contains information about users who have signed up for the Zomato Gold membership, including user ID and the signup date.

users: Represents general user signups, including user ID and signup date.

sales: Records transactions made by users, including user ID, transaction date, and product ID.

product: Provides details about the products available on Zomato, including product ID, product name, and price.

## Key Questions Explored
1.Total Spending by Each Customer on Zomato:
  Identified the total amount spent by each customer on Zomato.
  
2.Number of Days Each Customer Visited Zomato:
  Determined the number of days each customer visited Zomato.
  
3.First Product Purchased by Each Customer:
  Found the first product purchased by each customer.
  
4.Most Purchased Item and Frequency:
  Identified the most purchased item and the number of times it was bought by all customers.
  
5.Most Favored Item for Each Customer:
  Determined the most favored item for each customer.
  
6.First Item Purchased by Each Customer:
  Identified the first item purchased by each customer.
  
7.Item Purchased Just Before Becoming a Premium Member:
  Found the item purchased just before a customer became a premium member.
  
8.Total Orders and Amount Spent Before Becoming a Premium Member:
  Calculated the total orders and amount spent by each member before becoming a premium member.
  
9.Points Collected by Customers and Most Rewarding Product:
  Calculated the points collected by each customer and identified the product that generated the most points.
  
10.Points Earned in the First Year of Gold Membership:
  Determined the points earned by customers in the first year of joining the Zomato Gold program.
  
11.Ranking of All Transactions:
  Ranked all transactions for each customer.
  
12.Ranking Transactions During Zomato Gold Membership:
  Ranked all transactions for each customer, marking non-gold member transactions as "NA."

13.Calculate the recency of each customer's last purchase:
  Returns user ID and the number of days since the last purchase for each customer.

14.Determine the frequency of purchases for each customer:
  Returns user ID and the count of distinct purchase dates for each customer.

15.Assess the monetary value of each customer's transactions:
  Returns user ID and the total amount spent by each customer.

  
## Usage
To reproduce the analysis or explore the dataset further, you can use the provided SQL queries and adapt them to your database system. Simply execute the queries in the specified order to obtain the desired insights.
