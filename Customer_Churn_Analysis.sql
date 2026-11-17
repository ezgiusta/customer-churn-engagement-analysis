
-- =========================================
-- CUSTOMER CHURN & ENGAGEMENT ANALYSIS
-- =========================================

-- Business Problem:
-- Identify customer segments with higher churn
-- rates and examine engagement differences
-- to inform customer retention strategies.


-- 01. DATA QUALITY CHECK
-- How many records and missing skip_rate values?

SELECT
    COUNT(*) AS total_users,
    COUNT(*) - COUNT(skip_rate) AS missing_skip_rate
FROM dbo.customer_churn_data;


-- 02. OVERALL CUSTOMER CHURN
-- What percentage of users churned?

SELECT
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    SUM(CASE WHEN churned = 0 THEN 1 ELSE 0 END)
        AS retained_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data;


-- 03. CHURN BY SUBSCRIPTION TYPE
-- Which subscription type has higher churn?

SELECT
    subscription_type,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data
GROUP BY subscription_type
ORDER BY churn_rate_pct DESC;


-- 04. CHURN BY COUNTRY
-- Which countries have higher churn rates?

SELECT
    country,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data
GROUP BY country
ORDER BY churn_rate_pct DESC;


-- 05. CHURN BY DEVICE
-- Does churn differ by device type?

SELECT
    device,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data
GROUP BY device
ORDER BY churn_rate_pct DESC;


-- 06. CHURN BY AGE GROUP
-- Which age groups have higher churn?

SELECT
    CASE
        WHEN age BETWEEN 19 AND 29 THEN '19-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 44 THEN '40-44'
        ELSE 'Other'
    END AS age_group,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data
GROUP BY
    CASE
        WHEN age BETWEEN 19 AND 29 THEN '19-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 44 THEN '40-44'
        ELSE 'Other'
    END
ORDER BY age_group;


-- 07. CHURN BY FAVORITE GENRE
-- Does churn differ by music preference?

SELECT
    favorite_genre,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data
GROUP BY favorite_genre
ORDER BY churn_rate_pct DESC;


-- 08. LISTENING BEHAVIOR BY CHURN STATUS
-- Do churned users listen less?

SELECT
    CASE
        WHEN churned = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS churn_status,
    COUNT(*) AS total_users,
    ROUND(AVG(CAST(daily_minutes AS FLOAT)), 2)
        AS avg_daily_minutes
FROM dbo.customer_churn_data
GROUP BY churned;


-- 09. SKIP RATE BY CHURN STATUS
-- Do churned users skip more tracks?

SELECT
    CASE
        WHEN churned = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS churn_status,
    COUNT(skip_rate) AS users_with_skip_data,
    ROUND(AVG(skip_rate), 3) AS avg_skip_rate
FROM dbo.customer_churn_data
GROUP BY churned;


-- 10. CHURN BY AD-CLICK ACTIVITY
-- Is ad-click activity associated with churn?

SELECT
    ads_clicked,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        AS churned_users,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.customer_churn_data
GROUP BY ads_clicked
ORDER BY ads_clicked;
