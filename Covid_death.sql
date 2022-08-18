--Data exploration �������
--Overview of data for countires �U��a�����
SELECT *
FROM Project..covid_deaths
where continent is not null
ORDER BY 3,4


--Selecting dates for use �u��ܻݭn�����
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Project..covid_deaths
where continent is not null
order by 1, 2


--Looking at total cases vs Total Deaths �p������רҸ򦺤`���ʤ���
SELECT location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as pct_death
FROM Project..covid_deaths
where continent is not null
order by 1, 2

--pct in Taiwan �u��ܥx�W���ʤ���
SELECT location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as pct_death
FROM Project..covid_deaths
where location like 'Taiwan'
order by 1, 2


--Total cases vs population �p������רҸ�H�f���ʤ���
SELECT location, date, total_cases,  population, (total_cases/population)*100 as pct_cases
FROM Project..covid_deaths
where continent is not null
order by 1, 2

--pct in taiwan �x�W���ʤ���
SELECT location, date, total_cases,  population, (total_cases/population)*100 as pct_cases
FROM Project..covid_deaths
where location like 'Taiwan'
order by 1, 2


--Highest infection rate compared to population �C�Ӱ�a���̰��P�V��H�f���ʤ���
SELECT location, population, MAX(total_cases) as highest_case, MAX((total_cases/population))*100  as highest_pct_cases
FROM Project..covid_deaths
where continent is not null
group by location, population
order by 4 desc


--HIghest death per population �̰����`��H�f���ʤ���
SELECT location, population, MAX(cast(total_deaths as int)) as highest_death,  MAX((total_deaths/population))*100  as highest_pct_death
FROM Project..covid_deaths
where continent is not null
group by location, population
order by 4 desc

--continent �U�{�̰����`
SELECT continent,  MAX(cast(total_deaths as int)) as highest_death
FROM Project..covid_deaths
where continent is not null
group by continent
order by highest_death

--global numbers �C��s�W�רҦ��`
SELECT date, max(new_cases) as sum_new_cases, sum(cast(new_deaths as int)) as sum_new_death, sum(cast(new_deaths as int))/max(new_cases)  as pct_death
FROM Project..covid_deaths
Group by date
HAVING max(new_cases)  is not null
and max(new_cases)  != 0
order by 1



--population with vacc �x�W�̭]���ئʤ���
--CTE
WITH Population_vacc(Continent, Location, Date, Population,new_vaccinations, adding_vacc)
as(
SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations, sum(cast(vacc.new_vaccinations as bigint)) OVER (Partition by death.location Order by death.location, death.date) as adding_vacc
FROM Project..covid_deaths death
JOIN Project..covid_vaccinations vacc
ON death.location = vacc.location
AND death.date = vacc.date
where death.continent is not null
)
Select *, adding_vacc/Population *100 as vacc_pct
FROM Population_vacc
WHERE location ='Taiwan'
Order by 2,3


--create visualization �s�y�Ϫ�
Create View vacc_table as
SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations, sum(cast(vacc.new_vaccinations as bigint)) OVER (Partition by death.location Order by death.location, death.date) as adding_vacc
FROM Project..covid_deaths death
JOIN Project..covid_vaccinations vacc
ON death.location = vacc.location
AND death.date = vacc.date
where death.continent is not null