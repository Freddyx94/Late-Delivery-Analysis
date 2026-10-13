-- Dashboard export: one row per order line.
-- Feeds the Power BI "order_items" table (Stage 2). Kept lean on purpose:
-- only the join key (order_id) plus the product dimensions and line-level
-- measures that don't already exist in the orders table. Region, shipping
-- mode, dates etc. reach this table through the order_id relationship in
-- Power BI, so they are not duplicated here.
--
-- Cancelled and suspected-fraud lines are excluded: no sale happened, and
-- including them would overstate order counts / understate profit margin
-- in any visual built on this table.
SELECT
    order_id,
    category_name,
    department_name,
    product_name,
    order_item_quantity               AS quantity,
    order_item_total                  AS revenue,
    order_profit_per_order            AS profit
FROM order_items
WHERE order_status NOT IN ('CANCELED', 'SUSPECTED_FRAUD');
