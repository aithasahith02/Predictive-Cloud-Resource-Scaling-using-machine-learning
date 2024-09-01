# Predictive Cloud Resource Scaling Using Machine Learning

## Project Overview

Cloud resource scaling is a critical feature in cloud computing, allowing dynamic resource allocation based on workload demands. This project leverages machine learning, particularly LSTM, to predict the future state of cloud resources to optimize scaling decisions. By predicting key metrics like CPU utilization, Network In, and Network Out, this project aims to improve resource allocation efficiency and reduce costs.This project involves fetching EC2 instance metrics from AWS, storing the data in a CSV file, and using it to train an LSTM model to predict future resource utilizations. The system is designed to help in predictive cloud resource scaling by analyzing historical metrics data. This can be further enhanced to scale the resources promoting efficient utilization of cloud services.

## Project Structure

- `tracker_script.sh` : This is the script responsible for extraction of utilization metrics using AWS CLI.
- `model.py`: A Python script that fetches EC2 metrics, appends them to a CSV file, and trains an LSTM model on the data.
- `dataClean.py` : This python script is responsible for cleaning the data extracted from AWS.
- `ec2_metrics.csv`: CSV file that stores the EC2 metrics data and is updated every hour.
- `requirements.txt`: List of required Python packages.

## Prerequisites

Before running the script, ensure you have the following:

1. **AWS CLI**: Installed and configured with appropriate permissions.
2. **Python 3.x**: Installed on your system.
3. **Required Python Libraries**: Listed in `requirements.txt`.

It is strongly suggested to test this project in a virtual python environment.

For any questions or issues, feel free to contact me at aithasahith0214@gmail.com.
