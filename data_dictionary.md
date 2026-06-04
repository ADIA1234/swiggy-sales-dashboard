# Data Dictionary — Swiggy Sales Dashboard FY 2024–25

> All monetary values in **₹ Lakhs (1 Lakh = 100,000)** unless stated otherwise.  
> Dataset is simulated for educational/portfolio use. Not affiliated with Swiggy.

---

## swiggy_raw_data.csv / swiggy_monthly table

| Column | Type | Description |
|--------|------|-------------|
| month | VARCHAR | Month abbreviation (Apr, May … Mar) |
| year | INT | Calendar year (2024 or 2025) |
| revenue_rs_lakhs | DECIMAL | Total GMV/gross revenue for the month |
| orders_lakhs | DECIMAL | Total orders placed (in Lakhs) |
| avg_order_value_rs | DECIMAL | Average basket size in ₹ |
| active_restaurants | INT | Restaurants with at least 1 order that month |
| active_users_cr | DECIMAL | Users who placed at least 1 order (Crores) |
| new_users_lakhs | DECIMAL | First-time app users in the month (Lakhs) |
| cancelled_orders_lakhs | DECIMAL | Orders cancelled before delivery (Lakhs) |
| avg_delivery_min | DECIMAL | Average door-to-door delivery time in minutes |
| on_time_delivery_pct | DECIMAL | % of orders delivered within promised time |
| cancellation_rate_pct | DECIMAL | Cancellation rate as % of total orders |
| delivery_partner_rating | DECIMAL | Avg user rating for delivery experience (1–5) |
| orders_per_de_per_day | DECIMAL | Delivery executive productivity per day |
| avg_delivery_fee_rs | DECIMAL | Average delivery charge paid by users |

---

## swiggy_city_data.csv / swiggy_city table

| Column | Type | Description |
|--------|------|-------------|
| city | VARCHAR | City name |
| state | VARCHAR | State / Union Territory |
| revenue_rs_lakhs | DECIMAL | FY25 total revenue from the city |
| orders_lakhs | DECIMAL | Total orders in FY25 |
| avg_order_value_rs | DECIMAL | City-level average basket size |
| pct_of_total_revenue | DECIMAL | City's share of national revenue |
| active_restaurants | INT | Active restaurants in the city |
| active_users_lakhs | DECIMAL | Active users in the city (Lakhs) |
| avg_delivery_min | DECIMAL | City-level avg delivery time |
| city_tier | VARCHAR | Tier 1 / Tier 2 / Tier 3 classification |

---

## swiggy_category_data.csv / swiggy_category table

| Column | Type | Description |
|--------|------|-------------|
| category | VARCHAR | Food category name |
| revenue_rs_lakhs | DECIMAL | FY25 total revenue for category |
| orders_lakhs | DECIMAL | Total orders in category |
| avg_order_value_rs | DECIMAL | Category avg order value |
| pct_of_total_revenue | DECIMAL | Category's share of national revenue |
| yoy_change_pct | DECIMAL | Year-over-year revenue change % vs FY24 |
| avg_rating | DECIMAL | Average user rating for restaurants in category |
| avg_items_per_order | DECIMAL | Avg number of items in a single order |

---

## swiggy_delivery_data.csv / swiggy_delivery table

| Column | Type | Description |
|--------|------|-------------|
| quarter | VARCHAR | Financial quarter label (Q1–Q4 FY25) |
| avg_delivery_min | DECIMAL | Avg delivery time for the quarter |
| on_time_pct | DECIMAL | On-time delivery % for the quarter |
| cancellation_rate_pct | DECIMAL | Order cancellation rate % |
| delivery_partner_rating | DECIMAL | Avg DE rating |
| orders_per_de_per_day | DECIMAL | DE productivity |
| avg_delivery_fee_rs | DECIMAL | Avg delivery fee charged |
| total_delivery_partners | INT | Total active delivery executives in period |
| cities_covered | INT | Number of cities with active deliveries |

---

## swiggy_offers_data.csv / swiggy_offers table

| Column | Type | Description |
|--------|------|-------------|
| offer_type | VARCHAR | Type of offer or promotion |
| total_orders_lakhs | DECIMAL | Orders placed using this offer |
| gross_revenue_rs_lakhs | DECIMAL | Revenue before discount deduction |
| discount_given_rs_lakhs | DECIMAL | Total discount amount funded (Swiggy + Restaurant) |
| net_revenue_rs_lakhs | DECIMAL | Gross revenue minus discounts |
| discount_pct | DECIMAL | Discount as % of gross revenue |
| avg_order_value_rs | DECIMAL | Avg order value for orders using this offer |
| repeat_order_rate_pct | DECIMAL | % of users who ordered again within 30 days |

---

## Notes

- **City Tier Classification**: Tier 1 = metros (8 cities), Tier 2 = large cities (pop. 1M+), Tier 3 = emerging markets
- **On-Time Delivery**: Defined as delivery within the app-shown estimated time window
- **Cancellation Rate**: Only user-initiated cancellations; restaurant-side cancellations tracked separately
- **YoY figures** assume FY24 baseline data is available but not included in this dataset
