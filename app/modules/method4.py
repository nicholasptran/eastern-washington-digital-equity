from .pca import data, PCA
import pandas as pd
from sklearn.model_selection import train_test_split
from statsmodels.stats.outliers_influence import variance_inflation_factor as VIF
from sklearn import linear_model as lm
from mlxtend.feature_selection import SequentialFeatureSelector as SFS
from pingouin import cronbach_alpha
from scipy.stats import pearsonr

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
        "smartphone_only",
    ]
)
data_method_4 = PCA(data_method_4)

data_method_4.weights = data_method_4.calculate_weights(3)
data_method_4.scaled["index"] = data_method_4.scaled @ data_method_4.weights
weights_df = (
    pd.DataFrame(data_method_4.weights)
    .reset_index()
    .rename(columns={0: "coefficients"})
)

pd.options.display.float_format = "{:.10f}".format

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

# calculate the adj r2
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

# coefficients and vif
fin_df = pd.DataFrame(-model.coef_, model.feature_names_in_)
fin_df["vif"] = [VIF(final_X.values, i) for i in range(final_X.shape[1])]
fin_df = fin_df.rename(columns={0: "coefficient"})

# creating the final dataframe
coefficients = -model.coef_
final_vars = list(model.feature_names_in_)
final_data = data.scaled[final_vars]
final_data["index"] = final_data.mul(coefficients).sum(axis=1)

cronbach_a = cronbach_alpha(final_data)[0]
