"""
Run a .sql file against the database, print the result and save it as CSV.

Usage:
    python run_sql.py sql/02_late_delivery_trend.sql

Results go to output/<file name>.csv, ready to load into Power BI later.
"""
import sys
from pathlib import Path

import duckdb

DB_PATH = "supply_chain.duckdb"


def main(sql_path: str) -> None:
    query = Path(sql_path).read_text()
    con = duckdb.connect(DB_PATH, read_only=True)
    result = con.execute(query).df()
    con.close()

    print(result.to_string(index=False))

    out = Path("output") / (Path(sql_path).stem + ".csv")
    out.parent.mkdir(exist_ok=True)
    result.to_csv(out, index=False)
    print(f"\nSaved {len(result)} rows to {out}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: python run_sql.py <path-to-sql-file>")
    main(sys.argv[1])
