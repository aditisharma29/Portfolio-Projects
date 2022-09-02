Select * from Sharktank

-- total episodes

Select max(EpNo) as total_episodes from Sharktank
Select distinct(EpNo) from Sharktank

-- pitches 

Select count(distinct brand) from Sharktank
Select count(Deal) from Sharktank

--pitches converted

Select count(Amount_Invested_lakhs) as pitches_converted from Sharktank Where Amount_Invested_lakhs > 0 And Amount_Invested_lakhs IS NOT NuLL


select sum(a.converted_not_converted) funding_recieved, count(*) total_pitches from (
select Amount_Invested_lakhs , case when Amount_Invested_lakhs>0 then 1 else 0 end as converted_not_converted from Sharktank) a

-- total male

Select sum(male) total_male from Sharktank

-- total female

Select sum(female) total_female from Sharktank

--gender ratio

Select sum(female)/sum(male) gender_ratio from Sharktank

-- total invested amount

Select sum(Amount_Invested_lakhs) total_invested_amount from Sharktank

-- avg equity taken

select avg(a.equitytaken) from
(select * from Sharktank where equitytaken>0) a

--highest deal taken

Select max(Amount_Invested_lakhs) highest_deal_taken from Sharktank

--highest equity taken

Select max(equitytaken) highest_equity_taken from Sharktank

-- startups having at least women

Select count(brand) from Sharktank where female >= 1

select sum(a.female_count) 'startups having at least women' from (
select female,case when female>0 then 1 else 0 end as female_count from Sharktank) a

-- pitches converted having atleast one women

select sum(b.female_count) from(
select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from Sharktank where Deal ='No Deal')) a)b


-- avg team members

select avg(a.teammembers) from
(select * from Sharktank where teammembers>0) a
 
 select avg(teammembers) from Sharktank


-- amount invested per deal

select avg(a.amount_invested_lakhs) amount_invested_per_deal from
(select * from Sharktank where Amount_Invested_lakhs > 0 And Amount_Invested_lakhs IS NOT NuLL) a

-- avg age group of contestants

select avgage,count(avgage) cnt from Sharktank group by avgage order by cnt desc

-- location group of contestants

select distinct(location), count(location) cnt from Sharktank Where location is not null group by Location order by cnt desc 

-- sector group of contestants

select distinct(sector), count(sector) cnt from Sharktank Where sector is not null group by sector order by cnt desc 

--partner deals
 
select partners,count(partners) cnt from Sharktank  where partners <> '-' group by partners order by cnt desc

-- making the matrix


select * from Sharktank
select 'Ashnner' as keyy,count(ashneeramountinvested) from Sharktank where ashneeramountinvested is not null

select 'Ashnner' as keyy,count(ashneeramountinvested) from Sharktank where ashneeramountinvested is not null AND ashneeramountinvested = 0

SELECT 'Ashneer' as keyy,SUM(C.ASHNEERAMOUNTINVESTED),AVG(C.ASHNEEREQUITYTAKENP) 
FROM (SELECT * FROM Sharktank  WHERE ASHNEEREQUITYTAKENP!=0 AND ASHNEEREQUITYTAKENP IS NOT NULL) C


select m.keyy,m.total_deals_present,m.total_deals,n.total_amount_invested,n.avg_equity_taken from

(select a.keyy,a.total_deals_present,b.total_deals from(

select 'Ashneer' as keyy,count(ashneeramountinvested) total_deals_present from Sharktank where ashneeramountinvested is not null) a

inner join (
select 'Ashneer' as keyy,count(ashneeramountinvested) total_deals from Sharktank 
where ashneeramountinvested is not null AND ashneeramountinvested!=0) b 

on a.keyy=b.keyy) m

inner join 

(SELECT 'Ashneer' as keyy,SUM(C.ASHNEERAMOUNTINVESTED) total_amount_invested,
AVG(C.ASHNEEREQUITYTAKENP) avg_equity_taken
FROM (SELECT * FROM Sharktank  WHERE ASHNEEREQUITYTAKENP!=0 AND ASHNEEREQUITYTAKENP IS NOT NULL) C) n

on m.keyy=n.keyy

-- which is the startup in which the highest amount has been invested in each domain/sector




select c.* from 
(select brand,sector,amount_invested_lakhs,rank() over(partition by sector order by amountinvestedlakhs desc) rnk 

from Sharktank) c

where c.rnk=1