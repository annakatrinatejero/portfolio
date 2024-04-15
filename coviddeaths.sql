SELECT * FROM Portfolio_project.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_project.coviddeaths
ORDER BY 1,2;

-- Total Cases vs Total Deaths--
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_project.coviddeaths
WHERE location LIKE '%states'
ORDER BY 4 DESC;

-- Total Cases vs Total Population--
	-- Shows what percentage of the population got COVID 19 --
SELECT location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
FROM Portfolio_project.coviddeaths
WHERE location LIKE '%states'
ORDER BY 1,2 DESC;

-- Countries With The Highest Infection Rates--
SELECT location, population, max(total_cases) as MaxInfectionCount, Max((total_cases/population))*100 as InfectionRate
FROM Portfolio_project.coviddeaths
GROUP BY location, population
ORDER BY InfectionRate DESC;

-- Countries With The Highest Death Count Per Population--
SELECT location, max(total_deaths) as TotalDeathCount
FROM Portfolio_project.coviddeaths
WHERE CONTINENT IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;


-- Continents With The Highest Death Count --
SELECT continent, max(total_deaths) as TotalDeathCount
FROM Portfolio_project.coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS --
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM Portfolio_project.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total Population vs. Vaccinations --
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM Portfolio_project.coviddeaths dea
JOIN Portfolio_project.covidvaccines vac
	ON dea.location = vac.location
    and dea.date = vac.date
    WHERE dea.continent is NOT NULL
ORDER BY 2,3;

-- Create View --
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    (SELECT SUM(vac2.new_vaccinations)
     FROM Portfolio_project.covidvaccines vac2
     WHERE vac2.location = dea.location AND vac2.date <= dea.date) AS RollingPeopleVaccinated
FROM 
    Portfolio_project.coviddeaths dea
JOIN 
    Portfolio_project.covidvaccines vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;



