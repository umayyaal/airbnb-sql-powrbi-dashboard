-- ============================================
-- Create a view that estimates monthly revenue
-- for each Airbnb listing by combining the
-- listing's nightly price with the number of
-- booked days in each month.
--
-- Note:
-- Revenue is an estimate based on the listing's
-- current price multiplied by booked days.
-- It does not account for discounts, cleaning
-- fees, taxes, dynamic pricing, or host-blocked
-- dates in the calendar dataset.
-- ============================================

DROP VIEW IF EXISTS vw_listings_monthly_revenue;
CREATE VIEW vw_listings_monthly_revenue AS
SELECT
	l.listing_id,
	l.city,
	l.neighbourhood,
	c.year_month,
	(l.price*c.booked_days) AS estimated_revenue
FROM listings_clean l 
INNER JOIN 
calendar_monthly_agg c 
on l.listing_id = c.listing_id;
	
