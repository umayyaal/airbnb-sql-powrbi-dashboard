-- ============================================
-- Create a view that ranks Airbnb listings
-- within each city based on their annual
-- average occupancy rate.
--
-- DENSE_RANK() is used so that listings with
-- the same occupancy rate receive the same
-- rank, without leaving gaps in the ranking.
-- ============================================

DROP VIEW IF EXISTS vw_rank_listings_occupancy;
CREATE VIEW vw_rank_listings_occupancy AS
SELECT
	listing_id,
	city,
	neighbourhood,
	annual_avg_occupancy_rate,
	DENSE_RANK() OVER(PARTITION BY city ORDER BY annual_avg_occupancy_rate DESC) as occupancy_based_rank
FROM vw_listings_annual_occupancy;