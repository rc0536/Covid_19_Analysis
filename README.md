COVID-19 Data Analysis
This repository contains SQL queries used for analyzing COVID-19 data from a comprehensive database named PortfolioProject. The queries cover various aspects of the pandemic, such as case counts, death rates, vaccination rates, and more, focusing on different geographic levels including states, countries, and continents.

Queries Overview
Below are descriptions of the main queries included in this project:

Total Cases and Deaths by State
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location LIKE '%states%'
ORDER BY Location, date;
This query calculates the percentage of deaths from the total COVID-19 cases for each state in the United States.

Total Cases vs Population by State
SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..Covid_Deaths
WHERE location LIKE '%states%'
ORDER BY Location, date;
This query shows the percentage of the population that has been infected with COVID-19 in each state.

Countries with Highest Infection Rate
SELECT Location, Population, date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/Population))*100 AS PercentPopulationInfected
FROM PortfolioProject..Covid_Deaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;
Identifies countries with the highest infection rate relative to their population.

Countries with Highest Death Count per Population
SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;
Lists countries with the highest absolute number of COVID-19 deaths.

Continent with Highest Death Count
SELECT Continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..Covid_Deaths
WHERE Continent IS NOT NULL 
GROUP BY Continent
ORDER BY TotalDeathCount DESC;
Shows which continent has experienced the highest number of COVID-19 deaths.

Global and Rolling Numbers
Includes global case and death totals, as well as rolling vaccinations.

Example: Global Daily Totals
SELECT date, SUM(CAST(new_cases AS INT)) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE Continent IS NOT NULL
GROUP BY date
ORDER BY date;
Vaccination Data

-- Using Common Table Expressions (CTE) for clarity
WITH PopVsVac AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, Vac.new_vaccinations, SUM(CAST(Vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.Location, dea.Date) AS RollingPeopleVaccinated
    FROM PortfolioProject..Covid_Deaths AS Dea
    JOIN PortfolioProject..Covid_Vaccinations AS Vac ON dea.location = Vac.location AND dea.date = Vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentPopulationVaccinated
FROM PopVsVac;
Visualizations
Views created for facilitating data visualization:


CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, Vac.new_vaccinations, SUM(CAST(Vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.Location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac ON dea.location = Vac.location AND dea.date = Vac.date
WHERE dea.continent IS NOT NULL;

SELECT * FROM PercentPopulationVaccinated;
Installation
Clone this repository to your local machine to work with the SQL files:


git clone [repository-url]
Usage
Use these queries to analyze your data in any SQL environment that supports T-SQL, such as Microsoft SQL Server.

Contributing
Contributions to this project are welcome. Please fork the repository and submit pull requests to enhance the analysis.

License
Distributed under the MIT License. See LICENSE for more information.
