#####################################
#
#Author : Sahith Aitha
#Creation Date : 08/31/2024
#
#Description : This python script uses the LSTM model for predictive analysis of EC2 utilization. 
#
#####################################


import pandas as pd
import json
from datetime import datetime
from statsmodels.tsa.arima.model import ARIMA
import matplotlib.pyplot as plt

# Load data from JSON files
def load_metric_data(metric_file):
    with open(metric_file, 'r') as file:
        data = json.load(file)
    if 'Datapoints' in data and data['Datapoints']:
        df = pd.DataFrame(data['Datapoints'])
        df['MetricName'] = data['Label']
        df = df[['Timestamp', 'Average', 'MetricName']]
        df['Timestamp'] = pd.to_datetime(df['Timestamp'])
        df.set_index('Timestamp', inplace=True)
        return df
    return pd.DataFrame()

# File paths
cpu_file = 'cpu_metrics.json'
network_in_file = 'network_in_metrics.json'
network_out_file = 'network_out_metrics.json'
csv_file = 'ec2_metrics.csv'

# Load data
cpu_data = load_metric_data(cpu_file)
network_in_data = load_metric_data(network_in_file)
network_out_data = load_metric_data(network_out_file)

# Combine data and save to CSV
all_data = pd.concat([cpu_data, network_in_data, network_out_data])
all_data.to_csv(csv_file, mode='a', header=not pd.io.common.file_exists(csv_file))

# Load data for training
data = pd.read_csv(csv_file, parse_dates=['Timestamp'], index_col='Timestamp')

# Forecasting function
def forecast_metric(metric_name, data):
    df = data[data['MetricName'] == metric_name].resample('5T').mean().fillna(method='ffill')
    model = ARIMA(df['Average'], order=(5, 1, 0))
    model_fit = model.fit()
    forecast = model_fit.forecast(steps=10)
    return forecast

# Forecasting for all metrics
metrics = ['CPUUtilization', 'NetworkIn', 'NetworkOut']
for metric in metrics:
    forecast = forecast_metric(metric, data)
    print(f"Future forecast for {metric}:")
    print(forecast)

    # Plot forecast
    plt.figure(figsize=(12, 6))
    plt.plot(data[data['MetricName'] == metric].index, data[data['MetricName'] == metric]['Average'], label='Historical Data')
    plt.plot(pd.date_range(start=data.index[-1], periods=11, closed='right'), forecast, label='Forecasted Data', color='red')
    plt.xlabel('Date')
    plt.ylabel(f'{metric} Value')
    plt.title(f'{metric} Forecast')
    plt.legend()
    plt.show()

