Select *
From PortfolioProject.dbo. CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject.dbo. CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using

Select Location, Date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo. CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at total cases vs Total Deaths

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
Order by 1,2

--Looking at Total cases vs population

Select Location, Date,  population,total_cases, (total_cases/population)*100 as
PercentPopulation
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
Order by 1,2

--Looking at Countries with Highest Infection Rate Compared to Population

Select Location, population,MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as 
PercentPopulationInfected
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
Group by Location, population
Order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count Per Population

Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--Let's Break Things Down By Continent

Select continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Showing Continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


--Global Numbers

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercentage
From PortfolioProject.dbo. CovidDeaths
--Where Location like '%state%'
Where continent is not null
--Group by date
Order by 1,2

Select*
From PortfolioProject.dbo.CovidVaccinations


Select*
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVaccinations as vac
   on dea.location = vac.location
   and dea.date = vac.date

--Looking for total population vs vacinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVaccinations as vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   order by 1,2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVaccinations as vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   order by 1,2,3

--USE CTE
WITH PopvsVac (Continent, Location,	Date, Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVaccinations as vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
--Order By 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVaccinations as vac
   on dea.location = vac.location
   and dea.date = vac.date
   --where dea.continent is not null
--Order By 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
From PortfolioProject.dbo.CovidDeaths as dea
Join PortfolioProject.dbo.CovidVaccinations as vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--Order By 2,3

Select *
From PercentPopulationVaccinated











