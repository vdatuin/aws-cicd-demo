from __future__ import annotations

from typing import Any, Dict, Iterable, Optional

import pandas as pd


def check_unique_rows(
    df: pd.DataFrame,
    subset: Optional[Iterable[str]] = None
) -> Dict[str, Any]:
    """
    Validate that rows are unique across the whole DataFrame or a column subset.

    Returns:
      dict with:
        - is_unique (bool)
        - duplicate_count (int)
        - duplicate_rows (DataFrame with duplicates; empty if none)
        - subset (tuple|None)
    """
    subset_cols = tuple(subset) if subset is not None else None
    dups_mask = df.duplicated(subset=subset_cols, keep=False)
    duplicate_rows = df[dups_mask].copy()
    return {
        "is_unique": duplicate_rows.empty,
        "duplicate_count": (
            0 if duplicate_rows.empty else int(duplicate_rows.shape[0])
        ),
        "duplicate_rows": duplicate_rows,
        "subset": subset_cols,
    }


def check_nulls(
    df: pd.DataFrame,
    columns: Optional[Iterable[str]] = None,
    fail_if_any: bool = False,
    thresholds: Optional[Dict[str, float]] = None,
) -> Dict[str, Any]:
    """
    Check nulls across all or selected columns.

    Args:
      columns: iterable of column names to check; if None, checks all.
      fail_if_any: if True, overall 'passed' is False when any null exists.
      thresholds: per-column max allowed null ratio in [0,1]; if provided,
                  overall 'passed' is False if any column exceeds its threshold.

    Returns:
      dict with:
        - null_counts (Series)
        - null_ratios (Series)
        - passed (bool)
        - evaluated_columns (list)
    """
    cols = list(columns) if columns is not None else list(df.columns)
    null_counts = df[cols].isna().sum()
    total = len(df) if len(df) > 0 else 1  # avoid divide-by-zero
    null_ratios = (null_counts / total).astype(float)

    passed = True
    if fail_if_any and null_counts.sum() > 0:
        passed = False
    if thresholds:
        for col, max_ratio in thresholds.items():
            if col in null_ratios and null_ratios[col] > max_ratio:
                passed = False

    return {
        "null_counts": null_counts,
        "null_ratios": null_ratios,
        "passed": bool(passed),
        "evaluated_columns": cols,
    }
