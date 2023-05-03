import os
os.chdir("app")

from modules.pca import PCA, dataset

data = PCA(dataset)

data.data.columns
