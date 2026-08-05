-- ============================================
-- Script: 03_create_calendar_monthly_agg.sql
-- Purpose: Clean and aggregate daily calendar
--          data into monthly listing-level
--          metrics for occupancy and
--          availability analysis.
-- ============================================

DROP TABLE IF EXISTS calendar_monthly_agg;

CREATE TABLE calendar_monthly_agg AS
SELECT
    CAST(listing_id AS UNSIGNED) AS listing_id,
    DATE_FORMAT(CAST(date_value AS DATE), '%Y-%m') AS `year_month`,
    CAST(city AS CHAR(50)) AS city,

    SUM(CASE
            WHEN available = 't' THEN 1
            ELSE 0
        END) AS available_days,

    SUM(CASE
            WHEN available = 'f' THEN 1
            ELSE 0
        END) AS booked_days,

    COUNT(*) AS total_days

FROM calendar_staging

WHERE listing_id IN (SELECT listing_id FROM listings_clean)

GROUP BY
    CAST(listing_id AS UNSIGNED),
    DATE_FORMAT(CAST(date_value AS DATE), '%Y-%m'),
    CAST(city AS CHAR(50));