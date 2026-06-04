-- ============================================================
-- Swiggy Sales Dashboard — FY 2024-25
-- Script 01: Create Tables
-- Compatible with: MySQL 8+ / PostgreSQL 13+
-- ============================================================

-- Drop tables if they already exist (for re-runs)
DROP TABLE IF EXISTS swiggy_offers;
DROP TABLE IF EXISTS swiggy_delivery;
DROP TABLE IF EXISTS swiggy_category;
DROP TABLE IF EXISTS swiggy_city;
DROP TABLE IF EXISTS swiggy_monthly;

-- ─────────────────────────────────────────────
-- Table 1: Monthly Sales Data
-- ─────────────────────────────────────────────
CREATE TABLE swiggy_monthly (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    month                   VARCHAR(3)     NOT NULL,
    year                    INT            NOT NULL,
    revenue_rs_lakhs        DECIMAL(10,2)  NOT NULL,
    orders_lakhs            DECIMAL(10,2)  NOT NULL,
    avg_order_value_rs      DECIMAL(10,2)  NOT NULL,
    active_restaurants      INT            NOT NULL,
    active_users_cr         DECIMAL(5,2)   NOT NULL,
    new_users_lakhs         DECIMAL(6,2)   NOT NULL,
    cancelled_orders_lakhs  DECIMAL(6,2)   NOT NULL,
    avg_delivery_min        DECIMAL(5,2)   NOT NULL,
    on_time_delivery_pct    DECIMAL(5,2)   NOT NULL,
    cancellation_rate_pct   DECIMAL(5,2)   NOT NULL,
    delivery_partner_rating DECIMAL(4,2)   NOT NULL,
    orders_per_de_per_day   DECIMAL(5,2)   NOT NULL,
    avg_delivery_fee_rs     DECIMAL(6,2)   NOT NULL
);

-- ─────────────────────────────────────────────
-- Table 2: City-wise Data
-- ─────────────────────────────────────────────
CREATE TABLE swiggy_city (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    city                    VARCHAR(50)    NOT NULL,
    state                   VARCHAR(50)    NOT NULL,
    revenue_rs_lakhs        DECIMAL(10,2)  NOT NULL,
    orders_lakhs            DECIMAL(8,2)   NOT NULL,
    avg_order_value_rs      DECIMAL(8,2)   NOT NULL,
    pct_of_total_revenue    DECIMAL(5,2)   NOT NULL,
    active_restaurants      INT            NOT NULL,
    active_users_lakhs      DECIMAL(8,2)   NOT NULL,
    avg_delivery_min        DECIMAL(5,2)   NOT NULL,
    city_tier               VARCHAR(10)    NOT NULL
);

-- ─────────────────────────────────────────────
-- Table 3: Food Category Data
-- ─────────────────────────────────────────────
CREATE TABLE swiggy_category (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    category                VARCHAR(60)    NOT NULL,
    revenue_rs_lakhs        DECIMAL(10,2)  NOT NULL,
    orders_lakhs            DECIMAL(8,2)   NOT NULL,
    avg_order_value_rs      DECIMAL(8,2)   NOT NULL,
    pct_of_total_revenue    DECIMAL(5,2)   NOT NULL,
    yoy_change_pct          DECIMAL(6,2)   NOT NULL,
    avg_rating              DECIMAL(4,2)   NOT NULL,
    avg_items_per_order     DECIMAL(4,2)   NOT NULL
);

-- ─────────────────────────────────────────────
-- Table 4: Delivery Performance
-- ─────────────────────────────────────────────
CREATE TABLE swiggy_delivery (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    quarter                 VARCHAR(10)    NOT NULL,
    avg_delivery_min        DECIMAL(5,2)   NOT NULL,
    on_time_pct             DECIMAL(5,2)   NOT NULL,
    cancellation_rate_pct   DECIMAL(5,2)   NOT NULL,
    delivery_partner_rating DECIMAL(4,2)   NOT NULL,
    orders_per_de_per_day   DECIMAL(5,2)   NOT NULL,
    avg_delivery_fee_rs     DECIMAL(6,2)   NOT NULL,
    total_delivery_partners INT            NOT NULL,
    cities_covered          INT            NOT NULL
);

-- ─────────────────────────────────────────────
-- Table 5: Offers & Discounts
-- ─────────────────────────────────────────────
CREATE TABLE swiggy_offers (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    offer_type              VARCHAR(60)    NOT NULL,
    total_orders_lakhs      DECIMAL(8,2)   NOT NULL,
    gross_revenue_rs_lakhs  DECIMAL(10,2)  NOT NULL,
    discount_given_rs_lakhs DECIMAL(10,2)  NOT NULL,
    net_revenue_rs_lakhs    DECIMAL(10,2)  NOT NULL,
    discount_pct            DECIMAL(5,2)   NOT NULL,
    avg_order_value_rs      DECIMAL(8,2)   NOT NULL,
    repeat_order_rate_pct   DECIMAL(5,2)   NOT NULL
);


-- ─────────────────────────────────────────────
-- Load Data (MySQL LOAD DATA — adjust path as needed)
-- ─────────────────────────────────────────────

/*
LOAD DATA INFILE '/path/to/data/swiggy_raw_data.csv'
INTO TABLE swiggy_monthly
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(month, year, revenue_rs_lakhs, orders_lakhs, avg_order_value_rs,
 active_restaurants, active_users_cr, new_users_lakhs, cancelled_orders_lakhs,
 avg_delivery_min, on_time_delivery_pct, cancellation_rate_pct,
 delivery_partner_rating, orders_per_de_per_day, avg_delivery_fee_rs);
*/

-- Alternative: use the INSERT statements in 02_data_analysis.sql
