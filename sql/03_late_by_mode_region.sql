-- Q2: Which shipping modes and regions have the most late deliveries?
-- Ranks shipping modes within each region (worst first) and compares
-- actual vs. scheduled shipping days.

WITH mode_stats AS (
    SELECT
        order_region,
        shipping_mode,
        COUNT(*)                         AS orders,
        AVG(is_late) * 100               AS late_pct,
        AVG(days_real - days_scheduled)  AS avg_days_over_schedule
    FROM orders
    GROUP BY order_region, shipping_mode
)
SELECT
    order_region,
    shipping_mode,
    orders,
    ROUND(late_pct, 1)               AS late_pct,
    ROUND(avg_days_over_schedule, 2) AS avg_days_over_schedule,
    RANK() OVER (PARTITION BY order_region ORDER BY late_pct DESC) AS worst_rank
FROM mode_stats
ORDER BY order_region, worst_rank;
