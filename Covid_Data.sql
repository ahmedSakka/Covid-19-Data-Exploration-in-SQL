-- Exploring the data


SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4


SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3,4



-- The data I am using

SELECT location, date, total_cases_cleaned, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2



-- Case fatality rate based on a specified location (Palestine)

SELECT location, MAX(total_cases_cleaned) AS TotalCasesCount, MAX(total_deaths) AS TotalDeathCount, 
MAX((CONVERT(FLOAT, total_deaths)/total_cases_cleaned)) * 100 as CaseFatalityRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Palestine'
GROUP BY location



-- Covid prevalence rate

ALTER TABLE PortfolioProject.dbo.CovidDeaths
ADD total_cases_cleaned INT


UPDATE PortfolioProject.dbo.CovidDeaths
SET total_cases_cleaned = REPLACE(total_cases, ',', '') -- Remove commas if present

ALTER TABLE PortfolioProject.dbo.CovidDeaths
ALTER COLUMN total_cases_cleaned INT


SELECT location, MAX(population) AS population, MAX(total_cases_cleaned) AS total_cases, 
(MAX(total_cases_cleaned) / MAX(population)) *100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY PercentPopulationInfected DESC

-- adding the date to the analysis

Select Location, Population, date, MAX(total_cases_cleaned) as HighestInfectionCount,  
Max((total_cases_cleaned/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Countries with the highest infection rate per population

SELECT TOP 10 location, population, MAX(total_cases_cleaned) AS HighestInfectionCount, 
(MAX(total_cases_cleaned)/ population)*100 AS CovidPrevalenceRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY CovidPrevalenceRate DESC


-- Countries with the highest death count and showing the mortality rate

SELECT --TOP 10 
location, population, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount,
(MAX(CONVERT(INT, total_deaths))/population) * 100 AS MortalityRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY TotalDeathCount DESC



-- Death rate and count, and infection count by continents


WITH ContinentCount AS (
    SELECT
        continent, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount,
        MAX(total_cases_cleaned) AS TotalInfectionCount
    FROM
        PortfolioProject.dbo.CovidDeaths
    WHERE
        continent IS NOT NULL AND location NOT LIKE '%income'
    GROUP BY
        continent
)
SELECT
    continent, TotalDeathCount, TotalInfectionCount,
    (CONVERT(FLOAT, TotalDeathCount) / TotalInfectionCount) * 100 AS CaseFatalityRate
FROM
    ContinentCount
ORDER BY
	CaseFatalityRate DESC



-- Case fatality rate and count by countries


WITH TotalCount AS (
    SELECT
        location, population, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount,
        MAX(total_cases_cleaned) AS TotalInfectionCount
    FROM
        PortfolioProject.dbo.CovidDeaths
    WHERE
        continent IS NOT NULL
    GROUP BY
        location,
        population
)
SELECT
    location, population, TotalDeathCount,
    (CONVERT(FLOAT, TotalDeathCount) / TotalInfectionCount) * 100 AS CaseFatalityRate
FROM
    TotalCount
ORDER BY
        CaseFatalityRate DESC



-- Daily global numbers


SELECT date, SUM(new_cases) AS DailyTotalCases, SUM(new_deaths) AS DailyTotalDeaths
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY date
ORDER BY 1



-- Total cases, total deaths, and death rate across the world (2020-1-1 To 2023-5-13)


SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths,
SUM(new_deaths)/SUM(new_cases)*100 AS CaseFatalityRate
FROM PortfolioProject.dbo.CovidDeaths



-- Vaccinations count per day and percent


With VacCount (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select de.continent, de.location, de.date, de.population, vc.new_vaccinations
, SUM(CONVERT(bigint,vc.new_vaccinations)) OVER (Partition by de.Location Order by de.location, de.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths de
Join PortfolioProject..CovidVaccinations vc
	On de.location = vc.location
	and de.date = vc.date
where de.continent is NOT null
)
Select *, (RollingPeopleVaccinated/Population)*100 AS VaccinatedPeoplePercent
From VacCount



-- Creating Views

-- Daily Numbers
CREATE VIEW DailyGlobalNumbers AS
SELECT date, SUM(new_cases) AS DailyTotalCases, SUM(new_deaths) AS DailyTotalDeaths
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY date

-- Case fatality rate
CREATE VIEW CaseFatalityRate AS
WITH TotalCount AS (
    SELECT
        location, population, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount,
        MAX(total_cases_cleaned) AS TotalInfectionCount
    FROM
        PortfolioProject.dbo.CovidDeaths
    WHERE
        continent IS NOT NULL
    GROUP BY
        location,
        population
)
SELECT
    location, population, TotalDeathCount,
    (CONVERT(FLOAT, TotalDeathCount) / TotalInfectionCount) * 100 AS CaseFatalityRate
FROM
    TotalCount

-- Global numbers
CREATE VIEW GlobalNumbers AS
WITH ContinentCount AS (
    SELECT
        continent, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount,
        MAX(total_cases_cleaned) AS TotalInfectionCount
    FROM
        PortfolioProject.dbo.CovidDeaths
    WHERE
        continent IS NOT NULL AND location NOT LIKE '%income'
    GROUP BY
        continent
)
SELECT
    continent, TotalDeathCount, TotalInfectionCount,
    (CONVERT(FLOAT, TotalDeathCount) / TotalInfectionCount) * 100 AS DeathRate
FROM
    ContinentCount

-- Vaccination count

CREATE VIEW VaccinationCount AS
With VacCount (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select de.continent, de.location, de.date, de.population, vc.new_vaccinations
, SUM(CONVERT(bigint,vc.new_vaccinations)) OVER (Partition by de.Location Order by de.location, de.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths de
Join PortfolioProject..CovidVaccinations vc
	On de.location = vc.location
	and de.date = vc.date
where de.continent is NOT null
)
Select *, (RollingPeopleVaccinated/Population)*100 AS VaccinatedPeoplePercent
From VacCount
