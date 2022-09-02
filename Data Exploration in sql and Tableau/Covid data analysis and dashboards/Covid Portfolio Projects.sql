Select *
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null
order by 3,4


--Select *
--From PortfolioProject.dbo.CovidVaccinations$
--order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths$
order by 1,2

-- Looking at Total Cases vs ToTal Deaths
-- Shows likelihood of dying if you contact covid in India
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Death_vs_cases_percent
From PortfolioProject.dbo.CovidDeaths$
Where location like '%India%'
order by 1,2

--Looking at Total Cases vs Population
-- Shows what percentage of people get Covid

Select Location, date, population, total_cases, (total_cases/population)*100 As Percent_Population_infected
From PortfolioProject.dbo.CovidDeaths$
Where location like '%India%'
order by 1,2

--Looking at countries with Highest Infection Rate compare to population

Select Location, population, Max(total_cases) As Highest_Infection_count, Max((total_cases/population)*100) As Max_Percent_Population_infected
From PortfolioProject.dbo.CovidDeaths$
Group by Location, population 
order by Max_Percent_Population_infected Desc

--Showing the countries with highest death count per population

Select Location, Max(cast(total_deaths as int)) As Highest_death_count
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null
Group by Location 
order by Highest_death_count Desc


--Breaking things down by continent
--Showing the continents with the highest death counts
Select continent, Max(cast(total_deaths as int)) As Highest_death_count
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null
Group by continent
order by Highest_death_count Desc

-- Global Numbers

Select Sum(new_cases) as sum_of_new_cases, sum(cast(new_deaths as int)) as sum_deaths, sum(cast(new_deaths as int))/Sum(new_cases)*100 as death_percentage
From PortfolioProject.dbo.CovidDeaths$
Where continent is not null
--Group By date
order by 1,2

Select *
From PortfolioProject.dbo.CovidDeaths$  dea
Join PortfolioProject.dbo.CovidVaccinations$  vac
     On dea.location = vac.location
	 and dea.date = vac.date

--Looking at total population vs vaccinations

Select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.dbo.CovidDeaths$  dea
Join PortfolioProject.dbo.CovidVaccinations$  vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


Select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
 over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths$  dea
Join PortfolioProject.dbo.CovidVaccinations$  vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


-- Use cte

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
 over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths$  dea
Join PortfolioProject.dbo.CovidVaccinations$  vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
 over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths$  dea
Join PortfolioProject.dbo.CovidVaccinations$  vac
     On dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



-- Creating view to store data for later visualisation


Create View PercentPopulationVaccinated as
Select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
 over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated -- (RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths$  dea
Join PortfolioProject.dbo.CovidVaccinations$  vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated