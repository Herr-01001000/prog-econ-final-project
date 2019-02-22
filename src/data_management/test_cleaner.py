"""This function is used for testing the data cleaner function.
"""

import sys
import pytest
import json
import pandas as pd
import numpy as np

from pandas.testing import assert_frame_equal
from src.model_code.data_cleaner import data_cleaner, lag_generator
from bld.project_paths import project_paths_join as ppj


state_names = json.load(open(ppj("IN_MODEL_SPECS", "state_names.json"),
                             encoding="utf-8"))


@pytest.fixture
def setup_predict():

    out = {}
    out['data'] = pd.DataFrame(
        {
            "state": {0: "Alabama", 1: "Alabama", 2: "Alaska",
                      3: "Alaska", 4: "allUS", 5: "allUS"},
            "year": {0: 2007, 1: 2008, 2: 2007,
                     3: 2008, 4: 2007, 5: 2008},
            "var": {0: 10, 1: 15, 2: 20,
                    3: 26, 4: 30, 5: 41}
        }, columns=['state', 'year', 'var']
    )
    out['colname'] = 'state'
    out['names'] = state_names
    out['key'] = 'excluded_area'
    out['drop'] = True
    out['swap'] = True
    out['nan'] = True
    out['var'] = 'var'
    out['time'] = 'year'
    out['byvar'] = 'state'
    out['lag'] = 1

    return out


@pytest.fixture
def expected_predict():
    out = {}
    out['data'] = pd.DataFrame(
        {
            "state": {0: "AL", 1: "AL", 2: "AK", 3: "AK"},
            "year": {0: 2007, 1: 2008, 2: 2007, 3: 2008},
            "var": {0: 10, 1: 15, 2: 20, 3: 26}
        }, columns=['state', 'year', 'var']
    )
    out['lag_data'] = pd.DataFrame(
        {
            "state": {0: "Alabama", 1: "Alabama", 2: "Alaska",
                      3: "Alaska", 4: "allUS", 5: "allUS"},
            "year": {0: 2007, 1: 2008, 2: 2007,
                     3: 2008, 4: 2007, 5: 2008},
            "var": {0: 10, 1: 15, 2: 20,
                    3: 26, 4: 30, 5: 41},
            "L1_var": {0: np.nan, 1: 10, 2: np.nan,
                       3: 20, 4: np.nan, 5: 30}
        }, columns=['state', 'year', 'var', 'L1_var']
    )

    return out


def test_data_cleaner(setup_predict, expected_predict):
    clean_data = data_cleaner(setup_predict['data'],
                              setup_predict['colname'],
                              setup_predict['names'])

    assert_frame_equal(clean_data, expected_predict['data'])


def test_lag_generator(setup_predict, expected_predict):
    new_lag_data = lag_generator(setup_predict['data'],
                                 setup_predict['var'],
                                 setup_predict['time'],
                                 setup_predict['byvar'])

    assert_frame_equal(new_lag_data, expected_predict['lag_data'])


if __name__ == "__main__":
    status = pytest.main([sys.argv[1]])
    sys.exit(status)
