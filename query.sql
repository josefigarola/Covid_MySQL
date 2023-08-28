use covid;

# Get deaths 
select * from deaths order by 3,4 limit 10;
# Get vaccs
select * from vaccs order by 3,3 limit 10;

# Select the data 
select location, date, total_cases, new_cases, total_deaths, population 
from deaths order by 1,2;

# Total cases vs Total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
as ratio from deaths order by 1,2;