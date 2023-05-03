"""getting started page"""
import dash
import dash_bootstrap_components as dbc
from dash import html

dash.register_page(__name__)

layout = dbc.Container(html.Div(html.H1("Getting Started"), className="dbc"))
