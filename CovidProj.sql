SELECT *
FROM
PortfolioProject..CovidDeaths
Order by 3,4


--Select Data to be used
SELECT
location, date, total_cases, new_cases, total_deaths, population
FROM 
PortfolioProject..CovidDeaths
ORDER BY  1,2


--Total Cases vs Total Deaths, Death rate as percentage
SELECT
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE location like '%Zim%'
ORDER BY  1,2


--Total cases vs population, infection rate
SELECT
location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE location like '%Zim%'
ORDER BY  1,2


--Contries with highest infection to population rate
SELECT
location, population, MAX(total_cases) as PeakInfection, MAX((total_cases/population))*100 as PeakInfectionPercentage
FROM
PortfolioProject..CovidDeaths 
GROUP by location, population
ORDER BY PeakInfectionPercentage desc


--Contries with Highest Death Count Per Population
SELECT
location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM
PortfolioProject..CovidDeaths 
WHERE continent is not null
GROUP by location
ORDER BY TotalDeathCount desc

--By Continent
SELECT
continent, MAX(cast(total_deaths as int)) as TotalDeathCountC
FROM
PortfolioProject..CovidDeaths 
WHERE continent is not null
GROUP by continent
ORDER BY TotalDeathCountC desc

--Global Numbers
SELECT
date, SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as TDeathPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY  1,2

--Total Deaths & Percent
SELECT
SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as TDeathPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY  1,2


-- Total population vs Vaccination = Vaccination Rate
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingVacinationTotal
--, (RollingVaccinationTotal/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date =vac.date
WHERE dea.continent is not null

--use CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinationTotal)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingVaccinationTotal
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date =vac.date
WHERE dea.continent is not null
)
Select *, (RollingVaccinationTotal/population)*100
FROM PopvsVac


--Temp Table
--Drop Table if exists #PercentPopulationVaccinated (clear errors)
Create table #PercentPopulationVaccinated
(
Continent nvarchar(225),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinationTotal numeric,
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingVaccinationTotal
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date =vac.date
WHERE dea.continent is not null

Select *, (RollingVaccinationTotal/population)*100
FROM #PercentPopulationVaccinated


--Create view to store data for later vis
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingVaccinationTotal
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date =vac.date
WHERE dea.continent is not null

--Vis 2
Create View InfectionPercentage as
SELECT
location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE location like '%Zim%'

--Vis 3
Create View DeathPercentage as
SELECT
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE location like '%Zim%'

--Vis 4 global
Create View TDeathPercentage as
SELECT
date, SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as TDeathPercentage
FROM 
PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
