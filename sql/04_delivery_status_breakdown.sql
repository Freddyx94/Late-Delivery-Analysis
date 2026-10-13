-- Q3 (detail): the same comparison, split by the full delivery status
-- instead of the simple late / not-late flag.
-- Expected values: 'Advance shipping', 'Shipping on time', 'Late delivery',
-- 'Shipping canceled'. Check with:
--     SELECT delivery_status, COUNT(*) FROM orders GROUP BY 1;

SELECT
    delivery_status,
    COUNT(*)                                           AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_orders,
    ROUND(AVG(days_real - days_scheduled), 2)          AS avg_days_vs_schedule,
    ROUND(AVG(revenue), 2)                             AS avg_revenue_per_order,
    ROUND(AVG(profit), 2)                             AS avg_profit_per_order,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 1)       AS profit_margin_pct
FROM orders
GROUP BY delivery_status
ORDER BY avg_days_vs_schedule;
