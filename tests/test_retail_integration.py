import pandas as pd
from retail import sample_retail_df

def test_sample_retail_df_shape_and_columns():
    df = sample_retail_df()
    assert isinstance(df, pd.DataFrame)
    assert set(df.columns) == {"customer","product","quantity","price"}
    assert len(df) > 0
