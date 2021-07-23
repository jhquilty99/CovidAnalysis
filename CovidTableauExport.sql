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

----Comparing COVID deaths and cases from the tightest and loosest countries
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

SELECT t.Country, MAX(t.Tightness) as tightness, MAX(c.population) as population,
	MAX(cast(c.total_cases_per_million as float)) as max_per_capita_cases,
	MAX(cast(c.total_deaths_per_million as float)) as max_per_capita_deaths
FROM PortfolioProject..Tightness t
LEFT JOIN PortfolioProject..CovidDeaths c 
ON t.Country = c.location
GROUP BY t.Country
ORDER BY tightness desc