select * from Data1;

select * from Data2;

-- number of rows into our dataset

Select count(*) from Data1;
Select count(*) from Data2;

-- dataset for jharkhand and bihar

select * from Data1 where state in ('Jharkhand' , 'bihar')
select * from Data2 where state in ('Jharkhand' , 'bihar')

-- population of India

Select sum(population) Population from data2 

-- avg growth 

select avg(growth)*100 Avg_growth from Data1 
select state, avg(growth)*100 Avg_growth from Data1 group by state

-- avg sex ratio

select avg(sex_ratio)*100 Avg_Sex_Ratio from Data1
select state, round(avg(sex_ratio),0) Avg_Sex_Ratio from Data1 group by state

-- avg literacy rate

select avg(literacy) Avg_literacy from Data1 
select state, round(avg(literacy),0) Avg_literacy from Data1 group by state order by Avg_literacy Desc

select state,round(avg(literacy),0) avg_literacy_ratio from data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

-- top 3 state showing highest average growth ratio

select top 3 state, avg(growth)*100 Avg_growth from Data1 group by state order by Avg_growth Desc;

--bottom 3 state showing lowest sex ratio

select top 3 state, round(avg(sex_ratio),0) Avg_Sex_Ratio from Data1 group by state order by Avg_Sex_Ratio

-- top and bottom 3 states in literacy state using temp table

drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
  topstate float
)
insert into #topstates
select state, round(avg(literacy),0) avg_literacy from data1 
group by state order by avg_literacy desc;

select top 3 * from #topstates order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstate float
)
insert into #bottomstates
select state, round(avg(literacy),0) avg_literacy from data1 
group by state order by avg_literacy desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstate;

--union opertor

Select * from
(select top 3 * from #topstates order by #topstates.topstate desc) a
Union
Select * from
(select top 3 * from #bottomstates order by #bottomstates.bottomstate asc) b


-- states starting with letter a and b

select distinct state from data1 where lower(state) like 'a%' or lower(state) like 'b%'

select distinct state from data1 where lower(state) like 'a%' and lower(state) like '%m'


-- joining both table

Select a.district, a.state, a.Sex_ratio, b.Population
From Data1 a
Join Data2 b on a.district = b.district

--total males and females

Select d.state, sum(d.males) total_males, sum( d.females) total_females From (Select c.district, c.state, round(c.population/(1+c.sex_ratio),0) males, round((c.population*c.sex_ratio)/(1+c.sex_ratio),0) females
From (Select a.district, a.state, a.Sex_ratio/1000 Sex_ratio, b.Population
      From Data1 a
      Join Data2 b on a.district = b.district)c)d group by d.state

-- total literacy rate

Select d.state, sum(d.literate_pop) total_literate_pop, sum( d.illiterate_pop) total_illiterate_pop 
from (Select c.district, c.state, round(c.Literacy_ratio*c.population,0) literate_pop, round((1-c.Literacy_ratio)*c.population,0) illiterate_pop 
From(Select a.district, a.state, a.Literacy/100 Literacy_ratio, b.Population
From Data1 a
Join Data2 b on a.district = b.district)c)d group by d.state


-- population in previous census

select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population 
from(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population 
from(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population 
from(Select a.district, a.state, a.growth, b.Population
From Data1 a
Join Data2 b on a.district = b.district)d)e group by e.state)m


-- population vs area

select (g.total_area/g.previous_census_population) as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* 
from(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population 
from(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population 
from(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population 
from(Select a.district, a.state, a.growth, b.Population
From Data1 a
Join Data2 b on a.district = b.district)d)e group by e.state)m)n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from data2)z) r on q.keyy=r.keyy)g


--window 

--output top 3 districts from each state with highest literacy rate

Select a.* from(Select district, state, literacy, rank() over(partition by state order by literacy desc) rnk from data1) a
Where a.rnk in (1,2,3) order by state

Select district, state, literacy, row_number() over(partition by state order by literacy desc) row_no from data1