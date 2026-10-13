-- Q0: Data quality check: is the data complete and sensible?
-- Run this first, before any analysis.

SELECT
    COUNT(*)                                           AS orders,
    MIN(order_date)                                    AS first_order,
    MAX(order_date)                                    AS last_order,
    SUM(CASE WHEN shipping_mode IS NULL THEN 1 ELSE 0 END) AS missing_shipping_mode,
    SUM(CASE WHEN days_real < 0 THEN 1 ELSE 0 END)     AS negative_ship_days,
    ROUND(AVG(is_late) * 100, 1)                       AS late_pct,
    ROUND(SUM(revenue), 0)                             AS total_revenue,
    ROUND(SUM(profit), 0)                              AS total_profit
FROM orders;
