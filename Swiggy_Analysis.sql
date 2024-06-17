select * from swiggy limit 5

/* 1.HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5? */

SELECT COUNT(DISTINCT restaurant_name) AS high_rated_restaurants
FROM swiggy
WHERE rating>4.5;


/* 2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS? */

SELECT 
	city,
    COUNT(DISTINCT restaurant_name) AS no_of_restaurants FROM swiggy
GROUP BY city
ORDER BY no_of_restaurants DESC
LIMIT 1;

/* 3. HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME? */

SELECT 
    COUNT(DISTINCT restaurant_name) AS pizza_restaurants
FROM swiggy 
WHERE restaurant_name REGEXP 'Pizza';

/* 4. WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET? */

SELECT 
    cuisine,
    COUNT(*) AS most_common_cuisine
FROM swiggy
GROUP BY cuisine
ORDER BY most_common_cuisine DESC
LIMIT 1;

/* 5. WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY? */

select city, avg(rating) as average_rating
from swiggy group by city;

/* 6. WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU
CATEGORY FOR EACH RESTAURANT? */

select distinct restaurant_name,menu_category,max(price) as highestprice
from swiggy where menu_category='Recommended'
group by restaurant_name,menu_category;

/* 7. FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN
INDIAN CUISINE. */

select distinct restaurant_name,cost_per_person
from swiggy where cuisine<>'Indian'
order by cost_per_person desc
limit 5;
/* 8. FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE
TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER. */

select distinct restaurant_name,cost_per_person
from swiggy 
where cost_per_person>(select avg(cost_per_person) from swiggy);

/* 9. RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE
LOCATED IN DIFFERENT CITIES. */

select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;

/* 10. WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE'
CATEGORY? */

select distinct restaurant_name,menu_category
,count(item) as no_of_items from swiggy
where menu_category='Main Course' 
group by restaurant_name,menu_category
order by no_of_items desc limit 1;

/* 11. LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN
ALPHABETICAL ORDER OF RESTAURANT NAME */

select distinct restaurant_name,
(count(case when veg_or_nonveg='Veg' then 1 end)*100/count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name;

/* 12. WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS? */

select distinct restaurant_name,avg(price) as average_price
from swiggy 
group by restaurant_name
order by average_price 
limit 1;

/* 13. WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES? */

select distinct restaurant_name,count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc 
limit 5;

/* 14. WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD? */

select distinct restaurant_name,
(count(case when veg_or_nonveg='Non-veg' then 1 end)*100/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc 
limit 1;

/* 15. Determine the Most Expensive and Least Expensive Cities for Dining */

WITH CityExpense AS (
      SELECT City,
          MAX(cost_per_person) AS max_cost,
          MIN(cost_per_person) AS min_cost
	  FROM Swiggy
      GROUP BY City
)
select city,max_cost,min_cost
from cityexpense
order by max_cost desc;

/* 16. Calculate the Rating Rank for Each Restaurant Within Its City? */

WITH RatingRankByCity AS (
       SELECT Distinct
            Restaurant_name,
            City,
            Rating,
            DENSE_RANK() OVER (PARTITION BY CITY ORDER BY RATING DESC) AS RATING_RANK
		FROM SWIGGY
)
SELECT
    Restaurant_name,
	City,
	Rating,  
    Rating_rank
FROM RatingRankByCity
WHERE Rating_rank = 1;




