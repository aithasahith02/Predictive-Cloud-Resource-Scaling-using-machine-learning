#!bin/bash/

######################################
#
# Author : Sahith Aitha
# Creation Date : 8th Aug 
#
# This is a shell script that fetched the metrics from AWS and preserve the results in a CSV file for the ML model.
######################################


#!/bin/bash

#!/bin/bash

# Define the instance ID and region
INSTANCE_ID="i-00034a2e6c772d806"
REGION="us-east-1"  # Update this with your AWS region

# Define the start and end times (past hour)
END_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
START_TIME=$(date -u -d "-1 hour" +"%Y-%m-%dT%H:%M:%SZ")

# Output CSV file
CSV_FILE="ec2_metrics.csv"

# Function to fetch metric statistics
fetch_metric() {
    local METRIC_NAME=$1
    local UNIT=$2
    aws cloudwatch get-metric-statistics --metric-name $METRIC_NAME --start-time $START_TIME --end-time $END_TIME --period 3600 --namespace AWS/EC2 --statistics Average --dimensions Name=InstanceId,Value=$INSTANCE_ID --region $REGION --output json | jq -r --arg UNIT "$UNIT" '.Datapoints | sort_by(.Timestamp) | last | .Timestamp + "," + (.Average|tostring) + "," + $UNIT'
}

# Fetch metrics
CPU_UTILIZATION=$(fetch_metric "CPUUtilization" "Percent")
NETWORK_IN=$(fetch_metric "NetworkIn" "Bytes")
NETWORK_OUT=$(fetch_metric "NetworkOut" "Bytes")

# Extracting values and timestamp from the outputs
TIMESTAMP=$(echo $CPU_UTILIZATION | cut -d ',' -f 1)
CPU_VALUE=$(echo $CPU_UTILIZATION | cut -d ',' -f 2)
NETWORK_IN_VALUE=$(echo $NETWORK_IN | cut -d ',' -f 2)
NETWORK_OUT_VALUE=$(echo $NETWORK_OUT | cut -d ',' -f 2)

# Check if the CSV file exists and has a header
if [ ! -f $CSV_FILE ]; then
    echo "Timestamp,CPUUtilization,NetworkIn,NetworkOut" > $CSV_FILE
fi

# Append data to the CSV file
echo "$TIMESTAMP,$CPU_VALUE,$NETWORK_IN_VALUE,$NETWORK_OUT_VALUE" >> $CSV_FILE

echo "Metrics successfully fetched and appended to $CSV_FILE."

