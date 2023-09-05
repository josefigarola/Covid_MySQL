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
    AND continent <> ''
GROUP BY
    date
ORDER BY
    1,2;

# Total popuilation vs Total vaccination
SELECT
    deaths.continent,
    deaths.location,
    deaths.date,
    deaths.population,
    vaccs.new_vaccinations,
    SUM(cast(vaccs.new_vaccinations AS UNSIGNED)) 
    OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS TotalVaccinations
FROM
    deaths
JOIN
    vaccs
ON 
    deaths.location = vaccs.location
    and deaths.date = vaccs.date
WHERE
    deaths.continent is not null
    AND deaths.continent <> ''
ORDER BY
    2,3;

# Using CTE
WITH   
    PopsvsVacss(
        continent,
        location,
        date,
        population,
        new_vaccinations,
        TotalVaccinations)
AS(
    SELECT
    deaths.continent,
    deaths.location,
    deaths.date,
    deaths.population,
    vaccs.new_vaccinations,
    SUM(cast(vaccs.new_vaccinations AS UNSIGNED)) 
    OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS TotalVaccinations
    FROM
        deaths
    JOIN
        vaccs
    ON 
        deaths.location = vaccs.location
        and deaths.date = vaccs.date
    WHERE
        deaths.continent is not null
        AND deaths.continent <> ''
)
SELECT 
    *,
    (TotalVaccinations/population)*100 AS VaccinationPercentage
FROM 
    PopsvsVacss;

# Creating TEMP table
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
    continent VARCHAR(255),
    location VARCHAR(255),
    date DATETIME,
    population NUMERIC,
    newVacss NUMERIC,
    vaccinatedPercentage NUMERIC
);
INSERT INTO PercentPopulationVaccinated
    SELECT
        deaths.continent,
        deaths.location,
        deaths.date,
        deaths.population,
        CASE WHEN vaccs.new_vaccinations = '' THEN NULL ELSE vaccs.new_vaccinations END AS newVacss,
        SUM(CAST(CASE WHEN vaccs.new_vaccinations = '' THEN '0' ELSE vaccs.new_vaccinations END AS UNSIGNED)) 
        OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS TotalVaccinations
    FROM
        deaths
    JOIN
        vaccs
    ON 
        deaths.location = vaccs.location
        AND deaths.date = vaccs.date
    WHERE
        deaths.continent IS NOT NULL
        AND deaths.continent <> ''
    ORDER BY
        2,3;
SELECT 
    *,
    (vaccinatedPercentage/population)*100 AS VaccinationPercentage
FROM 
    PercentPopulationVaccinated;

# Creating VIEW for later visualization
CREATE VIEW VaccinationView AS
    SELECT
        deaths.continent,
        deaths.location,
        deaths.date,
        deaths.population,
        CASE WHEN vaccs.new_vaccinations = '' THEN NULL ELSE vaccs.new_vaccinations END AS newVacss,
        SUM(CAST(CASE WHEN vaccs.new_vaccinations = '' THEN '0' ELSE vaccs.new_vaccinations END AS UNSIGNED)) 
        OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS TotalVaccinations
    FROM
        deaths
    JOIN
        vaccs
    ON 
        deaths.location = vaccs.location
        AND deaths.date = vaccs.date
    WHERE
        deaths.continent IS NOT NULL
        AND deaths.continent <> '';
SELECT 
    *,
    (TotalVaccinations / population) * 100 AS VaccinationPercentage
FROM 
    VaccinationView;
