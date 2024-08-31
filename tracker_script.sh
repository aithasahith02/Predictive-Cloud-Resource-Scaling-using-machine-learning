#!bin/bash/

######################################
#
# Author : Sahith Aitha
# Creation Date : 8th Aug 
#
# This is a shell script that fetched the metrics from AWS and preserve the results in a CSV file for the ML model.
######################################


#!/bin/bash

# AWS CLI command to fetch metrics
get_metric_statistics() {
    aws cloudwatch get-metric-statistics \
        --metric-name "$1" \
        --start-time "$(date -u -d '1 hour ago' +"%Y-%m-%dT%H:%M:%SZ")" \
        --end-time "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
        --period 60 \
        --namespace AWS/EC2 \
        --statistics Average \
        --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
        --output json
}

# File path for the combined CSV file
CSV_FILE="ec2_metrics.csv"

# Check if the CSV file already exists; if not, create it with the headers
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Timestamp,CPUUtilization,NetworkIn,NetworkOut" > "$CSV_FILE"
fi

# Fetching the instance ID (replace with your method of obtaining the instance ID)
INSTANCE_ID="i-00034a2e6c772d806"

# Get CPU Utilization
cpu_data=$(get_metric_statistics "CPUUtilization")
cpu_average=$(echo "$cpu_data" | jq -r '.Datapoints | sort_by(.Timestamp) | last(.[]).Average // empty')

# Get NetworkIn
network_in_data=$(get_metric_statistics "NetworkIn")
network_in_average=$(echo "$network_in_data" | jq -r '.Datapoints | sort_by(.Timestamp) | last(.[]).Average // empty')

# Get NetworkOut
network_out_data=$(get_metric_statistics "NetworkOut")
network_out_average=$(echo "$network_out_data" | jq -r '.Datapoints | sort_by(.Timestamp) | last(.[]).Average // empty')

# Timestamp for the metrics
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Check if any of the metrics are empty; if so, default to "N/A"
cpu_average=${cpu_average:-N/A}
network_in_average=${network_in_average:-N/A}
network_out_average=${network_out_average:-N/A}

# Append metrics to CSV file
echo "$timestamp,$cpu_average,$network_in_average,$network_out_average" >> "$CSV_FILE"

# Verbose output to console
echo "Metrics collected at $timestamp"
echo "CPUUtilization: $cpu_average"
echo "NetworkIn: $network_in_average"
echo "NetworkOut: $network_out_average"

