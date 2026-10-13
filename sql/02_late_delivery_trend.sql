-- Q1: What share of orders arrive late, and is it getting better or worse?
-- Uses a CTE for the monthly figures and window functions for
-- the month-over-month change and a 3-month rolling average.

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        COUNT(*)                        AS orders,
        AVG(is_late) * 100              AS late_pct
    FROM orders
    GROUP BY 1
)
SELECT
    month,
    orders,
    ROUND(late_pct, 1) AS late_pct,
    ROUND(late_pct - LAG(late_pct) OVER (ORDER BY month), 1) AS change_vs_prev_month,
    ROUND(AVG(late_pct) OVER (
        ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 1) AS rolling_3m_late_pct
FROM monthly
ORDER BY month;
