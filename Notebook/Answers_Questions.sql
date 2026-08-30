--Beginner Questions:
--1.	How many total opportunities are in the pipeline, and how many are Won, Lost, and still open?
SELECT COUNT(DISTINCT opportunity_id) as total_opportunities,
       (SELECT COUNT(deal_stage) from sales_pipeline where deal_stage = 'Won') as won_opportunities,
	   (select count(deal_stage) from sales_pipeline where deal_stage = 'Lost') as Lost_opportunities,
	   (select count(deal_stage) from sales_pipeline where deal_stage = 'Prospecting' or 
	   deal_stage = 'Engaging') as Still_open
from sales_pipeline

--2.	What is the total and average revenue generated from Won deals?
SELECT  deal_stage,
		SUM(CLOSE_VALUE) AS Total_revenue,
		round(avg(close_value),2) as average_revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY deal_stage

--select close_value from sales_pipeline where deal_stage = 'Lost'

-- select * from sales_pipeline
-- select * from sales_teams

--3.	How many opportunities does each sales agent have?
SELECT  st.sales_agent,
		COUNT(sp.OPPORTUNITY_ID) AS OPPORTUNITIES
FROM sales_pipeline sp
left join sales_teams st
on st.sales_agent = sp.sales_agent
where st.sales_agent is not null
group by st.sales_agent
order by opportunities desc

--or
select  sales_agent,
		count(opportunity_id) as opportunities
from sales_pipeline
group by sales_agent
order by opportunities desc

--4.	Which product generated the most total revenue?
select product,
       sum(close_value) as total_revenue
from sales_pipeline
group by product
order by total_revenue desc
limit 1

--select distinct deal_stage from sales_pipeline

--Intermediate Questions:
--5 What is the win rate among the close deals for each sales agent?
WITH WIN_AGENT AS(
    select sales_agent, 
	   count(opportunity_id) as won_deals
    from sales_pipeline
    where deal_stage = 'Won'
    group by sales_agent
), win_LOST_AGENT AS(
	select sales_agent, 
	        count(opportunity_id) as win_lost_deals
	from sales_pipeline
	where deal_stage IN('Lost','Won')
	group by sales_agent
   )
	SELECT wa.sales_agent AS sales_agent,
	   wa.won_deals AS won_deals,
	   wla.win_lost_deals AS won_lost_deals,
	   ROUND((wa.won_deals *100.0)/wla.win_lost_deals,1) || '%' AS win_rate
	FROM WIN_AGENT WA
	JOIN win_LOST_AGENT wla
	ON wla.SALES_AGENT = WA.SALES_AGENT
	ORDER BY wla.win_lost_deals desc, win_rate desc

--SELECT ROUND((10*100.0)/20,2)

--6.	Bucket every Won deal into "Small," "Medium," and "Large" based on its value.

select close_date,
       deal_stage,
       close_value,
       case when close_value <=5000 then 'Small_Deal'
	   when (close_value >5000 and close_value <=15000) then 'Medium_Deal'
	   when close_value >15000 then 'Large_Deal'
	   end as Deal_Size
FROM sales_pipeline
where deal_stage  = 'Won'
order by close_date asc

--7.	Which sectors generate the most Won revenue?
SELECT  a.sector,
		sp.deal_stage,
		sum(sp.close_value) as total_revenue
from sales_pipeline sp
join accounts a
on sp.account = a.account
where a.sector is not null and sp.deal_stage = 'Won'
group by a.sector,
         sp.deal_stage
order by total_revenue desc
limit 1


--8 List every deal where the actual close value was higher than the product's list price.
SELECT sp.opportunity_id,
       sp.product,
	   p.sales_price as list_price,
	   sp.close_value as sold_price
FROM sales_pipeline sp
LEFT JOIN products p
ON sp.product = p.product
WHERE p.sales_price is not null and sp.close_value > p.sales_price
order by sold_price desc

--9 Which accounts have never had a single Won deal?

SELECT account
FROM sales_pipeline
where account not in(SELECT DISTINCT ACCOUNT
				     FROM SALES_PIPELINE
					 WHERE DEAL_STAGE = 'Won'
	                )

/*10.Which sales agents generated closed revenue above the average revenue across all sales agents?*/
-- select avg(close_value) from sales_pipeline (overall average)

/*the following query first calculate the total revenue by sales agents and then it filters out those agents whose
are higher than the average revenue of all the agents*/
WITH agent_avg_revenue AS(
   SELECT SALES_AGENT,
   		  SUM(CLOSE_VALUE) AS total_revenue
   FROM sales_pipeline
   GROUP BY sales_agent
) SELECT sales_agent,
	     total_revenue
  FROM agent_avg_revenue
  WHERE total_revenue > (select avg(total_revenue) from agent_avg_revenue)
  ORDER BY total_revenue desc
  
--11.	For each subsidiary account, show its own sector next to its parent company's sector.
WITH subsidiary_sector AS(
	  select  account as subsidiary_company,
			  sector as subsidiary_comp_sector,
			  subsidiary_of as parent_company
	  from accounts
	  where subsidiary_of is not null
), parent_sector AS(
	 SELECT account as parent_company,
	        sector as parent_comp_sector
	from accounts
	where account in(select distinct subsidiary_of from accounts where subsidiary_of is not null)
	)
SELECT ss.subsidiary_company,
	   ps.parent_company,
	   ps.parent_comp_sector,
	   ss.subsidiary_comp_sector
FROM parent_sector ps
inner join subsidiary_sector ss
ON ss.parent_company = ps.parent_company

--select * from products

--Advanced Questions:

--12.	What is the average sales cycle length, broken down by product series?
--select distinct series from products

    select p.series as product_series,
           date_trunc('day',avg(age(sp.close_date,sp.engage_date))) as avg_cycle
	from sales_pipeline sp
	left join products p
	on p.product = sp.product
	where p.series is not null and sp.deal_stage in('Won','Lost')
	group by p.series
    order by avg_cycle desc
	
--or 
    select p.series as product_series,
           round(avg(close_date - engage_date),0) || ' Days' as avg_cycle
	from sales_pipeline sp
	left join products p
	on p.product = sp.product
	where p.series is not null and sp.deal_stage in('Won','Lost')
	group by p.series
	order by avg_cycle desc


--13.	Rank each sales agent's total Won revenue within their own manager's team.
SELECT st.sales_agent,
       st.manager,
       sum(sp.close_value) as total_revenue
from sales_pipeline sp
left join sales_teams st
on sp.sales_agent = st.sales_agent
where st.sales_agent is not null and sp.deal_stage = 'Won'
group by st.sales_agent,
       st.manager
order by manager, total_revenue desc 

--select distinct sales_agent from sales_pipeline where deal_stage = 'Lost'

--14.	For each account, find their very first opportunity.
SELECT account,
       min(engage_date) as first_opportunity_date
FROM sales_pipeline
where account is not null   -- to filter out nulls present in account in sales_pipeline
group by account

-- select count(distinct account) from sales_pipeline where account is not null


--15.	Calculate each agent's total revenue, then rank agents within their regional office.
select st.regional_office,
       st.sales_agent,
	   sum(sp.close_value) as total_revenue,
	   dense_rank() over(partition by st.regional_office order by sum(sp.close_value) desc) as agents_rank
from sales_pipeline sp
left join sales_teams st
on sp.sales_agent = st. sales_agent
where st.sales_agent is not null
group by st.regional_office,
       st.sales_agent

-- select distinct regional_office from sales_teams

/*16.	Calculate the monthly won revenue trend, showing for each month : the total revenue closed, the 
  month-over-month growth percentage, and the running cumulative revenue total up to that month.*/
SELECT month,
       revenue AS current_revenue,
	   SUM(revenue) OVER(ORDER BY month) AS cummulative_revenue,
	   LAG(revenue,1,0) OVER(ORDER BY month) AS previous_month_revenue,
       ROUND((revenue - LAG(revenue,1,0) OVER(ORDER BY month)) / 
	    NULLIF(LAG(revenue,1,0) OVER(ORDER BY month),0),2) || '%'
	   AS mom_change
 FROM(	   
	 SELECT DATE_PART('MONTH',close_date) as month,
	       deal_stage,
	       sum(close_value) as revenue
	 FROM sales_pipeline
	 where deal_stage = 'Won'
	 GROUP BY DATE_PART('MONTH',close_date), deal_stage
	 ORDER BY month asc
  )

--17. Calculate total won revenue by quarter, along with quarter over quarter growth percentage.
--select distinct ('Q' || extract(quarter from close_date)) from sales_pipeline

SELECT quarter ,
       revenue AS Won_revenue,
	   LAG(revenue,1,0) OVER(ORDER BY quarter) AS previous_quarter_revenue,
       ROUND((revenue - LAG(revenue,1,0) OVER(ORDER BY quarter)) / 
	    NULLIF(LAG(revenue,1,0) OVER(ORDER BY quarter),0),2) || '%'
	   AS QoQ_change
 FROM(	   
	 SELECT 'Q' || DATE_PART('QUARTER',close_date) as Quarter,
	       deal_stage,
	       sum(close_value) as revenue
	 FROM sales_pipeline
	 where deal_stage = 'Won'
	 GROUP BY 'Q' || DATE_PART('QUARTER',close_date), deal_stage
	 ORDER BY quarter asc
  )

/*18. For each regional office, show total Won revenue, win rate, average sales cycle length, 
and the top-performing agent in that region — all in one query.*/
WITH agent_rnk_revenue AS(
  SELECT st.regional_office,
         st.sales_agent,
         sum(sp.close_value) as agent_revenue,
		 ROW_NUMBER() over(partition by st.regional_office order by sum(sp.close_value) desc) as rnk
  FROM sales_pipeline sp
  left join sales_teams st
  on st.sales_agent = sp.sales_agent
  where st.regional_office is not null and deal_stage = 'Won'
  group by st.regional_office,
         st.sales_agent
 order by st.regional_office
 ), 
regional_revenue_cycle AS(
  SELECT st.regional_office,
        sum(sp.close_value) as regional_revenue,
		round(avg(sp.close_date - sp.engage_date),0) || ' days' as average_sales_length
  from sales_pipeline sp
  left join sales_teams st
  on st.sales_agent = sp.sales_agent
  where st.regional_office is not null and sp.deal_stage in('Won','Lost')
  group by st.regional_office
 ), won_rg_office AS(
    select st.regional_office, 
        count(sp.deal_stage) as won_deals
	from sales_pipeline sp
	left join sales_teams st
	on st.sales_agent = sp.sales_agent
	where st.regional_office is not null and sp.deal_stage = 'Won'
	group by st.regional_office
), won_LOST_office AS(
	select st.regional_office, 
        count(sp.deal_stage) as won_lost_deals
	from sales_pipeline sp
	left join sales_teams st
	on st.sales_agent = sp.sales_agent
	where st.regional_office is not null and sp.deal_stage IN('Won','Lost')
	group by st.regional_office
   )
   SELECT arr.regional_office,
         rrc.regional_revenue,
		 ROUND(((wro.won_deals * 100.0) /wlo.won_lost_deals) ,2) || '%' AS win_rate,
		 rrc.average_sales_length,
		 arr.sales_agent AS Best_agent
 FROM agent_rnk_revenue arr
 INNER JOIN regional_revenue_cycle rrc ON rrc.regional_office = arr.regional_office
 INNER JOIN won_rg_office wro ON wro.regional_office = arr.regional_office
 INNER JOIN won_LOST_office wlo ON wlo.regional_office = arr.regional_office
 WHERE arr.rnk <=1

 