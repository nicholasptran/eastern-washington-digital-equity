"""app"""
import os
import dash
import dash_bootstrap_components as dbc
from dash import Dash, html
from dotenv import load_dotenv

load_dotenv(".env")

DBC_CSS = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"

app = Dash(
    __name__,
    use_pages=True,
    external_stylesheets=[dbc.themes.LITERA, DBC_CSS],
    meta_tags=[
        {"name": "viewport", "content": "width=device-width, initial-scale=1"},
    ],
)
server = app.server

navbar = dbc.NavbarSimple(
    [
        dbc.NavItem(dbc.NavLink("Introduction", href="/")),
        dbc.NavItem(dbc.NavLink("Getting Started", href="/getting-started")),
        dbc.NavItem(dbc.NavLink("Collecting The Data", href="/collecting-data")),
        dbc.NavItem(dbc.NavLink("The Data", href="/the-data")),
        dbc.NavItem(
            dbc.NavLink("Classes and Functions", href="/classes-and-functions")
        ),
        dbc.DropdownMenu(
            [
                dbc.DropdownMenuItem("Analytics", header=True),
                dbc.DropdownMenuItem("PCA Method 1", href="/pca1"),
                dbc.DropdownMenuItem("PCA Method 2", href="/pca2"),
                dbc.DropdownMenuItem("PCA Method 3", href="/pca3"),
                dbc.DropdownMenuItem("PCA Method 4", href="/pca4"),
            ],
            nav=True,
            in_navbar=True,
            label="Analysis Methods",
        ),
        dbc.NavItem(dbc.NavLink("Results", href="/results")),
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
    app.run(debug=True, proxy=os.environ["DASH_PROXY"], host="0.0.0.0", port=8050)
