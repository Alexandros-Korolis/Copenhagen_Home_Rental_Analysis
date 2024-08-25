-- Have a look at the first 5 rows of ads_data
select *
from ads_data
limit 5;

-- Split adress column to street,post code, district
alter table ads_data
add column street varchar(220);

update ads_data
set street = trim(replace(substring(adress,1,position(',' in adress)),',',''));

alter table ads_data
add column post_code varchar(220);

update ads_data
set post_code = trim(replace(substring(adress,position(',' in adress),6),',',''));

alter table ads_data
add column district varchar(220);

update ads_data
set district = trim(split_part(split_part(adress,',',3),'-',1));

-- Change values of Amager side (amager_sides table), east -> Amager Øst, vest -> Amager Vest
update amager_sides
set "Amager side" = replace("Amager side",'east','Amager Øst');

update amager_sides
set "Amager side" = replace("Amager side",'vest','Amager Vest');

-- Replace the district of Amager area according to whether it belong east or west:
update ads_data as b
set district = a."Amager side"
from amager_sides as a
where b."street" = a."Amager adress";

update ads_data
set "district" = replace("district",'København S','Amager Vest');

-- Replace district column with the district names found on bydel table
-- København Ø -> Østerbro, København NV ->Bispebjerg, København K->Indre By,København V ->Vesterbro-Kongens Enghave
-- København N -> Nørrebro, Brønshøj->Brønshøj-Husum,
update ads_data
set "district" = replace(replace("district",'København Ø','Østerbro'),'København NV','Bispebjerg');

update ads_data
set "district" = replace(replace("district",'København K','Indre By'),'København V','Vesterbro-Kongens Enghave');

update ads_data
set "district" = replace(replace("district",'København N','Nørrebro'),'Brønshøj','Brønshøj-Husum');

update ads_data
set "district" = replace("district",'Amager VestV','Vesterbro-Kongens Enghave');

-- I need only the ads_data within the 10 districts found in bydel (top 10 CPH districts)
create table home_data as
select *
from ads_data
inner join bydel
on ads_data.district = bydel.navn;

-- Drop old table
drop table ads_data;

-- Drop unnessecery columns
alter table home_data
drop column navn;

alter table home_data
drop column areal_m2;

alter table home_data
drop column wkb_geometry;

-- Replace floor column values to appropriate ones
update home_data
set floor = trim(replace(replace(replace(replace(replace(replace(replace(floor,'th',''),'st',''),'nd',''),'rd',''),'-','0'),'Grou floor','0'),'Basement','-1'));

-- Change rooms datatype 
alter table home_data
alter column rooms type varchar(15);

update home_data
set rooms = trim(replace(rooms,'.0',''));

-- Remove m2 from size column and change datatype to integer
Update home_data
Set size = trim(replace(size,'m²',''));

alter table home_data
alter column size type Float using size::float;

-- Replace not specified values with no, Pets allowed column, home_data table
update home_data
set "Pets allowed" = trim(replace("Pets allowed",'Not specified','No'));

-- Replace not specified values with no, Senior friendly column, home_data table
update home_data
set "Senior friendly" = trim(replace("Senior friendly",'Not specified','No'));

-- Replace not specified values with no, Students only column, home_data table
update home_data
set "Students only" = trim(replace("Students only",'Not specified','No'));

-- Create table property_feat_dim consisting of 
-- property_feat_dim_id,"Property type",rooms,furnished,shareable,"Pets allowed",
-- "Senior friendly","Students only" columns from home_data table. property_feat_dim_id is
-- unique key for property_feat_dim table and foreign key for the home_data column.

alter table home_data
add column property_feat_dim_id varchar(250);

update home_data
set property_feat_dim_id = concat("Property type",'_',rooms,'_',furnished,'_',shareable,'_',"Pets allowed",'_',
			"Senior friendly",'_',"Students only");
			
create table property_feat_dim as
select distinct property_feat_dim_id,"Property type",rooms,furnished,shareable,"Pets allowed",
			"Senior friendly","Students only"
from home_data;

alter table property_feat_dim 
add constraint PK_property_feat_dim PRIMARY KEY (property_feat_dim_id);

alter table home_data 
add constraint FK_property_feat_dim 
foreign key (property_feat_dim_id) references property_feat_dim (property_feat_dim_id);  

alter table home_data
drop column "Property type";

alter table home_data
drop column rooms;

alter table home_data
drop column furnished;

alter table home_data
drop column shareable;

alter table home_data
drop column "Pets allowed";

alter table home_data
drop column "Senior friendly";

alter table home_data
drop column "Students only";

-- Replace 'not specified' value in the columns elevator, balcony, parking, dishwasher,
-- washing machine, electric charging station, dryer with mode value of each column.
select elevator, balcony, parking, dishwasher, "Washing machine","Electric charging station",
	dryer
from home_data;

update home_data
set balcony = trim(replace(balcony,'Not specified','Yes'));

update home_data
set elevator = trim(replace(elevator,'Not specified','Yes'));

update home_data
set parking = trim(replace(parking,'Not specified','No'));

update home_data
set dishwasher = trim(replace(dishwasher,'Not specified','Yes'));

update home_data
set "Washing machine" = trim(replace("Washing machine",'Not specified','Yes'));

update home_data
set "Electric charging station" = trim(replace("Electric charging station",'Not specified','No'));

update home_data
set dryer = trim(replace(dryer,'Not specified','Yes'));

-- Create extra_utilities_dim table, establish 1:many relationship with home_data table.
alter table home_data
add column extra_utilities_dim_id varchar(250);

update home_data
set extra_utilities_dim_id = concat(elevator,'_',balcony,'_',parking,'_',dishwasher,'_',"Washing machine",'_',"Electric charging station",
	'_',dryer);

create table extra_utilities_dim as
select distinct extra_utilities_dim_id,elevator, balcony, parking, dishwasher, "Washing machine","Electric charging station",
	dryer
from home_data;

alter table extra_utilities_dim 
add constraint PK_extra_utilities_dim PRIMARY KEY (extra_utilities_dim_id);

alter table home_data 
add constraint FK_extra_utilities_dim 
foreign key (extra_utilities_dim_id) references extra_utilities_dim (extra_utilities_dim_id);

alter table home_data
drop column elevator;

alter table home_data
drop column balcony;

alter table home_data
drop column parking;

alter table home_data
drop column dishwasher;

alter table home_data
drop column "Washing machine";

alter table home_data
drop column "Electric charging station";

alter table home_data
drop column dryer;

-- Create time dimension table, establish 1:many relationship with home_data
select concat("Rental period",'_',"Available from",'_',"Creation Date")
from home_data;

alter table home_data
add column time_dim_id varchar(250);

update home_data
set time_dim_id = concat("Rental period",'_',"Available from",'_',"Creation Date");

create table time_dim as
select distinct time_dim_id, "Rental period","Available from", "Creation Date"
from home_data;

alter table time_dim
add constraint PK_time_dim 
PRIMARY KEY (time_dim_id);

alter table home_data
add constraint FK_time_dim 
FOREIGN KEY (time_dim_id) references time_dim (time_dim_id);

alter table home_data
drop column "Rental period";

alter table home_data
drop column "Available from";

alter table home_data
drop column "Creation Date";

-- Create adress dimension table and establish 1:many relationship with home_data
select concat(street, post_code, district, floor)
from home_data;

alter table home_data
add column adress_dim_id varchar(250);

update home_data
set adress_dim_id = concat(street, post_code, district, floor);

create table adress_dim as
select distinct adress_dim_id, street, post_code, district, floor
from home_data;

alter table home_data
drop column street;

alter table home_data
drop column post_code;

alter table home_data
drop column district;

alter table home_data
drop column floor;

alter table home_data
drop column adress;

alter table adress_dim
add constraint PK_adress_dim
PRIMARY KEY (adress_dim_id);

alter table home_data
add constraint FK_adress_dim
FOREIGN KEY (adress_dim_id) references adress_dim (adress_dim_id);

-- Manage 1:many relationship between bydel and adress_dim tables
alter table bydel
add constraint PK_district_id
PRIMARY KEY (navn);

alter table adress_dim
add constraint FK_district_id
FOREIGN KEY (district) references bydel (navn);

-- Establish 1:many relationship betweem amager_sides and bydel tables.
alter table amager_sides
add constraint FK_amager_sides
FOREIGN KEY ("Amager side") references bydel (navn);

-- Make Listing-id column , primary key for the home_data table
alter table home_data
add constraint PK_home_data
PRIMARY KEY ("Listing-id");

-- Drop unnecesseray column energy rating from home_data table
alter table home_data
drop column "Energy rating";

-- Replace kr. and cast column Monthly net rent as integer
update home_data
set "Monthly net rent" = replace(replace(replace("Monthly net rent", 'kr.', ''),'.', ''),',', '');

alter table home_data
alter column "Monthly net rent" type INTEGER using "Monthly net rent"::INTEGER;

-- Replace kr. and cast column utilities as integer
update home_data
set utilities = replace(replace(replace(utilities, 'kr.', ''),'.', ''),',', '');

alter table home_data
alter column utilities type INTEGER using utilities::INTEGER;

-- Replace kr. and cast column deposit as integer
update home_data
set deposit = replace(replace(replace(deposit, 'kr.', ''),'.', ''),',', '');

alter table home_data
alter column deposit type INTEGER using deposit::INTEGER;

-- Replace kr. and cast column prepaid rent as integer
update home_data
set "Prepaid rent" = replace(replace(replace("Prepaid rent", 'kr.', ''),'.', ''),',', '');

alter table home_data
alter column "Prepaid rent" type INTEGER using "Prepaid rent"::INTEGER;

-- Replace kr. and cast column prepaid rent as integer
update home_data
set "Move-in price" = replace(replace(replace("Move-in price", 'kr.', ''),'.', ''),',', '');

alter table home_data
alter column "Move-in price" type INTEGER using "Move-in price"::INTEGER;

-- Replace 2.5 value in rooms column to 2.
update property_feat_dim
set rooms = replace(rooms,'2.5','2');
