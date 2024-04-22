# Copenhagen Home Rental Analysis

## Purpose 
The purpose of this project is to analyze various rental advertisements for properties (apartments/rooms) in Copenhagen. I will answer questions related to:
- How do prices change depending on the house type?
- Which areas contain the biggest amount of student friendly appartments/rooms?
- How does prices changing per district?
- What is the average availability time(in days) per district?
- What kind of extra utilities does the price usually includes?

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
10) 'Report' is Power BI report/responsive dashboard.

## Findings/Report

## Static View of dashboard 
![alt text](cph_rental.PNG)