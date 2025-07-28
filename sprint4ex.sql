-- Level 1
-- Download the CSV files, study them and design a database with a star schema that
--  contains at least 4 tables from which you can perform the following queries:


create database Customers;

-- Dimension table company creation
create table company
(
company_id varchar(15) primary key,
company_name varchar(55),
phone  varchar(50),
email varchar(50),
country varchar(50),
website varchar(55)
);

SHOW VARIABLES LIKE 'secure_file_priv';

SET GLOBAL local_infile = 1;


   
   LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from company;

-- Dimension table credit_card creation
create table creditcards
(
id varchar(55) primary key,
user_id int ,
iban varchar(55),
pan varchar(55),
pin int,
cvv int,
track1 varchar(55),
track2 varchar(55),
expiring_date varchar(20)
);


LOAD DATA LOCAL INFILE 'C:/Users/sarav/Downloads/credit_cards.csv'
INTO TABLE creditcards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from creditcards;

-- Dimension table user  creation
create table user
(
id int primary key,
name varchar(55),
surname varchar(55),
phone varchar(35),
email varchar(55),
birth_date varchar(50),
country varchar(50),
city varchar(50),
postal_code varchar(50),
address varchar(50)
);

LOAD DATA LOCAL INFILE 'C:/Users/sarav/Downloads/american_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/sarav/Downloads/european_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from user;


-- create table transaction
create table transaction
(
id varchar(50) primary key,
card_id varchar(55),
business_id varchar(50) ,
tiempstamp timestamp,
amount decimal(10,2),
declined boolean,
product_id varchar(55),
user_id int,
lat float,
longtitude float,
foreign key (business_id) references company(company_id),
foreign key ( card_id) references creditcards(id),
foreign key(user_id) references user(id)
);

  
  LOAD DATA LOCAL INFILE 'C:/Users/sarav/Downloads/transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from transaction;

-- Exercise 1
-- Perform a subquery that shows all users with more than 80 transactions using at least 2 tables.


select *
from user where id in(
 select user_id
 from transaction
 where declined =0
 group by user_id
 having count(id)>80);
 
 
 -- Exercise 2
-- Shows the average amount per IBAN of credit cards in the company Donec Ltd, uses at least 2 tables.

select c.company_name,
cre.iban,
round(avg(t.amount),2) as Average_amount
from transaction t  
inner join company c on t.business_id = c.company_id
inner join creditcards cre on t.card_id = cre.id 
where
c.company_name like 'Donec Ltd' and
t.declined = 0
group by c.company_name,cre.iban;


-- Level 2
-- Create a new table that reflects the status of credit cards based on 
-- whether the last three transactions were declined and generate the following query:
create table creditcard_status as 
select 
t.card_id,
case
when sum(t. declined) = 3 then 'no active'
else 'active'
end as status
from(
select
card_id,
declined,
row_number() over( partition by card_id order by tiempstamp desc) as rownumber
 from transaction
 )t
where t.rownumber<=3
group by t.card_id; 

alter table creditcard_status
add constraint fk_creditcard_status
foreign key(card_id) references creditcards(id);


select * from creditcard_status;



-- Exercise 1
-- How many cards are active?

select count(card_id) as activecards
from creditcard_status 
where status = 'active';




-- Create a table with which we can join the data from the new products.csv file with the created database,  
-- taking into account that from transaction you have product_ids. Generate the following query:

-- Exercise 1
-- We need to know the number of times each product has been sold.

create table products
(
id varchar(20) primary key,
product_name varchar(40),
price varchar(20),
colour varchar(20),
weight float,
warehouse_id varchar(30)
);


LOAD DATA LOCAL INFILE 'C:/Users/sarav/Downloads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from products;

create table SingleproductID as
select 
    id,
    jt.product_id
    from
    transaction,
    json_table(
     concat( '[', product_id,']'),
    '$[*]' columns(
        product_id int path '$'
        )
                
        )as jt;
        
        
	select * from SingleproductID;
            
	alter table SingleproductID
	modify column product_id varchar(10);
            
	alter table SingleproductID
	add constraint fk_product_id
	foreign key(product_id) references products(id);
        
	alter table SingleproductID
	add constraint fk_id2
    foreign key(id) references transaction(id);
    
-- Exercise 1
-- We need to know the number of times each product has been sold.
    
   select p.product_name,count(s.product_id)as total,s.product_id
   from SingleproductID as s
   inner join products as p on p.id= s.product_id
   group by p.product_name,s.product_id
   order by total DESC;

	
    

