import pandas as pd
import importlib

def test_retail_imports_and_has_df_creator():
    retail = importlib.import_module("retail")  # because PYTHONPATH=src
    df = retail.sample_retail_df()
    assert isinstance(df, pd.DataFrame)
    assert set(df.columns) == {"customer","product","quantity","price"}
