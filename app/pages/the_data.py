"""the_data page"""
import dash
import dash_bootstrap_components as dbc
from dash import html, dcc
import pandas as pd
from modules.datatable import (  # pylint: disable=import-error
    create_dt,
    conditional_formatting,
)

from modules.pca import data  # pylint: disable=import-error

dash.register_page(__name__)

(styles_corr, legend) = conditional_formatting(data.data.corr())
(styles_cov, legend) = conditional_formatting(data.cov)

the_data_dt = create_dt(
    data.data.to_dict("records"),
    ([{"name": i, "id": i} for i in data.data.columns]),
)

scaled_dt = create_dt(
    data.scaled.to_dict("records"),
    ([{"name": i, "id": i} for i in data.scaled.columns]),
)

corr_dt = create_dt(
    data.data.corr().round(5).to_dict("records"),
    ([{"name": i, "id": i} for i in data.data.columns]),
    styles_corr,
)

cov_dt = create_dt(
    data.cov.to_dict("records"),
    ([{"name": i, "id": i} for i in data.cov.columns]),
    styles_cov,
)

eigenval_dt = create_dt(
    data.eigenvalues.reset_index().to_dict("records"),
    ([{"name": i, "id": i} for i in data.eigenvalues.reset_index().columns]),
)

loadings_dt = create_dt(
    data.loadings.reset_index().to_dict("records"),
    ([{"name": i, "id": i} for i in data.loadings.reset_index().columns]),
)

kmo_dt = create_dt(
    data.kmo.to_dict("records"), ([{"name": i, "id": i} for i in data.kmo.columns])
)

layout = dbc.Container(
    html.Div(
        [
            html.H1("Data"),
            the_data_dt,
            html.H1("Scaled Data"),
            scaled_dt,
            html.H1("Correlation Matrix"),
            corr_dt,
            html.H1("Covariance Matrix"),
            cov_dt,
            html.H1("Eigenvalues"),
            eigenval_dt,
            html.H1("Loadings"),
            loadings_dt,
            html.H1(f"KMO, total = {data.total_kmo}"),
            kmo_dt,
            html.H1("Scree Plot"),
            dcc.Graph(figure=data.scree),
        ]
    ),
    className="dbc",
)
