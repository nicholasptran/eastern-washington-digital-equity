"""app"""

import dash
import dash_bootstrap_components as dbc
from dash import Dash, html

DBC_CSS = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"

app = Dash(
    __name__,
    use_pages=True,
    external_stylesheets=[dbc.themes.LITERA, DBC_CSS],
    meta_tags=[
        {"name": "viewport", "content": "width=device-width, initial-scale=1"},
    ],
)

navbar = dbc.NavbarSimple(
    [
        dbc.NavItem(dbc.NavLink("Test", href="/test")),
        dbc.NavItem(dbc.NavLink("Collecting The Data", href="/collecting-data")),
        dbc.NavItem(dbc.NavLink("analysis", href="/analysis")),
    ],
    brand="Eastern Washington Digital Equity",
    brand_href="/",
    color="primary",
    dark=True,
)

app.layout = html.Div(
    [
        navbar,
        dash.page_container,
    ]
)

if __name__ == "__main__":
    app.run(debug=True)
