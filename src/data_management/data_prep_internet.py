"""The file "data_prep_internet.py" cleans the data from
ntia-analyze-table.csv. It prepares internet use data for further analysis.

Data source: National Telecommunications and Information Administration
    United States Department of Commerce
    https://www.ntia.doc.gov/data/digital-nation-data-explorer#sel=internetUser&disp=map

"""


import numpy as np
import pandas as pd
import re

from bld.project_paths import project_paths_join as ppj
from src.model_code.data_cleaner import lag_generator


def save_data(sample):
    """Save cleaned data as .dta file."""
    sample.to_stata(ppj("OUT_DATA", "internet.dta"))


def finder(list):
    """Find a specific pattern in a list by regular expression.

    Args:
        list (list): the list where the function searches

    Returns:
        container (list)
    """
    container = []
    for string in list:
        match = re.findall(r'^[A-Z][A-Z]Prop$', string)
        if match is not None:
            container += match

    return container


def add_year(data, years):
    """Add missing year observations to data.

    Arg:
        data (pd.DataFrame): dataset with missing year observations

        years (list): list of missing years(int)

    Returns:
        data (pd.DataFrame)
    """
    for t in years:
        df = data.loc[data.year.isin([t - 1, t + 1])].mean().to_frame().T
        data = data.append(df, ignore_index=True)

    data = data.sort_values('year')

    return data


if __name__ == "__main__":
    data = pd.read_csv(ppj("IN_DATA", "ntia-analyze-table.csv"))

    columns = ['dataset', 'variable'] + finder(data.columns)
    data = data[data.variable == 'internetUser'][columns]
    data = data[~data['dataset'].str.contains(r'^\w{3}\s\d{2}[90][8013]$',
                                              regex=True)]
    data.drop(columns='variable', inplace=True)
    data.rename(columns={'dataset': 'year'}, inplace=True)
    data.year = data.year.str[4:].astype(np.int)
    data = add_year(data, [2008, 2014, 2016])
    data = data.melt(id_vars=['year'],
                     value_vars=finder(data.columns),
                     var_name='state',
                     value_name='internet')
    data.state = data.state.str[:2]
    data = lag_generator(data, 'internet', 'year', 'state')

    save_data(data)
