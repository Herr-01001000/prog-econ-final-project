import numpy as np
import pandas as pd


class Cleaner:

    """Cleaner is consist of multiple data cleaning functions.

    It can be used to:
        1. Drop multiple observations in one column of data by obs_dropper();
        2. Replace the state names with their abbreviations by abbr_swapper();
        3. Combine first two functions by data_cleaner();
        4. Generate lagged variables by group or not by lag_generator().

    """

    def obs_dropper(data, colname, names, key='excluded_area', nan=True):
        """Drop multiple observations in one column of data.
        Args:
            data (pd.DataFrame): original dataset which observations will be
                dropped from
            colname (str): name of the column
            names (dict): dictionary which includes the list of observations
                that need to be dropped
            key (str, default 'excluded_area'): the list's key
            nan (boolean, default True): drop empty observation rows in
                the column if True
        Returns:
            new_data (pd.DataFrame)
        """
        list = data[colname].unique().tolist()
        for i in list[:]:
            if i in names[key]:
                list.remove(i)
        new_data = data[data[colname].isin(list)]

        if nan:
            return new_data.dropna(subset=[colname], inplace=True)
        else:
            return new_data

    def abbr_swapper(data, names):
        """Replace the state names with their abbreviations.
        Args:
            data (pd.DataFrame): original dataset which need name abbreviations
            names (dict): dictionary of names and their abbreviations
        Returns:
            data (pd.DataFrame)
        """
        return data.replace(names, inplace=True)

    def data_cleaner(data, drop=True, swap=True, nan=True, colname, names, key='excluded_area'):
        """Combine the function to drop multiple observations and the function
        to replace the state names with their abbreviations.
        Args:
            data (pd.DataFrame): original dataset
            drop (boolean, default True): need to drop multiple observations
                in one column of data if True
            swap (boolean, default True): need to Replace the state names with
                their abbreviations
            nan (boolean, default True): drop empty observation rows in
                the column if True
            colname (str): name of the column
            names (dict): dictionary which includes the list of observations
                that need to be dropped
            key (str, default 'excluded_area'): the list's key
        Returns:
            data (pd.DataFrame)
        """
        if drop:
            obs_dropper(data, colname, names, key, nan)
            if swap:
                abbr_swapper(data, names)
        else:
            if swap:
                abbr_swapper(data, names)

        return data

    def lag_generator(data, var, byvar=None, lag=1, nan=False):
        """Generate lagged variables by group or not.
        Args:
            data (pd.DataFrame): original dataset where the variable is
            var (str): name of the variable that need lag
            byvar (None or str, optional): name of the groupby variable
            lag (int, default 1): lag periods
            nan (boolean, default False): drop generated NaN due to lag if True
        Returns:
            data (pd.DataFrame)
        """
        if byvar is None:
            data['L{}_{}'.format(lag, var)] = data[var].shift(lag)
        else:
            data['L{}_{}'.format(lag, var)] = data[[var, byvar]].groupby(byvar).shift(lag)

        if nan:
            return data
        else:
            return data.dropna(inplace=True)
