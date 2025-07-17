-- Level 1
-- Exercise 1
-- Your task is to design and create a table called "credit_card" that stores crucial details about credit cards.
-- The new table must be able to uniquely identify each card and establish an appropriate relationship with the other two 
--  tables ("transaction" and "company"). After creating the table, you will need to enter the information in the document called "credit_input_data".
-- Remember to show the diagram and provide a brief description of it.

CREATE TABLE IF NOT EXISTS credit_card
(
id varchar(15) primary key,
iban varchar(255),
pan varchar(255),
pin int,
cvv int,
expiring_date char(15) 
);

select * from credit_card;

alter table transaction
add constraint fk_credit_card_id
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);


-- Exercise 2
-- The Human Resources department has identified an error in the account number associated with the credit card with ID CcU-2938. 
-- he information that should be displayed for this record is: TR323456312213576817699999. Remember to show that the change was made.
select *
from credit_card;

select * from 
credit_card
where id = 'CcU-2938';

update credit_card
set iban = 'TR323456312213576817699999' 
where  id = 'CcU-2938';
select * from 
credit_card
where id = 'CcU-2938';


-- Exercise 3
-- In the "transaction" table, a new user is entered with the following information:
-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id	b-9999
-- user_id	9999
-- Latin	829,999
-- length	-117,999
-- amount	111.11
-- declined	0 

insert into
company(id)
values('b-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUES (
'108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', NULL,'111.11','0'
);

insert into 
  credit_card(id)
  values('CcU-9999');
  select * from transaction
  where id ='108B1D1D-5B23-A76C-55EF-C568E49A99DD';


-- Exercise 4
-- Human resources has asked you to delete the "pan" column from the credit_card table. Remember to show the change made.

alter table credit_card
drop column pan;


select * from credit_card;


-- Level 2
-- Exercise 1
-- Remove from the transaction table the record with ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD from the database.
select *
from transaction;

delete from transaction
where id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD ';

select *
from transaction where id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD ';


-- Exercise 2
-- The marketing department wants to have access to specific information to perform effective analysis and strategies.
--  It has been requested to create a view that provides key details about the companies and their transactions.
--  You will need to create a view called VistaMarketing that contains the following information: 
-- Company name. Contact phone number. Country of residence. Average purchase made by each company. 
-- Present the view created, ordering the data from highest to lowest average purchase.
create view VistaMarketing as
select 
com.company_name,com.phone,com.country,
round(avg(tran.amount),2) as Average_sales
from company as com
inner join transaction as tran on
com.id= tran.company_id
where tran.declined =0
group by com.id;
select * from VistaMarketing
order by Average_sales DESC;


-- Exercise 3
-- Filter the VistaMarketing view to show only companies that have their country of residence in "Germany"
select company_name  from VistaMarketing
where country= 'Germany';


-- Level 3
-- Next week you will have another meeting with the marketing managers. 
-- A colleague of your team made modifications to the database, but he does not remember how he did them. 
-- He asks you to help him leave the commands executed to obtain the following diagram:

-- create table user
CREATE TABLE IF NOT EXISTS user (
	id int PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);
select * from user;
select * from transaction;

SELECT DISTINCT user_id
FROM transaction
WHERE user_id IS NOT NULL
AND user_id NOT IN (SELECT id FROM user);

insert into
user(id)
values('9999');

-- add the foreign key to the transaction table and it refer the user table
alter table transaction
add constraint fk_user_id1
FOREIGN KEY(user_id)
REFERENCES user(id);

-- delete the website column in the companytable
select * from company;
alter table company
drop column website;


-- modify the  datatype of the column in the  credit_card table 
alter table credit_card
modify column pin varchar(4),
modify column expiring_date varchar(25);


-- add the column(fecha_actual) in the credit_card table 
alter table credit_card
add fecha_actual date default(current_date);

-- change the column name of the table
alter table user
change  email personal_email varchar(150);

-- change the table name 
rename table user to  data_user;

-- Exercise 2
-- The company also asks you to create a view called "TechnicalReport" that contains the following information:

-- Transaction ID
-- Username
-- User's last name
-- IBAN of the credit card used.
-- Name of the company of the transaction carried out.
-- Be sure to include relevant information from tables you will be familiar with, and use aliases to rename columns as needed.
-- Displays the results of the view, sorts the results in descending order based on the transaction ID variable.
create view TechnicalReport as
select
tran.id as Transaction_id,
u.name as Username,
u.surname as User_last_name,
cre.iban as Credit_card_iban,
com.company_name as Company_name,
com.country as Country_name 
from transaction  as tran 
inner join company as com on tran.company_id = com.id	
inner join   credit_card  as cre on cre.id = tran.credit_card_id
inner join data_user as u on  u.id = tran.user_id 
where declined=0
 ;
 
select * from TechnicalReport
order by Transaction_id desc;

