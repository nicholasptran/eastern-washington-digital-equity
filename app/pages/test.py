"""test.py page"""
import dash
import dash_bootstrap_components as dbc
from dash import html

dash.register_page(__name__)

layout = dbc.Container(html.Div("test", className="dbc"))
