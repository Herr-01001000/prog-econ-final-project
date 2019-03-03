"""The file "data_prep_unemployment.py" cleans the data from staadata.xlsx.
It prepares internet use data for further analysis.

Data source: Bureau of Labor Statistics, https://www.bls.gov/lau/rdscnp16.htm

"""


import numpy as np
import pandas as pd
import json

from bld.project_paths import project_paths_join as ppj
from src.model_code.data_cleaner import data_cleaner, lag_generator


def save_data(sample):
    """Save cleaned data as .dta file."""
    sample.to_stata(ppj("OUT_DATA", "unemployment.dta"))


if __name__ == "__main__":
    state_names = json.load(open(ppj("IN_MODEL_SPECS", "state_names.json"),
                                 encoding="utf-8"))
    data = pd.read_excel(ppj("IN_DATA", "staadata.xlsx"))

    data = data.iloc[:, [1, 2, 9]].dropna()
    data.columns = ['state', 'year', 'unemployment']
    data['year'] = data['year'].astype(np.int)
    data['unemployment'] = data['unemployment'].astype(np.float)

    data = data_cleaner(data[data.year > 2006], 'state', state_names)
    data = lag_generator(data, 'unemployment', 'year', 'state')

    save_data(data)
