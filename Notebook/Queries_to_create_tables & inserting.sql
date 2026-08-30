DROP TABLE IF EXISTS PRODUCTS
CREATE TABLE PRODUCTS(
    product	VARCHAR(30) PRIMARY KEY,
	series	VARCHAR(5),
	sales_price	NUMERIC(7,2)
)

SELECT * FROM PRODUCTS
select distinct product from products
-----------------------------

DROP TABLE IF EXISTS ACCOUNTS

CREATE TABLE ACCOUNTS(
    account	VARCHAR(50),
	sector	VARCHAR(25),
	year_established	INT,
	revenue	NUMERIC(10,2),
	employees	INT,
	office_location	VARCHAR(20),
	subsidiary_of	VARCHAR(20)
)

ALTER TABLE accounts
ADD CONSTRAINT accounts_pkey PRIMARY KEY(account)

ALTER TABLE accounts
ADD CONSTRAINT fk_accounts_subsidiary
FOREIGN KEY(subsidiary_of) REFERENCES accounts(account);

SELECT * FROM accounts
-----------------------------

CREATE TABLE SALES_PIPELINE(
	opportunity_id	VARCHAR(20),
	sales_agent	VARCHAR(25),
	product	VARCHAR(20),
	account	VARCHAR(50),
	deal_stage	VARCHAR(15),
	engage_date	DATE,
	close_date	DATE,
	close_value	NUMERIC(10,2)
)


ALTER TABLE sales_pipeline
ADD CONSTRAINT sales_pipeline_pkey PRIMARY KEY(opportunity_id)

ALTER TABLE sales_pipeline
ADD CONSTRAINT fk_pipeline_agent
FOREIGN KEY(sales_agent) REFERENCES sales_teams(sales_agent);

ALTER TABLE sales_pipeline
ADD CONSTRAINT fk_pipeline_product
FOREIGN KEY(product) REFERENCES products(product);

ALTER TABLE sales_pipeline
ADD CONSTRAINT fk_pipeline_account
FOREIGN KEY(account) REFERENCES accounts(account);

SELECT * FROM sales_pipeline
-----------------------------

CREATE TABLE SALES_TEAMS(
	sales_agent	VARCHAR(25),
	manager	VARCHAR(25),
	regional_office	VARCHAR(10)
)

ALTER TABLE sales_teams
ADD CONSTRAINT sales_teams_pkey PRIMARY KEY(sales_agent)

SELECT * FROM sales_teams

-- INSERTING RECORDS
COPY
SALES_TEAMS
FROM 'E:\Projects\Portfolio_Projects\SQL\CRM+Sales+Opportunities\sales_teams.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM SALES_TEAMS
-----------------------------

COPY
PRODUCTS
FROM 'E:\Projects\Portfolio_Projects\SQL\CRM+Sales+Opportunities\products.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM PRODUCTS
-----------------------------

COPY
ACCOUNTS
FROM 'E:\Projects\Portfolio_Projects\SQL\CRM+Sales+Opportunities\accounts.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM ACCOUNTS
-----------------------------

COPY 
SALES_PIPELINE
FROM 'E:\Projects\Portfolio_Projects\SQL\CRM+Sales+Opportunities\sales_pipeline.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM SALES_PIPELINE