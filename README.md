# Copenhagen_Home_Rental_Analysis
The purpose of this project is to analyze different rental advertisements of properties (appartments/rooms) in Copenhagen and surroundings. 

The first stage of the project consists of obtaining data by web scraping. This is done by scrapping the house ads found 
on boligportal.dk with filter criteria focused on Copenhagen . 

Afterwards, data cleaning and data exploration was performed by creating a postgresql database and manipulate it using SQL.

Finally, there is a visual presentation regarding the top districs in Copenhagen (Excluding Frederiksberg)

1) 'Home_scrap' file contains the code of the web scraping process done in Python.
2) ads_data.csv file contains tabular data. These are the data obtained by webscrapping.
3) 'Data_Cleaning_SQL' file contains the code for data cleaning process done using SQL.
4) clean_data_db.csv file contains cleaned data.
5) 'Data_Exploration_SQL' file contains the code for data exploration done using SQL.
6) 'amager_sides' files contains data about whether an adress in in amager east or west
7) 'bydel' file contains geodata about top districs in Copenhagen
8) 'districts_correct' same as above but in json format. Need it in order to present a visual map of Copenhagen.
9) 'top_kbh_districs' contains data about the top districs in Copenhagen.
10) 'Report' is Power BI report/responsive dashboard.