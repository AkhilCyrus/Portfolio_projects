select * from
PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

select * from
PortfolioProject.dbo.CovidVaccinations
order by 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1, 2

-- Looking at total cases vs total deaths
-- probablity of death acccording to diff countries

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%kingdom%'
order by 1, 2


-- Total cases vs population
-- shows what persentage of population has covid

SELECT location,date,total_cases,population,(total_cases/population)*100 as CasePercentage
from PortfolioProject..CovidDeaths
where location = 'United Kingdom'
order by 1, 2


--Looking at countries with highest infection rate compared to population

SELECT location,population,max(total_cases) AS higestinfectioncount,max((total_cases/population))*100 as Percentagepopulationinfected
from PortfolioProject..CovidDeaths
group by population,location
order by 4 desc

-- Showing countries with highest death count per population

SELECT location,max(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathcount desc

-- Breakdown based on continent

SELECT continent,max(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathcount desc


-- continents with the highest death count


SELECT continent,max(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathcount desc

-- Global numbers
SELECT sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as totaL_deaths, sum(cast(New_deaths as int))/sum(New_cases)*100 as deathPercentage   --total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,dea.date)as rolling_people_vaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location =vac.location and 
dea.date = vac.date
where dea.continent is not null
order by 2,3



--CTC
with Pop_vs_Vac ( continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,dea.date)as rolling_people_vaccinated
 
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location =vac.location and 
dea.date = vac.date
where dea.continent is not null
)
select *,(rolling_people_vaccinated/population)*100 as percentage_of_people_vaccinated
from Pop_vs_Vac


--Creating View to store data for Vishvalizasion
create View persent_of_population_vaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,dea.date)as rolling_people_vaccinated
 
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location =vac.location and 
dea.date = vac.date
where dea.continent is not null


select * 
from persent_of_population_vaccinated




