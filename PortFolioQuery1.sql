-- Covid 19 data exploration in Indonesia

select *
from PortofolioProject01..covid_deaths

--Data that we're going to start with

select location, population, date, total_cases, new_cases, total_deaths 
from PortofolioProject01..covid_deaths
where location like 'Indonesia'

--covid 19 death percentage in Indonesia

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortofolioProject01..covid_deaths
where location like 'Indonesia'

--covid 19 total cases percentage in Indonesia

select location, date, population, total_cases, (total_cases/population)*100 as case_percentage
from PortofolioProject01..covid_deaths
where location like 'Indonesia'

--highest infection in Indonesia

select location, date, population, MAX(total_cases) as highest_infection
from PortofolioProject01..covid_deaths
where location like 'Indonesia'
group by location, population, date
order by highest_infection desc

--highest death rate in Indonesia

select location, date, population, MAX(cast(total_deaths as int)) as highest_death
from PortofolioProject01..covid_deaths
where location like 'Indonesia'
group by location, population, date
order by highest_death desc

--show vaccination in Indonesia

select dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(cast(vax.new_vaccinations as int)) OVER (Partition by dea.location order by dea.date) as rolling_total_vax
from PortofolioProject01..covid_deaths dea
join PortofolioProject01..covid_vax vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.location like 'Indonesia'

--percentage of Indonesian population that has vaccinated
--Creat temp table using CTE

with vax_ind(location, date, population, new_vaccinations, rolling_total_vax)
as
(
select dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(cast(vax.new_vaccinations as int)) OVER (Partition by dea.location order by dea.date) as rolling_total_vax
from PortofolioProject01..covid_deaths dea
join PortofolioProject01..covid_vax vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.location like 'Indonesia'
)
select *, (rolling_total_vax/population)*100 as vax_percentage
from vax_ind

--creating views to store the data.
--can be used for visualization

create view total_case_indonesia as
select location, date, population, total_cases, (total_cases/population)*100 as case_percentage
from PortofolioProject01..covid_deaths
where location like 'Indonesia'

create view total_death_indonesia as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortofolioProject01..covid_deaths
where location like 'Indonesia'

create view vax_indonesia as
select dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(cast(vax.new_vaccinations as int)) OVER (Partition by dea.location order by dea.date) as rolling_total_vax
from PortofolioProject01..covid_deaths dea
join PortofolioProject01..covid_vax vax
	on dea.location = vax.location
	and dea.date = vax.date
where dea.location like 'Indonesia'




