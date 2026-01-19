create database workforce_analytics;
use workforce_analytics;
show tables;

#Project: End-to-End Workforce Intelligence & Burnout Prediction System

#View sample data
select * from final_workforce_burnout_data;

#1️. Total number of employees
select count(*) from final_workforce_burnout_data;

#2. How many employees are in each burnout category?
select burnout_risk,count(*) as employee_count from final_workforce_burnout_data group by burnout_risk;

#3. Percentage of employees in each burnout category
select burnout_risk,count(*)*100.0 /(select count(*) from final_workforce_burnout_data)
as Percentage  from final_workforce_burnout_data group by burnout_risk ;

#4. List all HIGH burnout risk employees
select employee_id,employee_name,department,avg_working_hours,total_leaves
from final_workforce_burnout_data
where burnout_risk="High" order by avg_working_hours desc;

#5. Burnout risk distribution by department
select department,burnout_risk,count(*) as employee_count
from final_workforce_burnout_data
group by department,burnout_risk 
order by department;

#6. Departments with highest number of HIGH burnout employees
select department,count(*) as high_risk_count from final_workforce_burnout_data
where burnout_risk="High"
group by department
order by high_risk_count desc;

#7. Average working hours by department
select department,avg(avg_working_hours) as avg_hours
from final_workforce_burnout_data group by department;

#8. High burnout employees under each manager
select manager_id,count(*) as high_risk_employees
from final_workforce_burnout_data
where burnout_risk='High' group by manager_id
order by high_risk_employees desc;

#9. Manager-wise average performance 
select manager_id,avg(avg_performance) as avg_performance
from final_workforce_burnout_data group by manager_id;

#10. Employees with very high working hours
select employee_name,avg_working_hours from final_workforce_burnout_data
where avg_working_hours>10
order by avg_working_hours desc;

#11. Employees with high overtime days
select employee_name,overtime_days from final_workforce_burnout_data
order by overtime_days desc;

#12. Relationship between overtime and performance
select
	case
       when overtime_days>5 then "High Overtime"
       else "Low Overtime"
	end as overtime_category,
    avg(avg_performance) as avg_performance
from final_workforce_burnout_data 
group by overtime_category;

#13. Employees taking very few leaves
select employee_name,total_leaves
from final_workforce_burnout_data 
where total_leaves<2
order by total_leaves;

#14. Leave usage vs burnout risk
select burnout_risk,avg(total_leaves) as avg_leaves
from final_workforce_burnout_data
group by burnout_risk;

#15. Top performing employees
select employee_name,avg_performance
from final_workforce_burnout_data
order by avg_performance desc
limit 10;

#16. Performance by burnout category
select burnout_risk, avg(avg_performance) as avg_performance
from final_workforce_burnout_data
group by burnout_risk;

#17. Burnout risk by location
select location,burnout_risk,count(*) as count
from final_workforce_burnout_data
group by location,burnout_risk
order by location;
 
#18.Rank employees by working hours
select employee_name,avg_working_hours,
       RANK() OVER (order by avg_working_hours desc) as work_rank
from final_workforce_burnout_data;

 #19. Identify critical burnout employees (combined conditions)
 select employee_name,department,avg_working_hours,total_leaves,avg_performance
 from final_workforce_burnout_data
 where avg_working_hours>10
    AND total_leaves<2
    AND avg_performance<3.5;
