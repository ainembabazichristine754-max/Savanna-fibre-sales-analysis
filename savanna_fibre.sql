
USE savanna_fibre;
SELECT 
    COUNT(*) as total_records,
    MIN(Date) as start_date,
    MAX(Date) as end_date,
    SUM(Payment_UGX) as total_revenue,
    ROUND(AVG(Payment_UGX), 0) as avg_daily_revenue
FROM savannafibre;

SELECT 
    COUNT(*) as issues_found
FROM savannafibre 
WHERE Payment_UGX IS NULL OR Date IS NULL;

SELECT 
    SUM(Payment_UGX) AS total_revenue_UGX,
    ROUND(AVG(Payment_UGX), 0) AS avg_daily_revenue_UGX,
    COUNT(*) AS total_days
FROM savannafibre;

SELECT 
    Package,
    SUM(Payment_UGX) AS revenue_UGX,
    COUNT(*) as transactions,
    ROUND(SUM(Payment_UGX)*100.0 / SUM(SUM(Payment_UGX)) OVER(), 2) AS revenue_pct
FROM savannafibre
GROUP BY Package
ORDER BY revenue_UGX DESC;

SELECT 
    Speed_Mbps,
    SUM(Payment_UGX) AS revenue_UGX,
    COUNT(*) as customers
FROM savannafibre
GROUP BY Speed_Mbps
ORDER BY revenue_UGX DESC;

SELECT 
    MONTHNAME(Date) as month,
    MONTH(Date) as month_num,
    SUM(Payment_UGX) AS monthly_revenue
FROM savannafibre
GROUP BY MONTH(Date)
ORDER BY month_num;

SELECT 
    SUM(New_Customers) AS total_new,
    SUM(Renewals) AS total_renewals,
    ROUND(SUM(Renewals)*100.0/(SUM(New_Customers)+SUM(Renewals)), 2) AS retention_rate_pct
FROM savannafibre;

SELECT 
    Date, Package, Payment_UGX, total_customers
FROM savannafibre
ORDER BY Payment_UGX DESC
LIMIT 10;

SELECT 
    Date,
    total_customers,
    LAG(total_customers) OVER (ORDER BY Date) as previous_day,
    total_customers - LAG(total_customers) OVER (ORDER BY Date) as daily_growth
FROM savannafibre
ORDER BY Date;

CREATE OR REPLACE VIEW vw_kpis AS
SELECT 
    SUM(Payment_UGX) AS total_revenue,
    ROUND(AVG(Payment_UGX), 0) AS avg_daily,
    SUM(New_Customers) AS new_customers,
    SUM(Renewals) AS renewals
FROM savannafibre;

CREATE OR REPLACE VIEW vw_packages AS
SELECT 
    Package,
    SUM(Payment_UGX) AS revenue,
    SUM(New_Customers) + SUM(Renewals) AS total_customers
FROM savannafibre
GROUP BY Package;

CREATE OR REPLACE VIEW vw_monthly AS
SELECT 
    YEAR(Date) year,
    MONTHNAME(Date) month,
    SUM(Payment_UGX) revenue
FROM savannafibre
GROUP BY YEAR(Date), MONTH(Date);