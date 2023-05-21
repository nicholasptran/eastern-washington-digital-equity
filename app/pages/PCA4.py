"""PCA4 page"""
import dash
import dash_bootstrap_components as dbc
from dash import html, dcc
from modules.datatable import create_dt  # pylint: disable=import-error
from modules.method4 import (  # pylint: disable=import-error
    data_method_4,
    weights_df,
    results,
    fin_df,
    final_data,
    cronbach_a,
    adj_r2,
)

dash.register_page(__name__)

layout = dbc.Container(
    html.Div(
        [
            html.H1("PCA Method 4"),
            html.Br(),
            html.H2("Steps"),
            html.P("Determine how many PCs to use"),
            html.P(
                "Calculate coefficients for each variable by multiplying each row in loadings by the respective eigenvalue"
            ),
            html.P(
                "Multiply standardized data by coefficients, take the sum, and append to df as the index column"
            ),
            html.P(
                "Use stepwise regression for feature selection and new coefficients"
            ),
            html.P("Create a new index column using the new weights"),
            html.P("Calculate the reliability of the new index using cronbach alpha"),
            html.P("K means cluster analysis"),
            html.P("Visualize"),
            html.Br(),
            html.H3("Determine Number of PCs to Use"),
            dcc.Markdown(
                """
We already went through the stepwise multiple times and found the optimal variables

```python
data_method_4 = data.data.drop(
    columns=[
        "has_computer",
        "smartphone",
        "desktop_or_laptop",
        "tablet_or_portable",
        "foreign_born",
        "broadband",
        "median_income",
        "naturalized_citizen",
        "desktop_or_laptop_only",
        "satellite",
        "dial_up",
        "other_internet_service",
        "not_citizen",
        "no_internet_access",
        "number_providers",
        "mean_income",
        "mean_u_mbps",
        "access_with_no_subscription",
        "sixty_five_and_older",
        "lowest_cost",
        "smartphone_only"
    ]
)
data_method_4 = PCA(data_method_4)
```

Display the eigenvalues, scree plot, and percent explained. The number of eigenvalues over 1, a scree plot, or 
explaining 70% of the variance in the data are good ways to choose your number of PCs

```python
data_method_4.eigenvalues
data_method_4.scree
data_method_4.percent_explained
```
                         """
            ),
            html.H4("Eigenvalues"),
            create_dt(
                data_method_4.eigenvalues.reset_index().to_dict("records"),
                (
                    [
                        {"name": i, "id": i}
                        for i in data_method_4.eigenvalues.reset_index().columns
                    ]
                ),
            ),
            html.Br(),
            html.H4("Percent Explained"),
            create_dt(
                data_method_4.percent_explained.reset_index().to_dict("records"),
                (
                    [
                        {"name": i, "id": i}
                        for i in data_method_4.percent_explained.reset_index().columns
                    ]
                ),
            ),
            html.Br(),
            html.H4("Scree Plot"),
            dcc.Graph(figure=data_method_4.scree),
            html.Br(),
            html.H3("Create The Index"),
            dcc.Markdown(
                """
Calculate the coefficients

```python
data_method_4.weights = data_method_4.calculate_weights(3)
```

Create the index column
```python
data_method_4.scaled["index"] = data_method_4.scaled @ data_method_4.weights
```
                         """
            ),
            html.Br(),
            html.H4("Coefficients"),
            create_dt(
                weights_df.to_dict("records"),
                ([{"name": i, "id": i} for i in weights_df.columns]),
            ),
            html.Br(),
            html.H4("First Index"),
            create_dt(
                data_method_4.scaled.to_dict("records"),
                ([{"name": i, "id": i} for i in data_method_4.scaled.columns]),
            ),
            html.Br(),
            html.H3("Stepwise Regression"),
            dcc.Markdown(
                """
Create a machine learning model to select our final model
note: Can be improved
```python

# set y as index. we want to predict the index
y = data_method_4.scaled["index"]

# set x as the data we will use to predict y
X = data_method_4.scaled.drop("index", axis=1)

# setting the train/test data parameters
# train on 50% of the data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.5, random_state=55  # this is how you pick random data
)

# test on 40% of the test data
X_test, X_valid, y_test, y_valid = train_test_split(
    X_test, y_test, test_size=0.4, random_state=55
)

lr = lm.LinearRegression()
sfs = SFS(
    lr,
    k_features="parsimonious",  # uses the least variables
    verbose=0,  # too much output if it's = 1
    forward=True,  # you can choose whatever
    scoring="r2",  # picks model on r2
    cv=5,  # 5 stratified k-fold splits (that's the default)
    n_jobs=-1,  # uses all of the cpus your computer has
)

# fitting the parameterized data to the model
sfs.fit(X_train, y_train)

results = pd.DataFrame.from_dict(sfs.get_metric_dict()).T

# the machine picks the best model with the least variables. it will always pick the first r2 = 1
# r2 can = 1 because our y is made up of our Xs
# this picks the one before r2 = 1
largest_before_1 = results[results["avg_score"] != 1].tail(1).index.to_list()
largest_before_1 = largest_before_1[0] - 1
```

Calculate the adj r2

```python
model_vars = list(results.iloc[largest_before_1, 3])
model_vars

final_X = data_method_4.scaled[model_vars]
final_y = data_method_4.scaled["index"]

model = lr
model.fit(final_X, final_y)

r2 = model.score(final_X, final_y)

observations = final_X.shape[0]
predictors = final_X.shape[1]

adj_r2 = 1 - (1 - r2) * (observations - 1) / (observations - predictors - 1)
```

Getting the VIFs and final coefficients

```python
fin_df = pd.DataFrame(-model.coef_, model.feature_names_in_)
fin_df["vif"] = [VIF(final_X.values, i) for i in range(final_X.shape[1])]
fin_df = fin_df.rename(columns={0:"coefficient"})
```

Make a the final df

```python
coefficients = -model.coef_
final_vars = list(model.feature_names_in_)
final_data = data.scaled[final_vars]
final_data["index"] = final_data.mul(coefficients).sum(axis=1)
```
                         """
            ),
            html.Br(),
            html.H4(f"Adj r2 = {adj_r2}"),
            html.Br(),
            html.H4("Final Coefficients and VIFs"),
            create_dt(
                fin_df.reset_index().to_dict("records"),
                ([{"name": i, "id": i} for i in fin_df.reset_index().columns]),
            ),
            html.Br(),
            html.H4("Final Dataset"),
            create_dt(
                final_data.to_dict("records"),
                ([{"name": i, "id": i} for i in final_data.columns]),
            ),
            html.Br(),
            html.H3(f"Cronbach Alpha = {cronbach_a}"),
            dcc.Markdown(
                """
```python
cronbach_alpha(final_data)[0]
```

A cronbach alpha of >= .7 means that the index is reliable. .69 is close enough for us.

                         """
            ),
            html.Br(),
            html.H3("Clustering"),
            html.Br(),
            html.H3(""),
            html.Br(),
            html.H3(""),
        ]
    ),
    className="dbc",
)
