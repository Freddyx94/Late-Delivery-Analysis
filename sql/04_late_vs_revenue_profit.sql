-- Q3: Do late deliveries reduce revenue or profit?
-- Compares late vs. on-time orders on a per-order basis.
--
-- Notes:
--   * AVG per order is the fair comparison. Late orders are the majority,
--     so SUM totals would mostly restate that imbalance.
--   * Profit margin is SUM(profit) / SUM(revenue), not the average of each
--     order's margin. Averaging per-order ratios lets tiny orders count as
--     much as large ones and gives a distorted result.
--   * Cancelled orders are excluded: they are flagged as not late, so
--     leaving them in would mix them into the "on time" group.

WITH delivered AS (
    SELECT *
    FROM orders
    WHERE delivery_status <> 'Shipping canceled'
)
SELECT
    CASE WHEN is_late = 1 THEN 'Late' ELSE 'On time' END AS delivery,
    COUNT(*)                                        AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_orders,
    ROUND(AVG(revenue), 2)                          AS avg_revenue_per_order,
    ROUND(AVG(profit), 2)                           AS avg_profit_per_order,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 1)    AS profit_margin_pct,
    ROUND(SUM(revenue), 0)                          AS total_revenue,
    ROUND(SUM(profit), 0)                           AS total_profit
FROM delivered
GROUP BY is_late
ORDER BY is_late DESC;
