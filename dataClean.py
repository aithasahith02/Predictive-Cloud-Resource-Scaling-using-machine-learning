#####################################
#
#Author : Sahith Aitha
#Date Created : 8/31/2024
#
#Description : This is the python script intended to clean the NULL values in the CSV file.
#####################################

import pandas as pd

#Loading the Data from the CSV file saved by the test_tracker script.
data = pd.read_csv('ec2_metrics.csv', parse_dates=['Timestamp'], index_col='Timestamp')

#Checking for missing values in the file
print("Missing values per column:")
print(data.isnull().sum())

#Filling the NULL values using FillNA
data.fillna(method='ffill', inplace=True)

#Sorting the records by Timestamp
data.sort_index(inplace=True)

print("Data after cleaning:")
print(data.head())

