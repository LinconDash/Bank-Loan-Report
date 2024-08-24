select * from financial_loan_data;

-- KPIs
-- Total Loan Applications
select count(id) as Total_Loan_Applications from financial_loan_data;

-- MTD Loan Applications
select count(id) as Total_Loan_Applications from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data); 

-- PMTD Loan Applications
select count(id) as Total_Loan_Applications from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) - 1 from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data); 

-- Total Funded Amount
select SUM(loan_amount) as Total_Funded_Amount from financial_loan_data;

-- MTD Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data); 

-- PMTD Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) - 1 from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data); 

-- Total Amount Received 
select SUM(total_payment) as Total_Amount_Received from financial_loan_data;

-- MTD Total Amount Received 
select SUM(total_payment) as Total_Amount_Received from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data);

-- PMTD Total Amount Received 
select SUM(total_payment) as Total_Amount_Received from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) - 1 from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data);

-- Avg. interest rate
select round(AVG(int_rate) * 100, 3) as Avg_interest_rate from financial_loan_data;

-- MTD interest rate
select round(AVG(int_rate) * 100, 3) as Avg_interest_rate from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data);

-- PMTD interest rate
select round(AVG(int_rate) * 100, 3) as Avg_interest_rate from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) - 1 from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data);

-- Average DTI
select round(AVG(dti) * 100, 3) as Avg_DTI from financial_loan_data;

-- MTD Average DTI
select round(AVG(dti) * 100, 3) as Avg_DTI from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data);

-- PMTD Average DTI
select round(AVG(dti) * 100, 3) as Avg_DTI from financial_loan_data
where MONTH(issue_date) = (select max(month(issue_date)) - 1 from financial_loan_data) and YEAR(issue_date) = (select max(year(issue_date)) from financial_loan_data);

-- Good Loan Issued 
-- Good Loan Percentage
select 
	(count(case when loan_status = 'Fully Paid' or loan_status = 'Current' THEN id END) * 100.0) / count(id) AS Good_Loan_Percentage
from financial_loan_data;

-- Good Loan Applications
select count(id) as Good_Loan_Applications
from financial_loan_data where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good Loan Funded Amount
select sum(loan_amount) as Good_Loan_Funded_Amount
from financial_loan_data where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good Loan Recieved Amount
select sum(total_payment) as Good_Loan_Recieved_Amount
from financial_loan_data where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Amount Gained
select sum(total_payment) - sum(loan_amount) as Amount_Gained,
cast(sum(total_payment) - sum(loan_amount) as decimal(18,2)) / cast(sum(loan_amount) as decimal(18,2)) * 100 as Percent_Amount_Gained
from financial_loan_data where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Bad Loan Issued
-- Bad Loan Percentage
select 
	(count(case when loan_status = 'Charged Off' THEN id END) * 100.0) / count(id) AS Good_Loan_Percentage
from financial_loan_data;

-- Bad Loan Applications
select count(id) as Bad_Loan_Applications
from financial_loan_data where loan_status = 'Charged Off';

-- Bad Loan Funded Amount
select sum(loan_amount) as Bad_Loan_Funded_Amount
from financial_loan_data where loan_status = 'Charged Off';

-- Bad Loan Recieved Amount
select sum(total_payment) as Bad_Loan_Recieved_Amount
from financial_loan_data where loan_status = 'Charged Off';

-- Amount Lost
select sum(loan_amount) - sum(total_payment) as Amount_Lost,
cast(sum(loan_amount) - sum(total_payment) as decimal(18,2)) / cast(sum(loan_amount) as decimal(18,2)) * 100 as Percent_Amount_Lost
from financial_loan_data where loan_status = 'Charged Off';

-- Loan Status Analysis 
select
    loan_status,
    count(id) as LoanCount,
    sum(total_payment) as Total_Amount_Received,
    sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) - sum(loan_amount) as Total_Gained_or_Lost,
    avg(int_rate * 100) as Avg_Interest_Rate,
    avg(dti * 100) as Avg_DTI
from financial_loan_data
group by loan_status;

-- MTD Loan Status Analysis 
select 
	loan_status, 
	SUM(total_payment) as MTD_Total_Amount_Received, 
	SUM(loan_amount) as MTD_Total_Funded_Amount,
	sum(total_payment) - sum(loan_amount) as Total_Gained_or_Lost,
	avg(int_rate * 100) as MTD_Avg_Interest_Rate,
    avg(dti * 100) as MTD_Avg_DTI
from financial_loan_data
where month(issue_date) = (select max(month(issue_date)) from financial_loan_data)
group by loan_status;

-- Monthly-wise Report
select 
	month(issue_date) as Month_Munber, 
	datename(month, issue_date) as Month_name, 
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
	sum(total_payment) - sum(loan_amount) as Total_Gained_or_Lost
from financial_loan_data
group by month(issue_date), datename(month, issue_date)
order by month(issue_date)

-- Statewise Analysis
select 
	d.address_state as State_Postal_Code, 
	s.State as State_Name,
	count(d.id) as Total_Loan_Applications,
	sum(d.loan_amount) as Total_Funded_Amount,
	sum(d.total_payment) as Total_Amount_Received,
	sum(d.total_payment) - sum(d.loan_amount) as Total_Amount_Gained_or_Lost
from financial_loan_data d inner join states_names s on s.Abbreviation = d.address_state
group by d.address_state, s.State
order by d.address_state;

-- Term Analysis
select 
	term as Term, 
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
	sum(total_payment) - sum(loan_amount) as Total_Amount_Gained
from financial_loan_data
group by term
order by term;

-- Employee Length Analysis
select 
	emp_length as Employee_Length, 
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
	sum(total_payment) - sum(loan_amount) as Total_Amount_Gained
from financial_loan_data
group by emp_length
order by emp_length;

-- Purpose Analysis
select 
	purpose as Purpose, 
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
	sum(total_payment) - sum(loan_amount) as Total_Amount_Gained
from financial_loan_data
group by purpose
order by purpose;

-- Home Ownership Analysis
select 
	home_ownership as Home_ownership, 
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
	sum(total_payment) - sum(loan_amount) as Total_Amount_Gained
from financial_loan_data
group by home_ownership
order by home_ownership;

-- Grade Analysis
select 
	grade as Grade, 
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Amount_Received,
	sum(total_payment) - sum(loan_amount) as Total_Amount_Gained
from financial_loan_data
group by grade
order by grade;



