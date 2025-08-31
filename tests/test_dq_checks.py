import pandas as pd
from dq_utils import check_unique_rows, check_nulls

def test_check_unique_rows_detects_duplicates():
    df = pd.DataFrame({"id": [1,1,2], "val": ["a","a","b"]})
    res = check_unique_rows(df, subset=["id","val"])
    assert res["is_unique"] is False
    assert res["duplicate_count"] == 2
    assert not res["duplicate_rows"].empty

def test_check_nulls_thresholds_and_any():
    df = pd.DataFrame({"a": [1, None, 3], "b": [None, None, 1]})
    assert check_nulls(df, fail_if_any=True)["passed"] is False
    assert check_nulls(df, thresholds={"b": 0.5})["passed"] is False
    assert check_nulls(df, thresholds={"b": 0.7})["passed"] is True
