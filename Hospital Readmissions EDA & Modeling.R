library(readr)
library(curl)
# Load Train data
patient_data <- read_csv("https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1_Case_Info/A2_Hospital_Readmission/caseData/diabetesPatientTrain.csv")
medicine_data <- read_csv("https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1_Case_Info/A2_Hospital_Readmission/caseData/diabetesMedsTrain.csv")
demographic_data <- read_csv("https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1_Case_Info/A2_Hospital_Readmission/caseData/diabetesHospitalInfoTrain.csv")
# Test data
patient_test<-read_csv("https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1_Case_Info/A2_Hospital_Readmission/caseData/diabetesPatientTest.csv")
medicine_test<-read_csv("https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1_Case_Info/A2_Hospital_Readmission/caseData/diabetesMedsTest.csv")
demo_test<-read_csv("https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1_Case_Info/A2_Hospital_Readmission/caseData/diabetesHospitalInfoTest.csv")


# Merge train data sets
merged_data <- merge(patient_data, medicine_data, by = "tmpID")
merged_data <- merge(merged_data,demographic_data, by = "tmpID")

# Merge test data sets
test_data<- merge(patient_test, medicine_test, by = "tmpID")
test_data <- merge(test_data, demo_test, by = "tmpID")

# Check for missing values
sum(is.na(merged_data))# number of missing
sum(is.na(test_data))# number of missing

merged_data <- na.omit(merged_data) # remove records with missing values

test_data <- na.omit(test_data) # remove records with missing values

## Exploratory Data analysis
# Plot histogram of age variable
hist(merged_data$age)

# Generate summary statistics for each variable
summary(merged_data)

# Create scatterplot of age vs. number of lab procedures
plot(merged_data$age, merged_data$num_lab_procedures)

# Convert target variable to binary
merged_data$readmitted_y <- ifelse(merged_data$readmitted_y == "FALSE", 0, 1)
merged_data$readmitted_y<-as.factor(merged_data$readmitted_y)

test_data$readmitted_y <- ifelse(test_data$readmitted_y == "FALSE", 0, 1)
test_data$readmitted_y<-as.factor(test_data$readmitted_y)
#count unique values for each variable
sapply(lapply(merged_data, unique), length)

# Remove unnecessary columns
merged_data<-merged_data[,-c(42,43,44)]
merged_data <- subset(merged_data, select = -c(payer_code, race,medical_specialty,citoglipton,examide,discharge_disposition_id, troglitazone,acetohexamide))

test_data<-test_data[,-c(42,43,44)]
test_data <- subset(test_data, select = -c(payer_code,race, medical_specialty,citoglipton,examide,discharge_disposition_id, troglitazone,acetohexamide))

# replace ? values with NA
merged_data[merged_data == "?"] <- NA
merged_data<-na.omit(merged_data)
# Format dataset
names<-colnames(test_data)
merged_data<-subset(merged_data,select = names)
# Constructing model
# Train a logistic regression model
library(caret)
log_model1 <- glm(readmitted_y ~ ., data = merged_data, family = "binomial")
library(MASS)
# Stepwise regression model
step_model <- stepAIC(log_model1, direction = "both", 
                      trace = FALSE)
summary(step_model)
step_model
# Predict 100 patients to be readmitted
pred1<-predict(step_model,test_data)

confusionMatrix(pred, test_data$readmitted_y)
table(coefficients(step_model))


# Predict the probabilities of readmission for the test data
probabilities <- predict(log_model, newdata = test_data, type = "prob")

# Create a dataframe with the predicted probabilities and patient IDs
predictions <- data.frame(ID = test_data$tmpID, probability = probabilities[, 2])

# Sort the dataframe by probability and select the top 100 patients
library(dplyr)
top_patients <- predictions %>% arrange(desc(probability)) %>% slice(1:100)
View(top_patients)
# View the top 100 patients
head(top_patients)

# Select rows based on list
ids<-top_patients$ID
sub<-test_data[test_data$tmpID %in% c(names),]
# EDA for the top 100 patients
hist(sub$age)
)
library(dplyr)
table(as.factor(sub$repaglinide))
table(as.factor(sub$max_glu_serum))
table(as.factor(sub$miglitol))
table(as.factor(sub$tolazamide))
table(as.factor(test_data$number_outpatient))
table(as.factor(sub$num_procedures))
table(as.factor(sub$insulin))
table(as.factor(sub$diabetesMed))



