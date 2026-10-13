-- Dashboard export: one row per order.
-- Feeds the Power BI "orders" table (Stage 2). This is the order-level
-- grain for delivery KPIs: on-time rate, late trend, by region/mode/segment.
SELECT *
FROM orders;
