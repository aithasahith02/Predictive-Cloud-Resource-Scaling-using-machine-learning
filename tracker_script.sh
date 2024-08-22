#!bin/bash/

######################################
#
# Author : Sahith Aitha
# Creation Date : 8th Aug 
#
# This is a shell script that fetched the metrics from AWS and preserve the results in a CSV file for the ML model.
######################################


#!/bin/bash

# Function to append metrics to a CSV file
append_to_csv() {
    metric_name=$1
    file_name=$2
    timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    metrics=$(aws cloudwatch get-metric-statistics \
        --metric-name $metric_name \
        --start-time $(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ) \
        --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
        --period 300 \
        --namespace AWS/EC2 \
        --statistics Average \
        --dimensions Name=InstanceId,Value=i-00034a2e6c772d806 \
        --query 'Datapoints[*].[Timestamp,Average]' \
        --output text)

    echo "$metrics" | while IFS=$'\t' read -r timestamp average
    do
        echo "$timestamp,$metric_name,$average" >> $file_name
    done
}

# Create or update the CSV file with a header if it does not exist
if [ ! -f ec2_metrics.csv ]; then
    echo "Timestamp,MetricName,Average" > ec2_metrics.csv
fi

# Append metrics data to the CSV file
append_to_csv "CPUUtilization" "ec2_metrics.csv"
append_to_csv "NetworkIn" "ec2_metrics.csv"
append_to_csv "NetworkOut" "ec2_metrics.csv"

