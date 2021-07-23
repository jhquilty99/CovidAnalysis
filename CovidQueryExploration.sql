--Select * 
--FROM PortfolioProject..CovidDeaths
--order by 3,4

--Select * 
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

-- Select data that we will be using

--SELECT Location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in the given country

--SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
--ORDER BY 1,2

-- Looking at total cases vs population
-- Shows percent of population who got Covid

--SELECT Location, date, total_cases, Population, (total_cases/population)*100 as PopPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
--ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to population

--SELECT Location, MAX(total_cases) as HighestInfectionCount, Population, MAX((total_cases/population))*100 as PerPopulationInfected
--FROM PortfolioProject..CovidDeaths
--GROUP BY Location, Population
--ORDER BY PerPopulationInfected DESC

-- Looking at Countries with Highest Death Rate compared to population

--SELECT Location, MAX(cast(total_deaths_per_million as float)) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
--GROUP BY Location
--ORDER BY TotalDeathCount DESC

-- Looking at Continents with Highest Death Rate compared to population

--SELECT location, MAX(cast(total_deaths_per_million as float)) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is null
--GROUP BY location
--ORDER BY TotalDeathCount DESC

-- Global Numbers

--SELECT SUM(new_cases) as TotalNewCases, SUM(cast(new_deaths as int)) as TotalNewDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
--ORDER BY 1,2

-- Looking at Total Population vs Vaccinations

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--	SUM(cast(vac.new_vaccinations as int)) OVER (Partition by vac.location ORDER by vac.location, vac.date) as
--	RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location 
--	and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

-- USE CTE

--WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--	SUM(cast(vac.new_vaccinations as int)) OVER (Partition by vac.location ORDER by vac.location, vac.date) as
--	RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location 
--	and dea.date = vac.date
--WHERE dea.continent is not null
--)
--SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentPopVaccinated
--FROM PopvsVac

-- CREATE TEMP TABLE

--DROP Table if exists #PercentPopulationVaccinated
--CREATE Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric, 
--RollingPeopleVaccinated numeric
--)

--INSERT into #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--	SUM(cast(vac.new_vaccinations as int)) OVER (Partition by vac.location ORDER by vac.location, vac.date) as
--	RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location 
--	and dea.date = vac.date
--WHERE dea.continent is not null

--SELECT *
--FROM #PercentPopulationVaccinated

-- CREATE VIEW

--CREATE VIEW PercentPopulationVaccinated as
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--	SUM(cast(vac.new_vaccinations as int)) OVER (Partition by vac.location ORDER by vac.location, vac.date) as
--	RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location 
--	and dea.date = vac.date
--WHERE dea.continent is not null

--Data is from https://osf.io/fsbnq/
--Need to preprocess some names to match covid deaths: China (Chi), Bosnia -> Bosnia and Herzegovina, 
--Botswana(Botswa), Ghana(Gha), Canada(Cada), Ivory Coast -> Cote d'Ivoire, Vietnam(Vietm), 
--Czech Republic, and UAE -> United Arab Emirates

--UPDATE PortfolioProject..Tightness
--SET Country = 'China'
--WHERE Country = 'Chi'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Bosnia and Herzegovina'
--WHERE Country = 'Bosnia'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Botswana'
--WHERE Country = 'Botswa'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Ghana'
--WHERE Country = 'Gha'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Canada'
--WHERE Country = 'Cada'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Cote d''Ivoire'
--WHERE Country = 'Ivory Coast'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Vietnam'
--WHERE Country = 'Vietm'

--UPDATE PortfolioProject..Tightness
--SET Country = 'United Arab Emirates'
--WHERE Country = 'UAE'

--UPDATE PortfolioProject..Tightness
--SET Country = 'Czechia'
--WHERE Country = 'Czech Republic'

--Checking to cross validate covid cases on October 16th 2020

--SELECT t.Country, c.total_cases, t.Oct16_total_cases
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidDeaths c 
--ON t.Country = c.location
--WHERE date = '2020-10-16 00:00:00.000'

--Also validating deaths on October 16th 2020
--SELECT t.Country, c.total_deaths, t.Oct16_total_deaths
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidDeaths c 
--ON t.Country = c.location
--WHERE date = '2020-10-16 00:00:00.000'

--Comparing COVID deaths and cases from the tightest and loosest countries
--SELECT TOP(5) t.Country, MAX(t.Tightness) as tightness, 
--	MAX(cast(c.total_cases_per_million as float)) as max_per_capita_cases,
--	MAX(cast(c.total_deaths_per_million as float)) as max_per_capita_deaths
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidDeaths c 
--ON t.Country = c.location
--GROUP BY t.Country
--ORDER BY tightness asc

--SELECT TOP(5) t.Country, MAX(t.Tightness) as tightness, 
--	MAX(cast(c.total_cases_per_million as float)) as max_per_capita_cases,
--	MAX(cast(c.total_deaths_per_million as float)) as max_per_capita_deaths
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidDeaths c 
--ON t.Country = c.location
--GROUP BY t.Country
--ORDER BY tightness desc

--Comparing COVID vaccinations from the tightest and loosest countries
--SELECT TOP(5) t.Country, MAX(t.Tightness) as tightness, 
--	MAX(cast(v.total_vaccinations_per_hundred as float)) as max_per_capita_vaccinations,
--	MAX(cast(v.total_tests_per_thousand as float)) as max_per_capita_tests
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidVaccinations v
--ON t.Country = v.location
--GROUP BY t.Country
--ORDER BY tightness asc

--SELECT TOP(5) t.Country, MAX(t.Tightness) as tightness, 
--	MAX(cast(v.total_vaccinations_per_hundred as float)) as max_per_capita_vaccinations,
--	MAX(cast(v.total_tests_per_thousand as float)) as max_per_capita_tests
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidVaccinations v
--ON t.Country = v.location
--GROUP BY t.Country
--ORDER BY tightness desc

--Creating the selection for the linear model
--SELECT t.Country, MAX(t.Tightness) as tightness, 
--	MAX(cast(v.total_vaccinations_per_hundred as float)) as max_per_capita_vaccinations,
--	MAX(cast(v.total_tests_per_thousand as float)) as max_per_capita_tests
--FROM PortfolioProject..Tightness t
--LEFT JOIN PortfolioProject..CovidVaccinations v
--ON t.Country = v.location
--GROUP BY t.Country
--ORDER BY tightness desc