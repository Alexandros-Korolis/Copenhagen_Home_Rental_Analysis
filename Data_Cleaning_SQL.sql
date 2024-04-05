-- Have a look at our data
select *
from home_data;

-- Replace m² with space
Update home_data
Set "Size" = replace("Size",'m²','');

-- Rename Size column to Size(m²)
alter table home_data 
rename column "Size" TO "Size(m²)";

-- Chamge Size(m²) to float
alter table home_data 
alter column "Size(m²)" type float
USING ("Size(m²)"::float);

-- Change data type of rooms column.
update home_data
set "Rooms" = substring("Rooms" from 1 for position('.' in "Rooms")-1);

alter table home_data
alter column "Rooms" type INTEGER using "Rooms"::integer;

-- Change data type of floor column
UPDATE home_data
set "Floor" = replace(replace(replace("Floor",'Ground floor','0'),'-','0'),'Basement','-1');

UPDATE home_data
set "Floor" = replace(replace(replace(replace("Floor",'th',''),'rd',''),'st',''),'nd','');

alter table home_data
alter column "Floor" type integer using "Floor"::integer;

-- Change data type of monthly net rent to integer.
update home_data
set "Monthly net rent" = trim(replace(replace("Monthly net rent",'.',''),'kr',''),'');

update home_data
set "Monthly net rent" = trim(split_part("Monthly net rent",',',1));

alter table home_data
alter column "Monthly net rent" type integer using "Monthly net rent"::integer;

-- Change data type of Utilities column.
update home_data
set "Utilities" = trim(replace(replace("Utilities",'.',''),'kr',''),'');

update home_data
set "Utilities" = trim(split_part("Utilities",',',1));

alter table home_data
alter column "Utilities" type integer using "Utilities"::integer;

-- Change data type of Deposit column.
update home_data
set "Deposit" = trim(replace(replace("Deposit",'.',''),'kr',''),'');

update home_data
set "Deposit" = trim(split_part("Deposit",',',1));

alter table home_data
alter column "Deposit" type integer using "Deposit"::integer;

-- Change data type of Prepaid rent column.
update home_data
set "Prepaid rent" = trim(replace(replace("Prepaid rent",'.',''),'kr',''),'');

update home_data
set "Prepaid rent" = trim(split_part("Prepaid rent",',',1));

alter table home_data
alter column "Prepaid rent" type integer using "Prepaid rent"::integer;

-- Change data type of Move-in price.
update home_data
set "Move-in price" = trim(replace(replace("Move-in price",'.',''),'kr',''),'');

update home_data
set "Move-in price" = trim(split_part("Move-in price",',',1));

alter table home_data
alter column "Move-in price" type integer using "Move-in price"::integer;

-- Create a column named District, that contains the district that the house belongs.
alter table home_data
add column District varchar(255);

update home_data
set District = trim(split_part(split_part("Adress",',',3),'-',1));

-- Change Available from to date.
update home_data
set "Available from" = replace("Available from",'As soon as possible','3 April 2014');

update home_data
set "Available from" = to_date("Available from",'DD Month YYYY')

alter table home_data 
alter column "Available from" type DATE 
using to_date("Available from", 'YYYY-MM-DD');

-- Change Creation Date column type and values to date.
update home_data
set "Creation Date" = to_date("Creation Date",'DD MM YYYY');

alter table home_data 
alter column "Creation Date" type DATE 
using to_date("Creation Date", 'YYYY-MM-DD');

-- Export to csv 
copy home_data to 'D:\clean_data_db.csv'
delimiter ','
csv header;
