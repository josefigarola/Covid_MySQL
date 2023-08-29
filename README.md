# MYSQL Practices for Data Analysis 

This repository focuses on creating different queries for Data Analysis and SQL practice.
A [Tableu Project](https://public.tableau.com/app/profile/miguel.figarola/viz/CovidVisualization_16932680165500/CasesandDeaths#1) project was made from the data given from this [Repo](https://ourworldindata.org/covid-deaths).
and was downloaded August 2023.

# Data
The data given was from COVID in which we can devide into vaccination data and deaths data in CSV files. 
Date formatting was given in Excel in order to have YYYY-MM-DD insted of DD/MM/YYYY for SQL purposes.

# Importing Data
Some workbench can import CSV files pretty easy and rapidly, on my case I used MySQL Workbench CE 8.0
and was not allowed to import it smoothly so the python script on 'Others' folder converts CSV to SQL files.
(Keep in mind that the data types are all TEXT and require to change the type or cast it altering the tables).

![Map](Others/Cases_and_Deaths.png)
