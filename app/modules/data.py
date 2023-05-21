"""initialize the data"""
import pandas as pd

data = pd.read_csv("data/combined_data.csv")

num_data = data.drop(columns=["GEOID", "tract"])
