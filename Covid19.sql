
select * from PortfolioProject..Covid_Deaths
order by 3,4 ;

--Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..Covid_Deaths
where location like '%states%'
order by 1,2

--Total Cases vs Population

Select Location, date, Population,  total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..Covid_Deaths
where location like '%states%'
order by 1,2

--Countries with Highest Infection Rate compared to Population

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAx((total_cases/Population))*100 as PercentPopulationInfected
from PortfolioProject..Covid_Deaths
Group by Location, Population, date
order by PercentPopulationInfected Desc

--Countries with Highest Death count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_Deaths
where continent is not null
Group by Location
order by TotalDeathCount Desc

-- Conitinent with Highest death count
Select Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_Deaths
where Continent is not null 
Group by Continent
order by TotalDeathCount Desc

-- Global Numbers

Select date, Sum(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPrecentage
from PortfolioProject..Covid_Deaths
where Continent is not null
group by date
order by 1,2

-- Total Global Numbers

Select Sum(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPrecentage
from PortfolioProject..Covid_Deaths
where Continent is not null
order by 1,2

-- Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, Vac.new_vaccinations, SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as RollingPeopleVacinated
from PortfolioProject..Covid_Deaths as Dea
join PortfolioProject..Covid_Vaccinations as Vac
	on dea.location = Vac.location
	and dea.date = Vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, Vac.new_vaccinations, SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as RollingPeopleVacinated
from PortfolioProject..Covid_Deaths as Dea
join PortfolioProject..Covid_Vaccinations as Vac
	on dea.location = Vac.location
	and dea.date = Vac.date
where dea.continent is not null
)
Select *, (RollingPeoplevaccinated/population)*100
From PopvsVac

-- Temp Table

Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)

-- Inserting into Temp Table

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, Vac.new_vaccinations, SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as RollingPeopleVacinated
from PortfolioProject..Covid_Deaths as Dea
join PortfolioProject..Covid_Vaccinations as Vac
	on dea.location = Vac.location
	and dea.date = Vac.date
where dea.continent is not null

Select *, (RollingPeoplevaccinated/population)*100
From #PercentPopulationVaccinated

-- Creating Views for visulization

-- Percentage of population that is vaccinated
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, Vac.new_vaccinations, SUM(cast(Vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as RollingPeopleVacinated
from PortfolioProject..Covid_Deaths as Dea
join PortfolioProject..Covid_Vaccinations as Vac
	on dea.location = Vac.location
	and dea.date = Vac.date
where dea.continent is not null

Select * from PercentPopulationVaccinated

-- Percent Of Fully Vaccinated People In Each Country
Select dea.continent, dea.location, dea.date, dea.population, Vac.people_fully_vaccinated, SUM(cast(Vac.people_fully_vaccinated as bigint)) OVER (Partition by dea.location Order by dea.Location, dea.Date) as RollingPeopleVacinated
from PortfolioProject..Covid_Deaths as Dea
join PortfolioProject..Covid_Vaccinations as Vac
	on dea.location = Vac.location
	and dea.date = Vac.date
where dea.continent is not null
