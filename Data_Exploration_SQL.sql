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

-- Choose the apartments that are more expensive (monthly rent) than the average monthly
-- rent. Calculate the average monthly net rent per nr of rooms.
select "Rooms",round(avg("Monthly net rent"))
from home_data
where "Property type" = 'Apartment'
and "Monthly net rent" >= 
(select round(avg("Monthly net rent"))
from home_data
group by "Property type"
having "Property type" = 'Apartment')
group by "Rooms"
order by "Rooms" asc;

-- Those that have higher net rent have on average higher Size (m2).
select round(avg("Size(m²)"))
from home_data
where "Property type" = 'Apartment'
and "Monthly net rent" < 
(select round(avg("Monthly net rent"))
from home_data
group by "Property type"
having "Property type" = 'Apartment');

select round(avg("Size(m²)"))
from home_data
where "Property type" = 'Apartment'
and "Monthly net rent" >= 
(select round(avg("Monthly net rent"))
from home_data
group by "Property type"
having "Property type" = 'Apartment');

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

-- How much money does student houses cost ? 
select "Rooms", round(avg("Monthly net rent")) as "Average Monthly net rent"
from home_data
where "Students only" = 'Yes'
group by "Rooms";

select "Rooms", round(avg("Deposit")) as "Average Deposit"
from home_data
where "Students only" = 'Yes'
group by "Rooms";

select "Rooms", round(avg("Move-in price")) as "Average Move-in price"
from home_data
where "Students only" = 'Yes'
group by "Rooms";

-- Which areas are more economically for students (top 20), CPH + Surroundings?
select "district", round(avg("Monthly net rent")) as "Avg Rent"
from home_data
where "Monthly net rent" < 
(select round(avg("Monthly net rent")) as "Average Monthly net rent"
from home_data
where "Students only" = 'Yes')
group by "district"
order by "Avg Rent" asc
limit 20;

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

-- What are the characteristics of the most expensive districs in Cph and surroundings?
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

-- Lets check only the top Copehnagen districts ('Vanløse', 'Brønshøj-Husum', 'Amager Øst', 'Valby', 'Amager Vest',
-- 'Bispebjerg', 'Østerbro', 'Nørrebro', 'Indre By',
-- 'Vesterbro-Kongens Enghave')

select a."Property type", a."Rooms",a."Floor",a."Students only",a."Senior friendly",a."Furnished",a."Balcony",
		a."Available from",a."Monthly net rent",a."Utilities",a."Deposit",
		a."Prepaid rent",a."Move-in price",a."Creation Date",a."district"
from home_data as a
inner join bydel as b
on a."district" = b."navn";

-- Lets create a view of the above table, so I can reuse it later.
CREATE VIEW top_cph_districts AS 
select a."Property type", a."Rooms",a."Floor",a."Students only",a."Senior friendly",a."Furnished",a."Balcony",
		a."Available from",a."Monthly net rent",a."Utilities",a."Deposit",
		a."Prepaid rent",a."Move-in price",a."Creation Date",a."district"
from home_data as a
inner join bydel as b
on a."district" = b."navn";

-- Lets get an overview of net rent per district, for one room. Using the view from above.
select "district","Rooms",round(avg("Monthly net rent")) as "Monthy net rent"
from top_cph_districts
where "Property type" like 'Room'
and "Rooms" = 1
group by "district","Rooms"
order by "Monthy net rent" asc;

-- What about apartments and any nr of rooms. Only in cph top districts.
select "district","Rooms",round(avg("Monthly net rent")) as "Monthly net rent"
from top_cph_districts
where "Property type" like 'Apartment'
group by "district","Rooms"
order by "Monthly net rent" asc;

-- whats the average availability time(in days) per district  ?
select "district",round(avg("Available from"-"Creation Date")) as "time"
from top_cph_districts
group by "district"
order by "time" asc;

-- whats the average availability time(in days) per property type  ?
select "Property type",round(avg("Available from"-"Creation Date")) as "time"
from top_cph_districts
group by "Property type"
order by "time" asc;

-- Which areas are more economically for students (top 3)?
select "district", round(avg("Monthly net rent")) as "Avg Rent"
from top_cph_districts
where "Monthly net rent" < 
(select round(avg("Monthly net rent")) as "Average Monthly net rent"
from home_data
where "Students only" = 'Yes')
group by "district"
order by "Avg Rent" asc
limit 3;

-- Export view table top_kbh_districts to csv
copy (select * from top_cph_districts) to 'D:\top_kbh_districs.csv'
delimiter ','
csv header;




