"""The file "data_prep_population.py" convertes all demographical data from US
Census Bureau to one big data file for further analysis.

Data source: U.S. Census Bureau

"""


import numpy as np
import pandas as pd
import json

from bld.project_paths import project_paths_join as ppj
from src.model_code.data_cleaner import data_cleaner, lag_generator


def save_data(sample):
    """Save cleaned data as .dta file."""
    sample.to_stata(ppj("OUT_DATA", "population.dta"))


if __name__ == "__main__":
    state_names = json.load(open(ppj("IN_MODEL_SPECS", "state_names.json"),
                                 encoding="utf-8"))

    # Poverty data
    pov = pd.DataFrame()
    for year in list(range(2007, 2018, 1)):
        data = pd.read_csv(ppj("IN_DATA", "poverty{}.csv".format(year)),
                           header=1)
        data = data.iloc[:, [2, 5]]
        data.columns = ['state', 'population_below_poverty']
        data = data_cleaner(data, 'state', state_names)
        data['year'] = year
        pov = pov.append(data, ignore_index=True)

    # Area in squared mile, used to calulate population density later
    area = pd.read_csv(ppj("IN_DATA", "DEC_10_SF1_GCTPH1.US01PR_with_ann.csv"),
                       header=1)
    area = area[['Geographic area.1', 'Area in square miles - Total area']]
    area.rename(columns={'Geographic area.1': 'state',
                         'Area in square miles - Total area': 'total_area'},
                inplace=True)
    area = data_cleaner(area, 'state', state_names)

    # Other population demographic variables
    acs = pd.DataFrame()
    for year in list(range(2007, 2018, 1)):
        data = pd.read_csv(ppj("IN_DATA",
                               "ACS_{}_1YR_S0601_with_ann.csv".format(year)),
                           header=1)
        data = data.iloc[:, [2, 3, 27, 131, 283]]
        data.columns = ['state', 'total_population',
                        'young', 'asia', 'bachelor']
        data = data_cleaner(data, 'state', state_names)
        data['year'] = year
        data = pd.merge(data, area, on='state')
        acs = acs.append(data, ignore_index=True)

    data = pd.merge(acs, pov, on=['state', 'year'])
    data['density'] = data['total_population'] / data['total_area']
    data['poverty'] = data['population_below_poverty'] / data['total_population']
    data.drop(columns=['population_below_poverty',
                       'total_population',
                       'total_area'], inplace=True)
    data = data[['state', 'year', 'asia', 'density',
                 'young', 'bachelor', 'poverty']]
    for var in data.columns[4:]:
        data = lag_generator(data, var, 'year', 'state')

    save_data(data)
