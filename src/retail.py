from pathlib import Path
import json
import pandas as pd
from dq_utils import check_unique_rows, check_nulls

def sample_retail_df() -> pd.DataFrame:
    return pd.DataFrame({
        "customer": ["Alice","Bob","Alice","Bob","Charlie","Alice"],
        "product":  ["Apples","Apples","Bananas","Bananas","Apples","Bananas"],
        "quantity": [3,2,5,7,1,2],
        "price":    [2.0,2.0,1.5,1.5,2.0,1.5],
    })

if __name__ == "__main__":
    df = sample_retail_df()
    uniq = check_unique_rows(df, subset=["customer","product","quantity","price"])
    nulls = check_nulls(df, fail_if_any=True)

    print("== Uniqueness ==")
    print(f"is_unique: {uniq['is_unique']}, duplicate_count: {uniq['duplicate_count']}")
    if not uniq["is_unique"]:
        print(uniq["duplicate_rows"])

    print("\n== Nulls ==")
    print(f"passed: {nulls['passed']}")
    print("null_counts:\n", nulls["null_counts"])
    print("null_ratios:\n", nulls["null_ratios"])

    out = Path("run_outputs"); out.mkdir(parents=True, exist_ok=True)
    df.to_csv(out / "retail_table.csv", index=False)
    (out / "uniqueness.json").write_text(json.dumps({
        "is_unique": uniq["is_unique"],
        "duplicate_count": uniq["duplicate_count"],
    }, indent=2))
    (out / "nulls.json").write_text(json.dumps({
        "passed": nulls["passed"],
        "null_counts": nulls["null_counts"].to_dict(),
        "null_ratios": {k: float(v) for k, v in nulls["null_ratios"].to_dict().items()},
    }, indent=2))
