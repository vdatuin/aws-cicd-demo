"""
Retail Data Quality Check Script.

This script:
  - Generates a sample retail DataFrame.
  - Runs uniqueness and null-check validations using dq_utils functions.
  - Saves the results to CSV and JSON files inside an output folder.
"""

from pathlib import Path
import json

import pandas as pd

from dq_utils import check_nulls, check_unique_rows


def sample_retail_df() -> pd.DataFrame:
    """
    Create a sample retail DataFrame for demo/testing.

    Returns:
        pd.DataFrame: A DataFrame with columns
        [customer, product, quantity, price].
    """
    return pd.DataFrame(
        {
            "customer": ["Alice", "Bob", "Alice", "Bob", "Charlie", "Alice"],
            "product": ["Apples", "Apples", "Bananas", "Bananas", "Apples",
                        "Bananas"],
            "quantity": [3, 2, 5, 7, 1, 2],
            "price": [2.0, 2.0, 1.5, 1.5, 2.0, 1.5],
        }
    )


if __name__ == "__main__":
    # Create a DataFrame (sample data)
    df = sample_retail_df()

    # Run uniqueness check across selected columns
    uniq = check_unique_rows(
        df,
        subset=["customer", "product", "quantity", "price"],
    )

    # Run nulls check (fail if any nulls exist)
    nulls = check_nulls(df, fail_if_any=True)

    # Print uniqueness results
    print("== Uniqueness ==")
    print(
        f"is_unique: {uniq['is_unique']}, "
        f"duplicate_count: {uniq['duplicate_count']}"
    )
    if not uniq["is_unique"]:
        print(uniq["duplicate_rows"])

    # Print null-check results
    print("\n== Nulls ==")
    print(f"passed: {nulls['passed']}")
    print("null_counts:\n", nulls["null_counts"])
    print("null_ratios:\n", nulls["null_ratios"])

    # Prepare output folder
    out = Path("run_outputs")
    out.mkdir(parents=True, exist_ok=True)

    # Save DataFrame to CSV
    df.to_csv(out / "retail_table.csv", index=False)

    # Save uniqueness results to JSON
    (out / "uniqueness.json").write_text(
        json.dumps(
            {
                "is_unique": uniq["is_unique"],
                "duplicate_count": uniq["duplicate_count"],
            },
            indent=2,
        )
    )

    # Save null-check results to JSON
    (out / "nulls.json").write_text(
        json.dumps(
            {
                "passed": nulls["passed"],
                "null_counts": nulls["null_counts"].to_dict(),
                "null_ratios": {
                    k: float(v)
                    for k, v in nulls["null_ratios"].to_dict().items()
                },
            },
            indent=2,
        )
    )
