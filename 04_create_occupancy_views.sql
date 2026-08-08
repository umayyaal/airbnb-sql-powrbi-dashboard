-- ============================================
-- Script: 04_create_calendar_views.sql
-- Purpose: Create reporting views that calculate
--          monthly occupancy and availability
--          percentages for each Airbnb listing.
--          Views are built on calendar_monthly_agg.
-- ============================================

DROP VIEW IF EXISTS vw_calendar_occupancy;
CREATE VIEW vw_calendar_occupancy AS
SELECT 
    listing_id,
    `year_month`,
    city,
    available_days,
    booked_days,
    total_days,
    CASE 
        WHEN total_days = 0 THEN NULL
        ELSE (booked_days/total_days)*100.0
        END AS occupancy_rate
FROM calendar_monthly_agg;

DROP VIEW IF EXISTS vw_calendar_availability;
CREATE VIEW vw_calendar_availability AS
SELECT 
    listing_id,
    `year_month`,
    city,
    available_days,
    booked_days,
    total_days,
    CASE 
        WHEN total_days = 0 THEN NULL
        ELSE (available_days/total_days)*100.0
        END AS availability_rate
FROM calendar_monthly_agg;