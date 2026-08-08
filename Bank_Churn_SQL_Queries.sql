select * from Bank_Churn_Clean



--Query 1 — Total Customers & Churn Rate

SELECT 
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned_Customers,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate_Percent
FROM Bank_Churn_Clean

--Query 2 — Churn by Geography

SELECT Geography,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate
FROM Bank_Churn_Clean
GROUP BY Geography
ORDER BY Churn_Rate DESC



--Query 3 — Churn by Gender


SELECT Gender,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate
FROM Bank_Churn_Clean
GROUP BY Gender
ORDER BY Churn_Rate DESC



--Query 4 — Churn by Age Group


SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Above 60'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate
FROM Bank_Churn_Clean
GROUP BY 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Above 60'
    END
ORDER BY Churn_Rate DESC



--Query 5 — Churn by Number of Products


SELECT NumOfProducts,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate
FROM Bank_Churn_Clean
GROUP BY NumOfProducts
ORDER BY Churn_Rate DESC


--Query 6 — Churn by Active Members

SELECT 
    CASE WHEN IsActiveMember = 1 
    THEN 'Active' ELSE 'Inactive' END AS Member_Status,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate
FROM Bank_Churn_Clean
GROUP BY IsActiveMember
ORDER BY Churn_Rate DESC


--Query 7 — Churn by Credit Score Group


SELECT 
    CASE 
        WHEN CreditScore < 400 THEN 'Poor (Below 400)'
        WHEN CreditScore BETWEEN 400 AND 579 THEN 'Fair (400-579)'
        WHEN CreditScore BETWEEN 580 AND 669 THEN 'Good (580-669)'
        WHEN CreditScore BETWEEN 670 AND 739 THEN 'Very Good (670-739)'
        ELSE 'Excellent (740+)'
    END AS Credit_Group,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Churned,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(10,2)) 
    AS Churn_Rate
FROM Bank_Churn_Clean
GROUP BY 
    CASE 
        WHEN CreditScore < 400 THEN 'Poor (Below 400)'
        WHEN CreditScore BETWEEN 400 AND 579 THEN 'Fair (400-579)'
        WHEN CreditScore BETWEEN 580 AND 669 THEN 'Good (580-669)'
        WHEN CreditScore BETWEEN 670 AND 739 THEN 'Very Good (670-739)'
        ELSE 'Excellent (740+)'
    END
ORDER BY Churn_Rate DESC


--Query 8 — High Risk Customers


SELECT TOP 10
    CustomerId,
    Surname,
    Age,
    Geography,
    Balance,
    CreditScore,
    NumOfProducts,
    CAST(Exited AS INT) AS Exited
FROM Bank_Churn_Clean
WHERE Exited = 1
    AND Balance > 100000
    AND Age > 40
ORDER BY Balance DESC


--Query 9 — Subquery — Above Average Balance

SELECT 
    CustomerId,
    Surname,
    Age,
    Geography,
    Balance,
    CreditScore
FROM Bank_Churn_Clean
WHERE Exited = 1
AND Balance > (
    SELECT AVG(Balance) 
    FROM Bank_Churn_Clean
)
ORDER BY Balance DESC


--Query 10 — Self Join


SELECT 
    a.Geography,
    COUNT(a.CustomerId) AS Active_Customers,
    COUNT(b.CustomerId) AS Inactive_Customers
FROM Bank_Churn_Clean a
LEFT JOIN Bank_Churn_Clean b 
    ON a.Geography = b.Geography
    AND b.IsActiveMember = 0
WHERE a.IsActiveMember = 1
GROUP BY a.Geography
ORDER BY Active_Customers DESC