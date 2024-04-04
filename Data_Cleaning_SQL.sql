-- Have a look at our data
select *
from home_data;

-- Replace m² with space
Update home_data
Set "Size" = replace("Size",'m²','');

-- Rename Size column to Size(m²)
ALTER TABLE home_data 
RENAME COLUMN "Size" TO "Size(m²)";

-- Chamge Size(m²) to float
ALTER TABLE home_data 
ALTER COLUMN "Size(m²)" TYPE FLOAT
USING ("Size(m²)"::FLOAT);

-- Change data type of rooms column.
UPDATE home_data
set "Rooms" = substring("Rooms" from 1 for position('.' in "Rooms")-1);

ALTER TABLE home_data
ALTER COLUMN "Rooms" TYPE INTEGER USING "Rooms"::integer;

-- Change data type of floor column
UPDATE home_data
set "Floor" = replace(replace(replace("Floor",'Ground floor','0'),'-','0'),'Basement','-1');

UPDATE home_data
set "Floor" = replace(replace(replace(replace("Floor",'th',''),'rd',''),'st',''),'nd','');

alter table home_data
alter column "Floor" type integer using "Floor"::integer;

-- Change data type of monthly net rent to integer.
update home_data
set "Monthly net rent" = trim(replace(replace(replace("Monthly net rent",'.',''),'kr',''),',',''));

alter table home_data
alter column "Monthly net rent" type integer using "Monthly net rent"::integer;

-- Change data type of Utilities column.
update home_data
set "Utilities" = trim(replace(replace(replace("Utilities",'.',''),'kr',''),',',''));

alter table home_data
alter column "Utilities" type integer using "Utilities"::integer;

-- Change data type of Deposit column.
update home_data
set "Deposit" = trim(replace(replace(replace("Deposit",'.',''),'kr',''),',',''));

alter table home_data
alter column "Deposit" type integer using "Deposit"::integer;

-- Change data type of Prepaid rent column.
update home_data
set "Prepaid rent" = trim(replace(replace(replace("Prepaid rent",'.',''),'kr',''),',',''));

alter table home_data
alter column "Prepaid rent" type integer using "Prepaid rent"::integer;

-- Change data type of Move-in price.
update home_data
set "Move-in price" = trim(replace(replace(replace("Move-in price",'.',''),'kr',''),',',''));

alter table home_data
alter column "Move-in price" type integer using "Move-in price"::integer;

-- Create a column named District, that contains the district that the house belongs.
alter table home_data
add column District varchar(255);

update home_data
set District = trim(split_part(split_part("Adress",',',3),'-',1));

-- Export to csv 
COPY home_data TO 'D:\clean_data_db.csv'
DELIMITER ','
CSV HEADER;
