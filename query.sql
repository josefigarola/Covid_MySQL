# Data Link: https://ourworldindata.org/covid-deaths
# Changed date format to YYYY-MM-DD
use covid;

# Get data
select * from deaths
where continent is not null;

# Get deaths data
select * from deaths order by 3,4 limit 10;
# Get vaccs data
select * from vaccs order by 3,3 limit 10;

# Select the data 
select location, date, total_cases, new_cases, total_deaths, population 
from deaths order by 1,2;

# Total cases vs Total deaths
SELECT 
    location, date, 
    total_cases, total_deaths, 
    (total_deaths/total_cases)*100 AS DeathsPercentage 
FROM 
    deaths
WHERE 
    location like 'Mexico'
ORDER BY 
    1,2; 

# Total cases vs population
SELECT 
    location, date, 
    total_cases, population, 
    (total_cases/population)*100 AS TotalCovidPercentage 
FROM 
    deaths
WHERE 
    location like 'Mexico'
ORDER BY 
    1,2; 

# Get highest infection rates
SELECT 
    location, population, 
    MAX(total_cases) AS HighestInfenctionCount,
    MAX((total_cases/population)*100) AS TotalCovidPercentage 
FROM 
    deaths
WHERE 
    continent is not null
GROUP BY 
    location, population
ORDER BY 
    TotalCovidPercentage DESC; 

# Show the countries with highest death count per population
SELECT 
    location, 
    MAX(cast(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM 
    deaths
WHERE 
    continent is not null
GROUP BY
    location
ORDER BY 
    TotalDeathCount DESC; 

# Show by continent
SELECT 
    continent, 
    MAX(cast(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM 
    deaths
WHERE 
    continent is not null
GROUP BY
    continent
ORDER BY 
    TotalDeathCount DESC; 

# Global stats
SELECT 
    date,
    SUM(new_cases) AS TotalCases,
    SUM(cast(new_deaths AS UNSIGNED)) AS TotalDeaths,
    SUM(cast(new_deaths AS UNSIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM
    deaths
WHERE 
    continent is not NULL
GROUP BY
    date
ORDER BY
    1,2;
