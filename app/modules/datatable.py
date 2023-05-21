from dash import dash_table, html


def create_dt(data, columns, style=None):
    """Create DT.

    Args:
        columns (Array): Pass {'name': '', 'id': '', 'type': ''}
        style (object, optional): Pass
        (styles, legend) = conditional_formatting(data, 7, columns=["col"])
        if you want conditional formatting. Defaults to None.

    Returns:
        DataTable: Returns a datatable.
    """
    if style is None:
        datatable = dash_table.DataTable(
            data=data,
            columns=columns,
            style_table={
                "height": "300px",
                "overflowY": "auto",
                "overflowX": "auto",
            },
            style_header={"position": "sticky", "top": 0},
            sort_action="native",
            filter_action="native",
        )
    else:
        datatable = dash_table.DataTable(
            data=data,
            columns=columns,
            style_table={
                "height": "300px",
                "overflowY": "auto",
                "overflowX": "auto",
            },
            style_header={"position": "sticky", "top": 0},
            style_data_conditional=style,
            page_action="native",
            sort_action="native",
            filter_action="native",
        )

    return datatable


def conditional_formatting(data, n_bins=7, columns="all"):
    """this is used to add a conditional formatting to dts
    with a color scale. it's defaulted to 7 bins, as RdYlGn cannot do more than that.

    Use this if you want to format all numeric columns:
    (styles, legend) = conditional_formatting(data)

    Use this if you want to specify which columns to format:
    (styles, legend) = conditional_formatting(data, columns=['column1', 'column2'])

    https://dash.plotly.com/datatable/conditional-formatting
    https://stackoverflow.com/questions/63372283/python-dash-table-conditional-formatting-color-scale
    https://plotly.com/python/builtin-colorscales/
    https://github.com/plotly/colorlover

    Args:
        data (DataFrame): The name of the pd.DataFrame
        n_bins (int, optional): The number of colors you want. Defaults to 7.
        columns (str, optional): Leave empty to condition all numeric columns. Put
        columns in an array if you want to specify which ones get formatted. Defaults to 'all'.

    Returns:
        html: Returns styles and legend. You can put the legend in the html.Div to show the scale.
        Put style_data_conditional=styles in your DT.
    """
    import colorlover

    bounds = [i * (1.0 / n_bins) for i in range(n_bins + 1)]

    if columns == "all":
        if "id" in data:
            data_numeric_col = data.select_dtypes("number").drop(["id"], axis=1)
        else:
            data_numeric_col = data.select_dtypes("number")
    else:
        data_numeric_col = data[columns]

    data_max = data_numeric_col.max().max()
    data_min = data_numeric_col.min().min()
    ranges = [((data_max - data_min) * i) + data_min for i in bounds]

    styles = []
    legend = []

    for i in range(1, len(bounds)):
        min_bound = ranges[i - 1]
        max_bound = ranges[i]
        backgroundColor = colorlover.scales[str(n_bins + 4)]["div"]["RdYlGn"][2:-2][
            i - 1
        ]
        color = "black"

        for column in data_numeric_col:
            styles.append(
                {
                    "if": {
                        "filter_query": (
                            "{{{column}}} >= {min_bound}"
                            + (
                                " && {{{column}}} < {max_bound}"
                                if (i < len(bounds) - 1)
                                else ""
                            )
                        ).format(
                            column=column, min_bound=min_bound, max_bound=max_bound
                        ),
                        "column_id": column,
                    },
                    "backgroundColor": backgroundColor,
                    "color": color,
                }
            )
        legend.append(
            html.Div(
                style={"display": "inline-block", "width": "60px"},
                children=[
                    html.Div(
                        style={
                            "backgroundColor": backgroundColor,
                            "borderLeft": "1x rgb(50, 50, 50) solid",
                            "height": "10px",
                        }
                    ),
                    html.Small(round(min_bound, 2), style={"paddingLeft": "2px"}),
                ],
            )
        )
    return (styles, html.Div(legend, style={"padding": "5px 0 5px 0"}))
