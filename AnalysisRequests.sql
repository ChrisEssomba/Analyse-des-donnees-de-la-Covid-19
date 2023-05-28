'Suprimer la contrainte sur les valeurs null de la colonne continent'
ALTER TABLE coviddeaths
ALTER COLUMN continent
DROP NOT NULL;

--NB: les valeurs new sont en jours

--Importatons des données dans la table de vaccination
COPY Public."covidvaccinations" FROM 'D:\PortoFolio Projects\SQL projects\Project 1\SQL covid deaths project\covidVacCleaned.csv' DELIMITER ';' CSV HEADER;

-- Importatons des données dans la table des deces du covid
COPY Public."coviddeaths" FROM 'D:\PortoFolio Projects\SQL projects\Project 1\SQL covid deaths project\coviddeathsCleaned.csv' DELIMITER ';' CSV HEADER;


--Etapes pour supprimer les doublons de date dans la table des vaccinations
-- Créer une copie temporaire de la table
CREATE TABLE temp_table AS
SELECT DISTINCT *
FROM covidvaccinations;
-- Supprimer l'ancienne table
DROP TABLE covidvaccinations;
-- Renommer la copie temporaire avec le nom original
ALTER TABLE temp_table RENAME TO covidvaccinations;

--Etapes pour supprimer les doublons de date dans la table des deces
-- Créer une copie temporaire de la table
CREATE TABLE temp_table AS
SELECT DISTINCT *
FROM coviddeaths;
-- Supprimer l'ancienne table
DROP TABLE coviddeaths;
-- Renommer la copie temporaire avec le nom original
ALTER TABLE temp_table RENAME TO coviddeaths;



 
 --Visualisons le nombre de cas total, ainsi que le nombre de deces enregistré chaque année depuis le debut de la pandemie
SELECT EXTRACT(YEAR FROM date) AS year, SUM(new_cases) AS total_cases,
SUM(new_deaths) AS total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathsPercentage
FROM coviddeaths
GROUP BY EXTRACT(YEAR FROM date);


--Decouvrons le nombres de deces en fontion des continents et regions du monde et le pourcentage de la population touchée
select continent,  SUM(new_cases) AS total_cases,
sum(new_cases)/sum(new_tests)*100 as Infection_percentage
from coviddeaths
group by continent
order by 3 desc

--Decouvrons la densité de la population et le taux de contamination
select continent,  AVG(population_density) AS population_density,
sum(new_cases)/sum(new_tests)*100 as InfectionsPercentage
from coviddeaths
group by continent
order by 2, 3 desc

--Decouvrons la correlation entre le pourcentage de la population de 65 ans et plus et le taux de deces
select location,  MIN(aged_65_older) as max,
sum(new_deaths)/sum(new_cases)*100 as deathsPercentage
from coviddeaths
where new_cases <>0
group by location
order by 3 desc

-- Le 10 pays ayant le plus pourcentage de la population de 65 ans et plus les plus elevés
select location, MAX(aged_65_older) as max, 
sum(new_deaths)/sum(new_cases)*100 as deathsPercentage
from coviddeaths
where new_cases <>0 and new_deaths <>0
group by location
order by 2 desc

-- Observons le rapport entre le pourcentage de la population diabetique et le taux de mortalité
select location, MAX(diabetes_prevalence) as diabetes_prevalence, 
sum(new_deaths)/sum(new_cases)*100 as deathsPercentage
from coviddeaths
where new_cases <>0 and new_deaths <>0
group by location
order by 2 desc

--Observons le rapport entre le pourcentage de lit disponible et le taux de mortalité
select location, MAX(hospital_beds_per_thousand) as hospital_beds_per_thousand, 
sum(new_deaths)/sum(new_cases)*100 as deathsPercentage
from coviddeaths
where new_cases <>0 and new_deaths <>0
group by location
order by 2 

--Obervons l'impact de la vaccination sur le taux de contamination et le pourcentage de deces
select d.location, max(v.people_vaccinated)/max(d.population)*100 as vaccinationPercentage,
sum(d.new_cases)/sum(d.new_tests)*100 as InfectionsPercentage, 
sum(d.new_deaths)/sum(d.new_tests)*100 as deathsPercentageAlmonstPeopleTested
from coviddeaths d
inner join covidvaccinations v
on d.location = v.location
where d.new_cases <>0 and new_deaths <>0 and d.new_tests <>0
group by d.location
order by 2 desc


-- Suivons l'evolution du nombre de personnes vaccinées dans chaque pays du monde

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


--Conservons ces données les personnes vaccinées dans une nouvelle table
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



--Creer une vue pour pouvoir des visualisation des données sur les personnes vaccinées
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

--


