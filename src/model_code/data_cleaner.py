"""The file "data_cleaner.py" is consist of multiple data cleaning functions.

It can be used to:
    1. Drop multiple observations in one column of data by _obs_dropper();
    2. Replace the state names with their abbreviations by _abbr_swapper();
    3. Combine first two functions by data_cleaner();
    4. Generate lagged variables by group or not by lag_generator().

"""


def _obs_dropper(data, colname, names, key='excluded_area', nan=True):
    """Drop multiple observations in one column of data.

    Args:
        data (pd.DataFrame): original dataset which observations will be \
            dropped from

        colname (str): name of the column

        names (dict): dictionary which includes the list of observations \
            that need to be dropped

        key (str, default 'excluded_area'): the list's key in dictionary

        nan (boolean, default True): drop empty observation rows in \
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
        return new_data.dropna(subset=[colname])
    else:
        return new_data


def _abbr_swapper(data, names):
    """Replace the state names with their abbreviations.

    Args:
        data (pd.DataFrame): original dataset which need name abbreviations

        names (dict): dictionary of names and their abbreviations

    Returns:
        new_data (pd.DataFrame)
    """
    new_data = data.replace(names)

    return new_data


def data_cleaner(data, colname, names, key='excluded_area', drop=True, swap=True, nan=True):
    """Combine the function to drop multiple observations and the function
    to replace the state names with their abbreviations.

    Args:
        data (pd.DataFrame): original dataset

        colname (str): name of the column

        names (dict): dictionary which includes the list of observations \
            that need to be dropped

        key (str, default 'excluded_area'): the list's key

        drop (boolean, default True): need to drop multiple observations \
            in one column of data if True

        swap (boolean, default True): need to Replace the state names with \
            their abbreviations

        nan (boolean, default True): drop empty observation rows in \
            the column if True

    Returns:
        data (pd.DataFrame)
    """
    if drop:
        data = _obs_dropper(data, colname, names, key, nan)
        if swap:
            data = _abbr_swapper(data, names)
    else:
        if swap:
            data = _abbr_swapper(data, names)

    return data


def lag_generator(data, var, time, byvar=None, lag=1, nan=False):
    """Generate lagged variables by group or not.

    Args:
        data (pd.DataFrame): original dataset where the variable is

        var (str): name of the variable that need lag

        time (str): name of the time variable

        byvar (None or str, optional): name of the groupby variable

        lag (int, default 1): lag periods

        nan (boolean, default False): drop generated NaN due to lag if True

    Returns:
        data (pd.DataFrame)
    """
    if byvar is None:
        data = data.sort_values(time)
        data['L{}_{}'.format(lag, var)] = data[var].shift(lag)
    else:
        data = data.sort_values([byvar, time])
        data['L{}_{}'.format(lag, var)] = data[[byvar, var]].groupby(byvar).shift(lag)

    if nan is False:
        return data
    else:
        return data.dropna()
