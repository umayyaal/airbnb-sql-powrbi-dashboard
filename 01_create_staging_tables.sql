-- ============================================
-- Script: 01_create_staging_tables.sql
-- Purpose: Create the airbnb_project database and 
--          staging tables for raw CSV imports
-- ============================================

CREATE DATABASE IF NOT EXISTS airbnb_project 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE airbnb_project;

-- Staging table for listings data (all 4 cities)
-- All columns TEXT initially — raw import, no type enforcement yet
CREATE TABLE listings_staging (
    id TEXT, listing_url TEXT, scrape_id TEXT, last_scraped TEXT, source TEXT,
    name TEXT, description TEXT, neighborhood_overview TEXT, picture_url TEXT,
    host_id TEXT, host_url TEXT, host_profile_id TEXT, host_profile_url TEXT,
    host_name TEXT, host_since TEXT, hosts_time_as_user_years TEXT, hosts_time_as_user_months TEXT,
    hosts_time_as_host_years TEXT, hosts_time_as_host_months TEXT, host_location TEXT,
    host_about TEXT, host_response_time TEXT, host_response_rate TEXT, host_acceptance_rate TEXT,
    host_is_superhost TEXT, host_thumbnail_url TEXT, host_picture_url TEXT, host_neighbourhood TEXT,
    host_listings_count TEXT, host_total_listings_count TEXT, host_verifications TEXT,
    host_has_profile_pic TEXT, host_identity_verified TEXT, neighbourhood TEXT,
    neighbourhood_cleansed TEXT, neighbourhood_group_cleansed TEXT, latitude TEXT, longitude TEXT,
    property_type TEXT, room_type TEXT, accommodates TEXT, bathrooms TEXT, bathrooms_text TEXT,
    bedrooms TEXT, beds TEXT, amenities TEXT, price TEXT, price_quote_checkin_date TEXT,
    price_quote_checkout_date TEXT, price_quote_total_price TEXT, price_quote_price_per_night TEXT,
    price_quote_raw TEXT, minimum_nights TEXT, maximum_nights TEXT, minimum_minimum_nights TEXT,
    maximum_minimum_nights TEXT, minimum_maximum_nights TEXT, maximum_maximum_nights TEXT,
    minimum_nights_avg_ntm TEXT, maximum_nights_avg_ntm TEXT, calendar_updated TEXT,
    has_availability TEXT, availability_30 TEXT, availability_60 TEXT, availability_90 TEXT,
    availability_365 TEXT, calendar_last_scraped TEXT, number_of_reviews TEXT,
    number_of_reviews_ltm TEXT, number_of_reviews_l30d TEXT, availability_eoy TEXT,
    number_of_reviews_ly TEXT, estimated_occupancy_l365d TEXT, estimated_revenue_l365d TEXT,
    first_review TEXT, last_review TEXT, review_scores_rating TEXT, review_scores_accuracy TEXT,
    review_scores_cleanliness TEXT, review_scores_checkin TEXT, review_scores_communication TEXT,
    review_scores_location TEXT, review_scores_value TEXT, license TEXT, instant_bookable TEXT,
    calculated_host_listings_count TEXT, calculated_host_listings_count_entire_homes TEXT,
    calculated_host_listings_count_private_rooms TEXT, calculated_host_listings_count_shared_rooms TEXT,
    reviews_per_month TEXT,
    city TEXT
);

-- Staging table for calendar data (all 4 cities)
CREATE TABLE calendar_staging (
    listing_id TEXT,
    date_value TEXT,
    available TEXT,
    minimum_nights TEXT,
    maximum_nights TEXT,
    city TEXT
);

-- Performance indexes (added after bulk load, since indexing 
-- before a large LOAD DATA INFILE slows the import down significantly)
CREATE INDEX idx_calendar_city ON calendar_staging(city(20));
CREATE INDEX idx_listings_city ON listings_staging(city(20));