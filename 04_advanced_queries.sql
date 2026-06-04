-- ============================================================
-- Swiggy Sales Dashboard — FY 2024-25
-- Script 04: Advanced Queries (CTEs, Window Functions, Rankings)
-- ============================================================


-- ─────────────────────────────────────────────
-- ADVANCED 1: Running Total Revenue (Cumulative)
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    revenue_rs_lakhs,
    SUM(revenue_rs_lakhs) OVER (
        ORDER BY year,
        FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
    ) AS cumulative_revenue_rs_lakhs,
    ROUND(
        SUM(revenue_rs_lakhs) OVER (
            ORDER BY year,
            FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
        ) / SUM(revenue_rs_lakhs) OVER () * 100, 1
    ) AS cumulative_pct_of_annual
FROM swiggy_monthly;


-- ─────────────────────────────────────────────
-- ADVANCED 2: 3-Month Rolling Average Revenue
-- (smooths out seasonal spikes)
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    revenue_rs_lakhs,
    ROUND(AVG(revenue_rs_lakhs) OVER (
        ORDER BY year,
        FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3m_avg_revenue,
    ROUND(AVG(orders_lakhs) OVER (
        ORDER BY year,
        FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3m_avg_orders
FROM swiggy_monthly;


-- ─────────────────────────────────────────────
-- ADVANCED 3: City Performance vs National Average
-- using CTE
-- ─────────────────────────────────────────────
WITH national_avg AS (
    SELECT
        ROUND(AVG(revenue_rs_lakhs), 2)    AS avg_revenue,
        ROUND(AVG(avg_order_value_rs), 2)  AS avg_aov,
        ROUND(AVG(avg_delivery_min), 2)    AS avg_delivery
    FROM swiggy_city
)
SELECT
    c.city,
    c.city_tier,
    c.revenue_rs_lakhs,
    n.avg_revenue                          AS national_avg_revenue,
    ROUND(c.revenue_rs_lakhs - n.avg_revenue, 2) AS vs_national_avg,
    CASE
        WHEN c.revenue_rs_lakhs > n.avg_revenue * 2 THEN 'Star City'
        WHEN c.revenue_rs_lakhs > n.avg_revenue     THEN 'Above Average'
        WHEN c.revenue_rs_lakhs > n.avg_revenue * 0.5 THEN 'Below Average'
        ELSE 'Emerging'
    END AS performance_bucket,
    c.avg_order_value_rs,
    n.avg_aov                              AS national_avg_aov,
    c.avg_delivery_min,
    n.avg_delivery                         AS national_avg_delivery
FROM swiggy_city c
CROSS JOIN national_avg n
ORDER BY c.revenue_rs_lakhs DESC;


-- ─────────────────────────────────────────────
-- ADVANCED 4: Category Revenue Contribution
-- with percentile ranking
-- ─────────────────────────────────────────────
WITH category_ranked AS (
    SELECT
        category,
        revenue_rs_lakhs,
        orders_lakhs,
        avg_order_value_rs,
        yoy_change_pct,
        avg_rating,
        RANK() OVER (ORDER BY revenue_rs_lakhs DESC)   AS revenue_rank,
        RANK() OVER (ORDER BY avg_rating DESC)          AS rating_rank,
        RANK() OVER (ORDER BY yoy_change_pct DESC)      AS growth_rank,
        ROUND(revenue_rs_lakhs / SUM(revenue_rs_lakhs) OVER () * 100, 2) AS revenue_share_pct,
        SUM(revenue_rs_lakhs) OVER (ORDER BY revenue_rs_lakhs DESC) AS cumulative_revenue,
        SUM(revenue_rs_lakhs) OVER () AS total_revenue
    FROM swiggy_category
)
SELECT
    category,
    revenue_rs_lakhs,
    revenue_share_pct,
    revenue_rank,
    rating_rank,
    growth_rank,
    ROUND(cumulative_revenue / total_revenue * 100, 1) AS cumulative_pct,
    CASE
        WHEN cumulative_revenue / total_revenue <= 0.8 THEN 'Top 80% (Core)'
        ELSE 'Long Tail'
    END AS category_segment
FROM category_ranked
ORDER BY revenue_rank;


-- ─────────────────────────────────────────────
-- ADVANCED 5: Offer ROI with Loyalty Bonus
-- Ranks offers by net revenue per rupee spent on discount
-- ─────────────────────────────────────────────
WITH offer_roi AS (
    SELECT
        offer_type,
        net_revenue_rs_lakhs,
        discount_given_rs_lakhs,
        repeat_order_rate_pct,
        total_orders_lakhs,
        ROUND(net_revenue_rs_lakhs / NULLIF(discount_given_rs_lakhs, 0), 3) AS net_rev_per_discount_rs,
        ROUND(repeat_order_rate_pct / 100 * total_orders_lakhs, 2)           AS estimated_repeat_orders
    FROM swiggy_offers
    WHERE discount_given_rs_lakhs > 0
)
SELECT
    offer_type,
    net_revenue_rs_lakhs,
    discount_given_rs_lakhs,
    net_rev_per_discount_rs,
    estimated_repeat_orders,
    RANK() OVER (ORDER BY net_rev_per_discount_rs DESC) AS roi_rank,
    RANK() OVER (ORDER BY estimated_repeat_orders DESC) AS loyalty_rank
FROM offer_roi
ORDER BY roi_rank;


-- ─────────────────────────────────────────────
-- ADVANCED 6: Delivery Performance Trend Analysis
-- Month-over-month improvement tracking
-- ─────────────────────────────────────────────
SELECT
    month,
    year,
    avg_delivery_min,
    on_time_delivery_pct,
    cancellation_rate_pct,
    avg_delivery_min - LAG(avg_delivery_min) OVER (
        ORDER BY year,
        FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
    ) AS delivery_time_delta,
    on_time_delivery_pct - LAG(on_time_delivery_pct) OVER (
        ORDER BY year,
        FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')
    ) AS on_time_delta,
    CASE
        WHEN avg_delivery_min < 30 AND on_time_delivery_pct > 92 THEN 'Excellent'
        WHEN avg_delivery_min < 32 AND on_time_delivery_pct > 90 THEN 'Good'
        WHEN avg_delivery_min < 34 AND on_time_delivery_pct > 88 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS delivery_grade
FROM swiggy_monthly
ORDER BY year, FIELD(month,'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar');


-- ─────────────────────────────────────────────
-- ADVANCED 7: Top City + Category Cross Analysis
-- Which city-tier orders which category the most?
-- (simulated join using available data)
-- ─────────────────────────────────────────────
WITH tier_revenue AS (
    SELECT
        city_tier,
        SUM(revenue_rs_lakhs) AS tier_revenue,
        COUNT(*) AS city_count
    FROM swiggy_city
    GROUP BY city_tier
),
top_categories AS (
    SELECT
        category,
        revenue_rs_lakhs AS cat_revenue,
        pct_of_total_revenue
    FROM swiggy_category
    ORDER BY revenue_rs_lakhs DESC
    LIMIT 5
)
SELECT
    t.city_tier,
    t.tier_revenue,
    t.city_count,
    ROUND(t.tier_revenue / (SELECT SUM(revenue_rs_lakhs) FROM swiggy_city) * 100, 1) AS tier_share_pct,
    c.category AS top_category_nationally,
    c.pct_of_total_revenue AS category_national_share
FROM tier_revenue t
CROSS JOIN top_categories c
ORDER BY t.tier_revenue DESC, c.cat_revenue DESC;
