# Copenhagen Home Rental Analysis

## Static View of the report 

Download interactive dashboard here: https://github.com/Alexandros-Korolis/Copenhagen_Home_Rental_Analysis/blob/main/Report.pbix

![alt text](cph_rental.PNG)

## Purpose 
The purpose of this project is to analyze various rental advertisements for properties (apartments/rooms) in Copenhagen. I will answer questions related to:
- How do prices change depending on the type of house?
- Which areas contain the largest number of student-friendly apartments/rooms?
- Which district is suitable for students?
- When should one start searching for rental properties?
- What areas or properties are suitable for couples?

## Steps
&middot;The first stage of the project consists of obtaining data by web scraping. This is done by scrapping the house ads found on boligportal.dk with filter criteria focused on Copenhagen. 

&middot;Afterwards, data cleaning and exploration were performed by creating a PostgreSQL database locally and manipulating it using SQL.

&middot;Finally, create an interactive dashboard (focused on top Copenhagen Districts)and report the findings.

## Information about the files: 
1) 'Home_scrap' file contains the code of the web scraping process done in Python.
2) ads_data.csv file contains tabular data. These are the data obtained by webscrapping.
3) 'Data_Cleaning_SQL' file contains the code for data cleaning process done using SQL.
4) clean_data_db.csv file contains cleaned data.
5) 'Data_Exploration_SQL' file contains the code for data exploration done using SQL.
6) 'amager_sides' file contains data about whether an adress in in amager east or west
7) 'bydel' file contains geodata about top districs in Copenhagen
8) 'districts_correct' same as above but in json format. Need it in order to present a visual map of Copenhagen.
9) 'top_kbh_districs' contains data about the top districs in Copenhagen.
10) 'Report' is Power BI report.

## Findings/Report
- For the purpose of this analysis, with the term Copenhagen districts I describe the following areas/districts in Copenhagen: Amager East/West, Bispebjerg, Brønshøj-Husum, Indre By, Nørrebro, østerbro, Valby, Vanløse. While with the term surroundings I describe the areas around Copenhagen.

- Data shows that the average monthly net rent for one room in Copenhagen districts is
around 5600dkk, average deposit around 10000dkk average move-in price 19000dkk.

- Cheapest Copenhagen district to rent one room is Bispebjerg, with average monthly-net rent 4640dkk.

- Brønshøj-Husum has the lowest average net monthly rent for one room apartments in Copenhagen districs, with approximately 7270dkk. 

- Couples or two friends will need on average to pay 13140dkk monthly rent, if they plan to rent in one of Copenhagen districts. In this case, the majority of the rental properties will be unfurnished.

- Properties with balcony on average tend to be a bit more expensive that the ones without. (Both in Copenhagen districts and surroundings)

- Bispebjerg seems to have the highest amount of student-only type of properties, in Copenhagen and each surroundings. 

- Students that are looking to rent one room and furnished in appartment are more likely to find one in Brønshøj-Husum. The average monthly rent for sudent only, furnished one rooms in a shared appartment is 4000dkk.
