"""home.py page"""
import dash
import dash_bootstrap_components as dbc
from dash import html

dash.register_page(__name__, path="/")

layout = dbc.Container(html.Div(html.H1("Home"), className="dbc"))
