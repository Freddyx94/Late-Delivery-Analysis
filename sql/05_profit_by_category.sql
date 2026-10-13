-- Q4: Which product categories drive profit, and which lose money?
-- Uses order_items (not orders), because product category is stored per
-- order line, and one order can contain several categories.
--
-- Notes:
--   * Cancelled and suspected-fraud lines are excluded: no sale happened.
--   * "Loses money" is checked two ways: total profit per category, and the
--     share of individual order lines sold at a loss. A category can be
--     profitable overall while many of its lines lose money.
--   * Grouped by category only. Department is left out because the data
--     links some categories to more than one department (e.g. Electronics).
--   * Window functions add each category's share of total profit and the
--     running (cumulative) share, to show how concentrated profit is.

WITH sold_items AS (
    SELECT *
    FROM order_items
    WHERE order_status NOT IN ('CANCELED', 'SUSPECTED_FRAUD')
),
category_stats AS (
    SELECT
        category_name,
        COUNT(*)                                                 AS order_lines,
        SUM(order_item_total)                                    AS revenue,
        SUM(order_profit_per_order)                              AS profit,
        AVG(CASE WHEN order_profit_per_order < 0 THEN 1 ELSE 0 END) * 100
                                                                 AS loss_line_pct,
        SUM(CASE WHEN order_profit_per_order < 0
                 THEN order_profit_per_order ELSE 0 END)         AS lost_on_loss_lines
    FROM sold_items
    GROUP BY category_name
)
SELECT
    RANK() OVER (ORDER BY profit DESC)                AS profit_rank,
    category_name,
    order_lines,
    ROUND(revenue, 0)                                 AS revenue,
    ROUND(profit, 0)                                  AS profit,
    ROUND(profit * 100.0 / revenue, 1)                AS profit_margin_pct,
    ROUND(loss_line_pct, 1)                           AS loss_line_pct,
    ROUND(lost_on_loss_lines, 0)                      AS lost_on_loss_lines,
    ROUND(profit * 100.0 / SUM(profit) OVER (), 1)    AS pct_of_total_profit,
    ROUND(SUM(profit) OVER (ORDER BY profit DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
          * 100.0 / SUM(profit) OVER (), 1)           AS cumulative_pct_of_profit
FROM category_stats
ORDER BY profit_rank;
