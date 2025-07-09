select * from company;

select * from transaction;

-- List of countries that are generating sales
select  distinct com.country
from company as com
inner join transaction as tran
 on com.id = tran .company_id ;
 
 
 -- From how many countries are sales generated?
 select count( distinct com.country)
from company as com
inner join transaction as tran
 on com.id = tran .company_id ;
 
 
 
 -- Identify the company with the highest average sales.
 
 select   com.company_name ,  Avg(tran.amount) as sales
from company as com
inner join transaction as tran
 on com.id = tran .company_id
 group by com.company_name
 order by sales DESC
 limit 1
 ;
 
 
 -- It shows all transactions made by companies in Germany
 
 select *
 from transaction
 where company_id IN (
                     select id from company
                     where country  =  'Germany')
;                     
                  
 
                          
-- Lists companies that have made transactions for an amount greater than the average of all transactions.
 

select company_name from company 
where id in(
 select company_id from transaction where amount >(select avg(amount) from transaction) );
 
 
-- They will eliminate from the system companies that do not have registered transactions, provide a list of these companies.


select company_name
from company
where id NOT IN (select company_id from transaction);

-- Level2 
-- Exercise

-- Identifies the five days that generated the highest amount of revenue for your business from sales.
-- It shows the date of each transaction along with the total sales.

select *  from company;
select * from transaction;

select date(tran.timestamp) as Date_amount ,sum(tran.amount) as Total
from transaction as tran 
inner join company as com on
tran.company_id =com.id 
group by Date_amount
order by Total DESC
limit 5
;


-- Exercise 2
-- What is the average sales by country? Presents the results sorted from highest to lowest average.

select com.country,avg(amount) as Totalsales 
from transaction as tran
inner join company as com on 
tran.company_id = com.id
group by com.country
order by Totalsales Desc 

;



-- Exercise 3
-- In your company, a new project is being considered to launch some advertising campaigns to 
-- compete with the company "Non Institute". To do this, you are asked for a list of all  
-- the transactions carried out by companies that are located in the same country as this company.

-- Show the list applying JOIN and subqueries.

 
select *,com.country
from transaction as tran
inner join company as com 
on com.id= tran.company_id
where com.country = 
(select country from company as com 
where company_name ='Non Institute'
 );
 
 -- Show the list applying only subqueries.

select *  from transaction as tran
where tran.company_id in (select id from company as com 
where country =(select country from company where company_name ='Non Institute') 
 );
 
 -- Level3 
 -- Exercise
 -- Exercise 1
-- It presents the name, telephone number, country, date and amount of those companies that 
-- carried out transactions with a value between 350 and 400 euros and on one of these dates: 
-- April 29, 2015, July 20, 2018 and March 13, 2024. Sort the results from highest to lowest amount.


select * from company ;
select * from transaction;


select  com. company_name,com.phone,com.country,tran.timestamp,tran.amount
from transaction  as tran
inner join company as com on
com.id = tran.company_id
where amount between 350 and 400  and (date(tran.timestamp) = '2015-04-29' or date(tran.timestamp) ='2018-07-20' or 
date(tran.timestamp)='2024-03-13')
order by amount DESC
;


-- Exercise 2
-- We need to optimize the allocation of resources and it will depend on the operational 
-- capacity required, so they ask you for information on the number of transactions 
-- that companies carry out, but the human resources department is demanding and wants a
--  list of companies where you specify whether they have more than 400 transactions or less.


select * from company;
select * from transaction;

select count(tran.amount),com.company_name,
 CASE
   when count(tran.amount)> 400 then 'More than 400'
   else '400 or less'
   end as Max_or_Min
   from 
 transaction as tran
 inner join company as com
 on tran.company_id = com.id
 group by com.company_name;
 
