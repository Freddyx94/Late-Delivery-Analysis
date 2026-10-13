"""
Load the DataCo Smart Supply Chain CSV into a DuckDB database.

Usage:
    python load_data.py data/DataCoSupplyChainDataset.csv

Creates supply_chain.duckdb with:
    order_items  - one row per order line (cleaned)
    orders       - view with one row per order
"""
import re
import sys
from pathlib import Path

import duckdb
import pandas as pd

DB_PATH = Path("supply_chain.duckdb")

# Personal or empty columns we don't need for the analysis
DROP_COLUMNS = [
    "customer_email", "customer_password", "customer_fname",
    "customer_lname", "customer_street", "product_description",
    "product_image",
]


def to_snake_case(name: str) -> str:
    """'Days for shipping (real)' -> 'days_for_shipping_real'"""
    name = re.sub(r"[^0-9a-zA-Z]+", "_", name.strip().lower())
    return name.strip("_")


def main(csv_path: str) -> None:
    # The original file is not UTF-8, so read it as latin-1
    df = pd.read_csv(csv_path, encoding="latin-1")
    print(f"Read {len(df):,} rows, {df.shape[1]} columns")

    df.columns = [to_snake_case(c) for c in df.columns]
    df = df.rename(columns={
        "order_date_dateorders": "order_date",
        "shipping_date_dateorders": "shipping_date",
    })
    df = df.drop(columns=[c for c in DROP_COLUMNS if c in df.columns])

    for col in ["order_date", "shipping_date"]:
        df[col] = pd.to_datetime(df[col], format="%m/%d/%Y %H:%M")

    before = len(df)
    df = df.drop_duplicates()
    print(f"Removed {before - len(df):,} duplicate rows")

    con = duckdb.connect(str(DB_PATH))
    con.execute("CREATE OR REPLACE TABLE order_items AS SELECT * FROM df")

    # The raw data has one row per order LINE. Most delivery questions are
    # about whole orders, so build an order-level view as well.
    con.execute("""
        CREATE OR REPLACE VIEW orders AS
        SELECT
            order_id,
            MIN(order_date)                       AS order_date,
            ANY_VALUE(shipping_date)              AS shipping_date,
            ANY_VALUE(shipping_mode)              AS shipping_mode,
            ANY_VALUE(market)                     AS market,
            ANY_VALUE(order_region)               AS order_region,
            ANY_VALUE(customer_segment)           AS customer_segment,
            ANY_VALUE(delivery_status)            AS delivery_status,
            ANY_VALUE(days_for_shipping_real)     AS days_real,
            ANY_VALUE(days_for_shipment_scheduled) AS days_scheduled,
            MAX(late_delivery_risk)               AS is_late,
            COUNT(*)                              AS n_items,
            SUM(order_item_total)                 AS revenue,
            SUM(order_profit_per_order)           AS profit
        FROM order_items
        GROUP BY order_id
    """)

    n_items = con.execute("SELECT COUNT(*) FROM order_items").fetchone()[0]
    n_orders = con.execute("SELECT COUNT(*) FROM orders").fetchone()[0]
    print(f"Saved {n_items:,} order lines and {n_orders:,} orders to {DB_PATH}")
    con.close()


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: python load_data.py <path-to-csv>")
    main(sys.argv[1])
