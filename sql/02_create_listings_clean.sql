-- ============================================
-- Script: 02_create_listings_clean.sql
-- Purpose: Cast and clean listings_staging into a properly
--          typed table ready for analysis
-- Uses defensive REGEXP guards on all numeric/date casts
-- since source data has inconsistent formatting in places
-- ============================================

USE airbnb_project;

DROP TABLE IF EXISTS listings_clean;

CREATE TABLE listings_clean AS
SELECT
    CAST(id AS UNSIGNED) AS listing_id,
     CAST(city AS char(25)) AS city,
    name,
    CAST(host_id AS UNSIGNED) AS host_id,
    host_name,
    CASE WHEN hosts_time_as_host_years REGEXP '^[0-9]+$' THEN CAST(hosts_time_as_host_years AS UNSIGNED) ELSE NULL END AS host_experience_years,
	CASE WHEN host_is_superhost = 't' THEN 1 ELSE 0 END AS is_superhost,
    host_neighbourhood,
    CAST(neighbourhood_cleansed AS CHAR(200)) AS neighbourhood,
    neighbourhood_group_cleansed AS neighbourhood_group,
    CASE WHEN latitude REGEXP '^-?[0-9]+(\\.[0-9]+)?$' THEN CAST(latitude AS DECIMAL(10,6)) ELSE NULL END AS latitude,
    CASE WHEN longitude REGEXP '^-?[0-9]+(\\.[0-9]+)?$' THEN CAST(longitude AS DECIMAL(10,6)) ELSE NULL END AS longitude,
    property_type,
    CAST(room_type AS char(15)) AS room_type,
    CASE WHEN accommodates REGEXP '^[0-9]+$' THEN CAST(accommodates AS UNSIGNED) ELSE NULL END AS accommodates,
    CASE WHEN bathrooms REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(bathrooms AS DECIMAL(4,1)) ELSE NULL END AS bathrooms,
    CASE WHEN bedrooms REGEXP '^[0-9]+$' THEN CAST(bedrooms AS UNSIGNED) ELSE NULL END AS bedrooms,
    CASE WHEN beds REGEXP '^[0-9]+$' THEN CAST(beds AS UNSIGNED) ELSE NULL END AS beds,
    CASE WHEN REPLACE(REPLACE(price, '$', ''), ',', '') REGEXP '^[0-9]+(\\.[0-9]+)?$' 
         THEN CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS DECIMAL(10,2)) ELSE NULL END AS price,
    CASE WHEN minimum_nights REGEXP '^[0-9]+$' THEN CAST(minimum_nights AS UNSIGNED) ELSE NULL END AS minimum_nights,
    CASE WHEN maximum_nights REGEXP '^[0-9]+$' THEN CAST(maximum_nights AS UNSIGNED) ELSE NULL END AS maximum_nights,
    CASE WHEN instant_bookable = 't' THEN 1 ELSE 0 END AS instant_bookable,
    CASE WHEN number_of_reviews REGEXP '^[0-9]+$' THEN CAST(number_of_reviews AS UNSIGNED) ELSE NULL END AS number_of_reviews,
    CASE WHEN review_scores_rating REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(review_scores_rating AS DECIMAL(3,2)) ELSE NULL END AS review_scores_rating,
    CASE WHEN review_scores_cleanliness REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(review_scores_cleanliness AS DECIMAL(3,2)) ELSE NULL END AS review_scores_cleanliness,
    CASE WHEN review_scores_location REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(review_scores_location AS DECIMAL(3,2)) ELSE NULL END AS review_scores_location,
    CASE WHEN review_scores_value REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(review_scores_value AS DECIMAL(3,2)) ELSE NULL END AS review_scores_value,
    CASE WHEN reviews_per_month REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(reviews_per_month AS DECIMAL(5,2)) ELSE NULL END AS reviews_per_month,
    CASE WHEN first_review REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN CAST(first_review AS DATE) ELSE NULL END AS first_review,
    CASE WHEN last_review REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN CAST(last_review AS DATE) ELSE NULL END AS last_review,
    CASE WHEN availability_365 REGEXP '^[0-9]+$' THEN CAST(availability_365 AS UNSIGNED) ELSE NULL END AS availability_365,
    CASE WHEN calculated_host_listings_count REGEXP '^[0-9]+$' THEN CAST(calculated_host_listings_count AS UNSIGNED) ELSE NULL END AS host_total_listings
FROM listings_staging;

ALTER TABLE listings_clean ADD PRIMARY KEY (listing_id);

CREATE INDEX idx_lc_city ON listings_clean(city);
CREATE INDEX idx_lc_room_type ON listings_clean(room_type);
CREATE INDEX idx_lc_neighbourhood ON listings_clean(neighbourhood);