# tests/test_retail_integration.py
import pandas as pd
from pathlib import Path
from retail import run_demo, sample_retail_df

def test_run_demo_no_duplicates(tmp_path: Path):
    df = sample_retail_df()
    res = run_demo(df=df, output_dir=str(tmp_path))
    assert res["uniq"]["is_unique"] is True
    assert res["nulls"]["passed"] is True
    # files written
    assert (tmp_path / "retail_table.csv").exists()
    assert (tmp_path / "uniqueness.json").exists()
    assert (tmp_path / "nulls.json").exists()

def test_run_demo_with_duplicates(tmp_path: Path):
    df = pd.DataFrame({
        "customer": ["A","A"],
        "product":  ["X","X"],
        "quantity": [1,1],
        "price":    [2.0,2.0],
    })
    res = run_demo(df=df, output_dir=str(tmp_path))
    assert res["uniq"]["is_unique"] is False
    assert res["uniq"]["duplicate_count"] == 2
