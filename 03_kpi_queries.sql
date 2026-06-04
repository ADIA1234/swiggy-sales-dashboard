-- ============================================================
-- Swiggy Sales Dashboard — FY 2024-25
-- Script 03: KPI Calculation Queries
-- ============================================================


-- ─────────────────────────────────────────────
-- KPI 1: Executive Summary (single-row scorecard)
-- ─────────────────────────────────────────────
SELECT
    CONCAT(MIN(month),' ',MIN(year),' to ',MAX(month),' ',MAX(year)) AS period,
    SUM(revenue_rs_lakhs)                          AS gross_revenue_rs_lakhs,
    SUM(orders_lakhs)                              AS total_orders_lakhs,
    ROUND(AVG(avg_order_value_rs), 0)              AS avg_order_value_rs,
    MAX(active_restaurants)                         AS restaurants_fy_end,
    MAX(active_users_cr)                            AS active_users_cr_fy_end,
    ROUND(AVG(avg_delivery_min), 1)                 AS annual_avg_delivery_min,
    ROUND(AVG(on_time_delivery_pct), 1)             AS annual_on_time_pct,
    ROUND(AVG(cancellation_rate_pct), 1)            AS annual_cancellation_pct,
    ROUND(AVG(delivery_partner_rating), 2)          AS annual_avg_rating
FROM swiggy_monthly;


-- ─────────────────────────────────────────────
-- KPI 2: Revenue per Active Restaurant
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    revenue_rs_lakhs,
    active_restaurants,
    ROUND((revenue_rs_lakhs * 100000) / active_restaurants, 2) AS revenue_per_restaurant_rs
FROM swiggy_monthly
ORDER BY year, FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar');


-- ─────────────────────────────────────────────
-- KPI 3: Customer Acquisition Cost (Proxy)
-- New users vs revenue generated that month
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    new_users_lakhs,
    revenue_rs_lakhs,
    ROUND((revenue_rs_lakhs * 100000) / (new_users_lakhs * 100000), 2) AS revenue_per_new_user_rs
FROM swiggy_monthly
ORDER BY year, FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar');


-- ─────────────────────────────────────────────
-- KPI 4: Cancellation Loss Estimate
-- (cancelled orders × avg order value = lost revenue estimate)
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    cancelled_orders_lakhs,
    avg_order_value_rs,
    ROUND(cancelled_orders_lakhs * avg_order_value_rs, 2) AS estimated_lost_revenue_rs_lakhs
FROM swiggy_monthly
ORDER BY estimated_lost_revenue_rs_lakhs DESC;


-- ─────────────────────────────────────────────
-- KPI 5: Delivery Efficiency Score
-- Composite: on_time_pct / cancellation_rate (higher = better)
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    on_time_delivery_pct,
    cancellation_rate_pct,
    avg_delivery_min,
    ROUND(
        (on_time_delivery_pct / cancellation_rate_pct) * (40 / avg_delivery_min), 2
    ) AS delivery_efficiency_score
FROM swiggy_monthly
ORDER BY delivery_efficiency_score DESC;


-- ─────────────────────────────────────────────
-- KPI 6: Highest Revenue Day / Peak Slot Insight
-- (from category table — which category drives peak lunch)
-- ─────────────────────────────────────────────
SELECT
    category,
    orders_lakhs,
    avg_order_value_rs,
    avg_rating,
    RANK() OVER (ORDER BY orders_lakhs DESC) AS order_volume_rank,
    RANK() OVER (ORDER BY avg_order_value_rs DESC) AS aov_rank
FROM swiggy_category
ORDER BY orders_lakhs DESC;


-- ─────────────────────────────────────────────
-- KPI 7: Net Revenue after Discounts
-- (total vs. discounted vs. loyalty-driven)
-- ─────────────────────────────────────────────
SELECT
    SUM(gross_revenue_rs_lakhs)                      AS total_gross_revenue,
    SUM(discount_given_rs_lakhs)                     AS total_discounts_given,
    SUM(net_revenue_rs_lakhs)                        AS total_net_revenue,
    ROUND(SUM(discount_given_rs_lakhs) / 
          SUM(gross_revenue_rs_lakhs) * 100, 2)      AS overall_discount_rate_pct,
    ROUND(SUM(net_revenue_rs_lakhs) / 
          SUM(gross_revenue_rs_lakhs) * 100, 2)      AS net_revenue_retention_pct
FROM swiggy_offers;
