-- ============================================================
-- Swiggy Sales Dashboard — FY 2024-25
-- Script 02: Core Data Analysis Queries
-- ============================================================


-- ─────────────────────────────────────────────
-- INSERT SAMPLE DATA
-- ─────────────────────────────────────────────

INSERT INTO swiggy_monthly
  (month, year, revenue_rs_lakhs, orders_lakhs, avg_order_value_rs,
   active_restaurants, active_users_cr, new_users_lakhs, cancelled_orders_lakhs,
   avg_delivery_min, on_time_delivery_pct, cancellation_rate_pct,
   delivery_partner_rating, orders_per_de_per_day, avg_delivery_fee_rs)
VALUES
  ('Apr', 2024, 1080, 218, 321, 194820, 7.8, 18.2, 10.4, 33.1, 88.2, 4.8, 4.18, 18.4, 38.0),
  ('May', 2024, 1120, 224, 318, 197340, 8.0, 17.9, 10.6, 32.8, 88.8, 4.6, 4.19, 18.8, 37.4),
  ('Jun', 2024, 1090, 216, 322, 198600, 8.1, 16.4, 10.2, 32.4, 89.1, 4.3, 4.20, 19.0, 36.8),
  ('Jul', 2024, 1180, 238, 319, 200120, 8.3, 19.8, 11.0, 31.9, 89.6, 4.2, 4.21, 19.4, 36.2),
  ('Aug', 2024, 1240, 251, 316, 204480, 8.5, 21.2, 11.3, 31.4, 90.2, 4.1, 4.22, 19.8, 35.6),
  ('Sep', 2024, 1230, 247, 318, 206840, 8.6, 19.4, 11.1, 31.8, 90.8, 3.9, 4.22, 20.0, 35.0),
  ('Oct', 2024, 1310, 264, 317, 208900, 8.8, 22.6, 11.8, 30.6, 91.2, 3.8, 4.23, 20.4, 34.4),
  ('Nov', 2024, 1390, 278, 320, 212340, 9.0, 24.1, 12.1, 30.2, 91.6, 3.7, 4.24, 20.8, 33.8),
  ('Dec', 2024, 1450, 291, 322, 214880, 9.2, 26.8, 12.4, 29.8, 92.0, 3.6, 4.25, 21.0, 33.2),
  ('Jan', 2025, 1260, 253, 319, 216020, 9.3, 20.4, 11.5, 29.6, 92.4, 3.6, 4.26, 21.2, 33.0),
  ('Feb', 2025, 1190, 239, 317, 217460, 9.3, 17.8, 10.9, 29.4, 92.6, 3.5, 4.26, 21.2, 32.8),
  ('Mar', 2025, 1280, 257, 321, 218540, 9.4, 21.6, 11.2, 29.6, 92.8, 3.6, 4.27, 21.3, 33.2);


-- ─────────────────────────────────────────────
-- QUERY 1: Full Year Summary
-- ─────────────────────────────────────────────
SELECT
    COUNT(*)                          AS total_months,
    SUM(revenue_rs_lakhs)             AS total_revenue_rs_lakhs,
    SUM(orders_lakhs)                 AS total_orders_lakhs,
    ROUND(AVG(avg_order_value_rs), 2) AS avg_order_value_rs,
    MAX(revenue_rs_lakhs)             AS best_month_revenue,
    MIN(revenue_rs_lakhs)             AS lowest_month_revenue,
    ROUND(AVG(on_time_delivery_pct), 2)  AS avg_on_time_pct,
    ROUND(AVG(cancellation_rate_pct), 2) AS avg_cancellation_pct
FROM swiggy_monthly;


-- ─────────────────────────────────────────────
-- QUERY 2: Month-over-Month Revenue Growth
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    revenue_rs_lakhs,
    LAG(revenue_rs_lakhs) OVER (ORDER BY year, 
        FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
    ) AS prev_month_revenue,
    ROUND(
        (revenue_rs_lakhs - LAG(revenue_rs_lakhs) OVER (ORDER BY year,
            FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
        )) / LAG(revenue_rs_lakhs) OVER (ORDER BY year,
            FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
        ) * 100, 2
    ) AS mom_growth_pct
FROM swiggy_monthly
ORDER BY year, FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar');


-- ─────────────────────────────────────────────
-- QUERY 3: Quarterly Performance Summary
-- ─────────────────────────────────────────────
SELECT
    CASE
        WHEN month IN ('Apr','May','Jun') THEN 'Q1 FY25'
        WHEN month IN ('Jul','Aug','Sep') THEN 'Q2 FY25'
        WHEN month IN ('Oct','Nov','Dec') THEN 'Q3 FY25'
        ELSE                                   'Q4 FY25'
    END                               AS quarter,
    SUM(revenue_rs_lakhs)             AS revenue_rs_lakhs,
    SUM(orders_lakhs)                 AS orders_lakhs,
    ROUND(AVG(avg_order_value_rs), 1) AS avg_order_value,
    ROUND(AVG(avg_delivery_min), 2)   AS avg_delivery_min,
    ROUND(AVG(on_time_delivery_pct), 2) AS on_time_pct,
    ROUND(AVG(cancellation_rate_pct), 2) AS cancellation_pct
FROM swiggy_monthly
GROUP BY quarter
ORDER BY FIELD(quarter, 'Q1 FY25','Q2 FY25','Q3 FY25','Q4 FY25');


-- ─────────────────────────────────────────────
-- QUERY 4: Best and Worst Performing Months
-- ─────────────────────────────────────────────
SELECT
    CONCAT(month, ' ', year)             AS period,
    revenue_rs_lakhs,
    orders_lakhs,
    DENSE_RANK() OVER (ORDER BY revenue_rs_lakhs DESC) AS revenue_rank
FROM swiggy_monthly
ORDER BY revenue_rs_lakhs DESC;


-- ─────────────────────────────────────────────
-- QUERY 5: Top 5 Cities by Revenue
-- ─────────────────────────────────────────────
SELECT
    city,
    state,
    city_tier,
    revenue_rs_lakhs,
    orders_lakhs,
    avg_order_value_rs,
    pct_of_total_revenue,
    active_restaurants
FROM swiggy_city
ORDER BY revenue_rs_lakhs DESC
LIMIT 5;


-- ─────────────────────────────────────────────
-- QUERY 6: Revenue by City Tier
-- ─────────────────────────────────────────────
SELECT
    city_tier,
    COUNT(*)                              AS city_count,
    SUM(revenue_rs_lakhs)                 AS total_revenue,
    ROUND(AVG(revenue_rs_lakhs), 2)       AS avg_revenue_per_city,
    ROUND(AVG(avg_order_value_rs), 2)     AS avg_order_value,
    ROUND(AVG(avg_delivery_min), 2)       AS avg_delivery_min,
    ROUND(SUM(pct_of_total_revenue), 2)   AS total_pct_share
FROM swiggy_city
GROUP BY city_tier
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────────
-- QUERY 7: Top Food Categories by Revenue
-- ─────────────────────────────────────────────
SELECT
    category,
    revenue_rs_lakhs,
    orders_lakhs,
    avg_order_value_rs,
    pct_of_total_revenue,
    yoy_change_pct,
    avg_rating,
    CASE
        WHEN yoy_change_pct > 4  THEN 'High Growth'
        WHEN yoy_change_pct > 0  THEN 'Stable Growth'
        WHEN yoy_change_pct = 0  THEN 'Flat'
        ELSE                          'Declining'
    END AS growth_segment
FROM swiggy_category
ORDER BY revenue_rs_lakhs DESC;


-- ─────────────────────────────────────────────
-- QUERY 8: Delivery Improvement Over Quarters
-- ─────────────────────────────────────────────
SELECT
    quarter,
    avg_delivery_min,
    on_time_pct,
    cancellation_rate_pct,
    delivery_partner_rating,
    orders_per_de_per_day,
    avg_delivery_fee_rs,
    ROUND(avg_delivery_min - FIRST_VALUE(avg_delivery_min) 
          OVER (ORDER BY FIELD(quarter,'Q1 FY25','Q2 FY25','Q3 FY25','Q4 FY25')), 2
    ) AS delivery_time_change_from_q1
FROM swiggy_delivery
ORDER BY FIELD(quarter,'Q1 FY25','Q2 FY25','Q3 FY25','Q4 FY25');


-- ─────────────────────────────────────────────
-- QUERY 9: Offers ROI Analysis
-- ─────────────────────────────────────────────
SELECT
    offer_type,
    total_orders_lakhs,
    gross_revenue_rs_lakhs,
    discount_given_rs_lakhs,
    net_revenue_rs_lakhs,
    discount_pct,
    avg_order_value_rs,
    repeat_order_rate_pct,
    ROUND(net_revenue_rs_lakhs / NULLIF(discount_given_rs_lakhs, 0), 2) AS revenue_per_rupee_discount
FROM swiggy_offers
ORDER BY net_revenue_rs_lakhs DESC;
