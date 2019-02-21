"""
"""


import numpy as np
import pandas as pd
import json

from bld.project_paths import project_paths_join as ppj


def save_data(sample):
    sample.to_stata(ppj("OUT_DATA", "gdp.dta"))


if __name__ == "__main__":
    state_names = json.load(open(ppj("IN_MODEL_SPECS", "state_names.json"), encoding="utf-8"))
    data = pd.read_csv(ppj("IN_DATA", "SAGDP2N__ALL_AREAS_1997_2017.csv"))
    
    excluded_years = [str(i) for i in list(range(1997, 2007, 1))]
    data.drop(columns=excluded_years, inplace=True)
    data.drop(columns=['GeoFIPS', 'Region', 'TableName', 'ComponentName',
        'Unit', 'IndustryClassification', 'Description'], inplace=True)
    
    areas = data['GeoName'].unique().tolist()
    for area in areas[:]:
        if area in state_names['excluded_area']:
            areas.remove(area)
    data = data[(data.GeoName.isin(areas)) & (data.IndustryId==1)]

    data.replace(state_names, inplace=True)
    
    data = pd.wide_to_long(data, ['20'], i='GeoName', j='year').reset_index()
    
    data.rename(columns={'GeoName':'state', '20':'gdp'}, inplace=True)    
    data['year'] = data['year'].astype(np.int) + 2000
    data['gdp'] = data['gdp'].astype(np.float)
    data.drop(columns=['IndustryId'], inplace=True)

    
    save_data(data)
