# Hospital-Readmissions-EDA-Modeling

The summary of the project is as follows:

Data Loading:

The project starts by loading the train and test datasets for the analysis.
Three datasets are loaded: patient_data, medicine_data, and demographic_data for train data, and patient_test, medicine_test, and demo_test for test data.
Data Merging:

The train datasets are merged into a single dataset called merged_data using the tmpID column as the merging key.
The test datasets are merged into a single dataset called test_data using the tmpID column as the merging key.
Missing Value Handling:

The project checks for missing values in both merged_data and test_data.
Missing values are identified and handled by removing records with missing values using the na.omit() function.
Exploratory Data Analysis (EDA):

Histogram of the age variable is plotted using the hist() function.
Summary statistics of merged_data are generated using the summary() function.
Scatterplot of age vs. num_lab_procedures is created using the plot() function.
Data Preprocessing:

The target variable readmitted_y is converted to binary values (0 and 1) using the ifelse() function.
Categorical variables are converted to factors using the as.factor() function.
Unnecessary columns are removed from merged_data and test_data.
Any remaining "?" values in merged_data are replaced with NA.
Model Construction:

A logistic regression model (log_model1) is trained using the glm() function with readmitted_y as the dependent variable.
Stepwise regression is performed using the stepAIC() function to select the most significant variables for the model.
The summary of the stepwise regression model (step_model) is displayed.
Model Evaluation:

The model is used to predict the readmission status for the test data using the predict() function.
Confusion matrix is computed using the confusionMatrix() function to evaluate the model's performance.
The coefficients of the stepwise regression model are displayed using the table() function.
Probability Prediction:

The probabilities of readmission are predicted for the test data using the trained logistic regression model.
A dataframe (predictions) is created with the patient IDs and predicted probabilities.
The dataframe is sorted by probability, and the top 100 patients are selected.
The top 100 patients are viewed using the head() function.
EDA for Top 100 Patients:

EDA is performed for the top 100 patients by analyzing the distributions of various variables using the table() and hist() functions.
This project focuses on predicting hospital readmission for diabetes patients using logistic regression and performing exploratory data analysis on the datasets.




