'Suprimer la contrainte sur les valeurs null de la colonne continent'
ALTER TABLE coviddeaths
ALTER COLUMN continent
DROP NOT NULL;

--NB: les valeurs new sont en jours

--Importer les données dans la table de vaccination
COPY Public."covidvaccinations" FROM 'D:\PortoFolio Projects\SQL projects\Project 1\covidVac.csv' DELIMITER ';' CSV HEADER;

-- Copie des valeurs de mon fichier csv dans ma table
COPY Public."coviddeaths" FROM 'D:\PortoFolio Projects\SQL projects\Project 1\coviddeaths.csv' DELIMITER ';' CSV HEADER;

'Nous selectionons tous les elements de notre tables pour avoir une vision d ensemble'
select * 
from coviddeaths
where continent is not null
order by 3,4

'Observons les champs qui nous interessent le plus'
select location, date, population, total_cases, new_cases, total_deaths
from coviddeaths
order by 1,2

--Comparons le total de cas contre le total de morts et ressortons la pourcentage de deces en France
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsRate
from coviddeaths
where location like 'France'
order by 2 desc

--Comparons le total de cas par rapport a la population total pour ressortir le pourcentage de la population infecté
select location, date, population, total_cases, (total_cases/population)*100 as Pourcentage_de_population_infecté
from coviddeaths
where location like 'France'
order by 2 desc

-- Decouvrons les pays avec le plus de cas confirmé en fonction du nombre total de la population
select location, population, MAX(total_cases) as hightestInfectionCount, MAX((total_cases/population))*100 as populationInfectedRate
from coviddeaths
group by location, population
order by 4 desc

--Decouvrons le nombres de deces en fontion des continents et regions du monde et le pourcentage de la population touchée
select continent, MAX(total_deaths) as hightestTotalDeathCount, MAX((total_deaths/population))*100 as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by 2 desc


--Decouvrons les pays avec le plus grands nombre de deces
select location, MAX(total_deaths) as hightestTotalDeathCount, MAX((total_deaths/population))*100 as TotalDeathCount
from coviddeaths
where continent is not null
group by location, population
order by 2 desc

--GOBAL NUMBERS
select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as deathsPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsRate
from coviddeaths
-- where location like 'France'
where continent is not null and new_cases <> 0
--group by date
order by 1,2 desc

-- Decouvrons le nombre total de personnes qui ont été dans le monde
-- Presentons l'evolutions journaliere du nombre total de personnes vacciné 

WITH IncreasingPop as (
  select
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
  from
    coviddeaths dea
    join covidvaccinations vac on dea.location = vac.location and dea.date = vac.date
  where
    dea.continent is not NULL --and dea.location like 'France'
)
select *,
  (RollingPeopleVaccinated / population) * 100 as vaccinatedPercentage
from IncreasingPop;


--TEMP TABLE
drop table if exists PercentPopulationVaccinated
create table PercentPopulationVaccinated
(
continent text,
location text,
date date, 
population double precision, 
new_vaccinations double precision,
RollingPeopleVaccinated double precision
)
insert into PercentPopulationVaccinated
select 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
  from
    coviddeaths dea
    join covidvaccinations vac on dea.location = vac.location and dea.date = vac.date
  where
    dea.continent is not NULL --and dea.location like 'France'
select *,
  (RollingPeopleVaccinated / population) * 100 as vaccinatedPercentage
from PercentPopulationVaccinated;



--Creer une vue pour conserver les data envue de leur visualisation
create view PercentPopulationVaccinatedView as 
select 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
  from
    coviddeaths dea
    join covidvaccinations vac on dea.location = vac.location and dea.date = vac.date
  where
    dea.continent is not NULL --and dea.location like 'France'
 -- order by 2,3
