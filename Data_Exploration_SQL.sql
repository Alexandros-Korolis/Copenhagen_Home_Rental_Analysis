select *
from home_data;

-- What are the different property types ?
select distinct("Property type")
from home_data;

-- How many of each property type does it exist in the data ?
select "Property type",count(*)
from home_data
group by "Property type";

-- Whats the average monthly net rent for each property type ? 
select "Property type", round(avg("Monthly net rent"))
from home_data
group by "Property type";

-- Whats the average price for 1 room apartments ?
select round(avg("Monthly net rent"))
from home_data
where "Property type" = 'Apartment'
and "Rooms" = 1;

-- Does properties with balconies tend to be more expensive ? 
select "Balcony",round(avg("Monthly net rent"))
from home_data
group by "Balcony";

-- What is the average/min move in price for a room?
select "Property type",round(avg("Move-in price")) as "average",round(min("Move-in price")) as "minimum"
from home_data
group by "Property type"
having "Property type" = 'Room';

-- Which district has the most student only type of properties ?
select "district",count(*)
from home_data
where "Students only" = 'Yes'
group by "district"
order by count(*) desc;

-- Whats the average size of each type of property and room ?
select "Property type", "Rooms", round(avg("Size(m²)")) as "Average Size"
from home_data
group by "Property type", "Rooms"
order by "Average Size" desc;

-- Which district has the cheapest rent on average ? 
select district, round(avg("Monthly net rent")) as "Average net rent"
from home_data
group by "district"
order by "Average net rent";

-- Which district has the cheapest rent on average ? and what are its characteristics ?
select *
from home_data
where district in 
(select district
from home_data
group by "district"
order by round(avg("Monthly net rent")) asc
limit 1);

-- Which district has the highest rent on average ? and what are its characteristics ?
select *
from home_data
where district in 
(select district
from home_data
group by "district"
order by round(avg("Monthly net rent")) desc
limit 1);

-- How many of the above ones are furnished ?
select count(*)
from home_data
where district in 
(select district
from home_data
group by "district"
order by round(avg("Monthly net rent")) desc
limit 1)
and "Furnished" = 'Yes';

-- How does the rent change, regarding the rooms and floor ?
select "district","Rooms","Floor", round(avg("Monthly net rent")) as "Average rent"
from home_data
group by "district","Rooms","Floor"
order by "Average rent" asc;







