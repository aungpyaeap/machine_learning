import pandas as pd
from matplotlib import pyplot as plt

dataset = pd.read_csv('Salary_Data.csv')
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, -1].values

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=1/3, random_state=0)

# fitting simple linear regression
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(X_train, y_train)

# predict test set results
y_pred = regressor.predict(X_test)

# visualize training set
plt.scatter(X_train,y_train,color='red')
plt.plot(X_train, regressor.predict(X_train), color='blue')
plt.title('salary vs experience (training set)')
plt.xlabel('years of experience')
plt.ylabel('salary')
plt.show()

# visualize test set
plt.scatter(X_test,y_test,color='red')
plt.plot(X_train, regressor.predict(X_train), color='blue')
plt.title('salary vs experience (test set)')
plt.xlabel('years of experience')
plt.ylabel('salary')
plt.show()
