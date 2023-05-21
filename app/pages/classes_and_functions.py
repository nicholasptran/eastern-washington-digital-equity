"""classes and functions page"""
import dash
import dash_bootstrap_components as dbc
from dash import html, dcc

dash.register_page(__name__)

layout = dbc.Container(
    html.Div(
        [
            html.H1("Classes and Functions"),
            dcc.Markdown(
                '''
Note: due to this code being under GNU v3.0, you must open source your code if you use any 
of this (plus other GNU v3.0 stuff). 

## PCA Class

```python
class PCA:
    """Input a df and get many things back.
    https://stackoverflow.com/questions/13224362/principal-component-analysis-pca-in-python
    """

    def __init__(self, df):
        self.data = df

        # scale data
        self.scaled = pd.DataFrame(scaler.fit_transform(df), columns=df.columns)

        # kmo, total kmo
        self.kmo, self.total_kmo = calculate_kmo(self.scaled)
        self.kmo = pd.DataFrame(self.data.columns, self.kmo).reset_index()
        self.kmo = self.kmo.rename(columns={"index": "KMO", 0: "Variables"})

        # center data
        self.center = self.scaled.apply(lambda x: x - x.mean())

        # covariance
        self.cov = pd.DataFrame(
            np.cov(self.center, rowvar=False),
            columns=self.scaled.columns,
            index=self.scaled.columns,
        )

        # eigenvalues and loadings(eigenvectors)
        self.eigenvalues, self.loadings = LA.eigh(self.cov)

        # sort eigenvalues and loadings from
        sorter = np.argsort(self.eigenvalues)[::-1]
        self.loadings = self.loadings[:, sorter]
        self.eigenvalues = self.eigenvalues[sorter]

        pc_list = ["pc" + str(i + 1) for i in range(len(self.eigenvalues))]

        # turn into dataframe
        self.loadings = pd.DataFrame(
            self.loadings, index=self.scaled.columns, columns=pc_list
        )
        self.eigenvalues = pd.DataFrame(self.eigenvalues, index=pc_list, columns=["eigenvalues"])

        # pca scores - scaled data * loadings
        self.scores = self.scaled @ self.loadings

        # percent explained
        explained_variance = self.eigenvalues / self.eigenvalues.sum() * 100
        self.percent_explained = pd.DataFrame(explained_variance).round(2)

        self.percent_explained[
            "cumulative_explained_variance"
        ] = self.percent_explained.cumsum().round(2)
        self.percent_explained.columns.values[0] = "explained_variance"

        # scree plot
        self.scree = (
            px.line(
                self.percent_explained,
                x=pc_list,
                y="cumulative_explained_variance",
                text="cumulative_explained_variance",
                color=px.Constant("cumulative explained variance"),
            )
            .update_traces(textposition="top left")
            .add_bar(
                x=pc_list,
                y=self.percent_explained.explained_variance,
                name="explained variance",
                text=self.percent_explained.explained_variance,
            )
        )

    def calculate_weights(self, number_of_components):
        """calculate coefficients using your eigenvalues. Multiplies each row by the respective
        eigenvalue. Row 1 of loadings will be multiplied by eigenvalue 1. Row 2 with 2. You may
        only use this when you have at least 2 pcs.

        Args:
            number_of_components (int): number of pcs you want to use.

        Returns:
            DataFrame: Returns a dataframe of weights.
        """
        weights = (
            self.loadings.iloc[:, 0:number_of_components]
            .mul(
                [
                    float(self.eigenvalues.iloc[i, :])
                    for i in range(len(self.eigenvalues))
                ],
                axis=0,
            )
            .sum(axis=1)
        )
        return weights
```

## Getting the Pearson Correlation p values

```python
def pearsonr_pval(x, y):
    return pearsonr(x, y)[1]
```
'''
            ),
        ]
    ),
    className="dbc",
)
