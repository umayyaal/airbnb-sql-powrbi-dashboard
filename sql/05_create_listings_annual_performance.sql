-- ============================================
-- Script: 05_create_listing_annual_summary_view.sql
-- Purpose: Create a reporting view that combines
--          listing details with annual average
--          occupancy and availability metrics.
--          The view is intended for dashboarding
--          and listing-level performance analysis.
-- ============================================

DROP VIEW IF EXISTS vw_listings_annual_occupancy;
CREATE VIEW vw_listings_annual_occupancy AS
SELECT
	l.listing_id,
	l.city,
	l.room_type,
	l.price,
	l.neighbourhood,
	AVG((c.booked_days/c.total_days)*100) AS annual_avg_occupancy_rate,
	AVG((c.available_days/c.total_days)*100) AS annual_avg_availability_rate	
FROM listings_clean l 
INNER JOIN 
calendar_monthly_agg c
on l.listing_id = c.listing_id
group by
	l.listing_id,
	l.city,
	l.room_type,
	l.price,
	l.neighbourhood;



