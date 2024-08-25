-- 1. How much is the average net rent and move-in price per district ?
select district, round(avg("Monthly net rent")) as avg_rent, round(avg("Move-in price")) as avg_move_in_price
from home_data
inner join adress_dim
on home_data.adress_dim_id = adress_dim.adress_dim_id
group by district
order by avg_rent asc;

-- 2. What about one room apartments ? 
select district, round(avg("Monthly net rent")) as avg_rent, round(avg("Move-in price")) as avg_move_in_price
from home_data
inner join adress_dim
on home_data.adress_dim_id = adress_dim.adress_dim_id
inner join property_feat_dim
on home_data.property_feat_dim_id = property_feat_dim.property_feat_dim_id
where property_feat_dim."Property type" = 'Apartment'
and property_feat_dim.rooms = '1'
group by district
order by avg_rent asc;

-- 3. Whats the average net rent per type of property and number of rooms ? 
select "Property type",rooms,round(avg("Monthly net rent")) as prop_room_avg
from home_data
inner join property_feat_dim
on home_data.property_feat_dim_id = property_feat_dim.property_feat_dim_id
group by "Property type",rooms
order by prop_room_avg;

-- 4. Does floor has an effect on monthly net rent on average for one room apartments ?
select floor, round(avg("Monthly net rent")) as floor_avg
from home_data
inner join adress_dim
on home_data.adress_dim_id = adress_dim.adress_dim_id
inner join property_feat_dim
on home_data.property_feat_dim_id = property_feat_dim.property_feat_dim_id
where "Property type" = 'Apartment'
and rooms = '1'
group by floor
order by floor_avg desc;

-- 5. What percentage of the total number of properties per district are students only ? 
-- Which district has the hightest percentage of student only type of properties ?
with properties_per_district as (
select district, count(*) as count_per_distr from adress_dim
inner join home_data
on home_data.adress_dim_id = adress_dim.adress_dim_id
group by district
)
select adress_dim.district, count(*) as nr_students_only, properties_per_district.count_per_distr,
(cast(count(*) as decimal)/count_per_distr)*100 as percentage
from properties_per_district
inner join adress_dim
on adress_dim.district = properties_per_district.district
inner join home_data
on home_data.adress_dim_id = adress_dim.adress_dim_id
inner join property_feat_dim
on property_feat_dim.property_feat_dim_id = home_data.property_feat_dim_id
where property_feat_dim."Students only" = 'Yes'
group by adress_dim.district, properties_per_district.count_per_distr
order by percentage DESC; 

-- 6. In which district is more likely to find a house (any type) with a balcony ?
with properties_per_district as (
select district, count(*) as count_per_distr 
from adress_dim
inner join home_data
on home_data.adress_dim_id = adress_dim.adress_dim_id
group by district
)

select adress_dim.district, count(*) as nr_of_balconies, count_per_distr,
(cast(count(*) as decimal)/count_per_distr)*100 as pos
from extra_utilities_dim
inner join home_data
on extra_utilities_dim.extra_utilities_dim_id = home_data.extra_utilities_dim_id
inner join adress_dim
on home_data.adress_dim_id = adress_dim.adress_dim_id
inner join properties_per_district
on properties_per_district.district = adress_dim.district
where balcony = 'Yes'
group by adress_dim.district, count_per_distr
order by nr_of_balconies desc;

-- 7. Which is the most pet friendly district ?
with nr_ap_per_distr as (
select district, count(*) as count_per_distr 
from adress_dim
inner join home_data
on home_data.adress_dim_id = adress_dim.adress_dim_id
group by district
)

select adress_dim.district, count(*) as nr_pet_friendly,
(cast(count(*) as decimal)/count_per_distr)*100 as percentage
from property_feat_dim
inner join home_data
on home_data.property_feat_dim_id = property_feat_dim.property_feat_dim_id
inner join adress_dim 
on adress_dim.adress_dim_id = home_data.adress_dim_id
inner join nr_ap_per_distr
on nr_ap_per_distr.district = adress_dim.district
where property_feat_dim."Pets allowed" = 'Yes'
group by adress_dim.district,count_per_distr
order by percentage desc;

-- 8. What is the most common rental period per type of apartment ?
select "Property type", rooms, "Rental period", count(*)
from time_dim
inner join home_data
on home_data.time_dim_id = time_dim.time_dim_id
inner join property_feat_dim
on property_feat_dim.property_feat_dim_id = home_data.property_feat_dim_id
group by "Property type",rooms, "Rental period"
order by count(*) desc;

-- 9. Which are the top 5 Senior Friendly street ?
select adress_dim.street, count(*) as nr_friendly
from adress_dim
inner join home_data
on adress_dim.adress_dim_id = home_data.adress_dim_id
inner join property_feat_dim
on property_feat_dim.property_feat_dim_id = home_data.property_feat_dim_id
where "Senior friendly" = 'Yes'
group by adress_dim.street
order by nr_friendly desc
limit 5;
















