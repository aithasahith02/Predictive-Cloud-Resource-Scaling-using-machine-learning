#!bin/bash/

######################################
#
# Author : Sahith Aitha
# Date : 8th Aug 2024
#
# This is a shell script that fetched the metrics from AWS and preserve the results for the ML model.
######################################


#Set the instance ID and the metrics to fetch. The metrics namely, CPUUtilz, Network IN and OUT are fetched

INSTANCE_ID="i-00034a2e6c772d806"
START_TIME=$(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ)
END_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)

#This AWS-CLI command fetches the  CPUUtilization metrics of the above instance from AWS Cloud Watch
aws cloudwatch get-metric-statistics \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --period 3600 \
    --statistics Average \
    --dimensions Name=InstanceId,Value=$INSTANCE_ID \
    --start-time $START_TIME \
    --end-time $END_TIME > cpu_metrics.json


#This AWS-CLI command fetches the  Ingress network  metrics of the above instance from AWS Cloud Watch
aws cloudwatch get-metric-statistics \
    --metric-name NetworkIn \
    --namespace AWS/EC2 \
    --period 3600 \
    --statistics Average \
    --dimensions Name=InstanceId,Value=$INSTANCE_ID \
    --start-time $START_TIME \
    --end-time $END_TIME > network_in_metrics.json


#This AWS-CLI command fetches the  Outgress network  metrics of the above instance from AWS Cloud Watch
aws cloudwatch get-metric-statistics \
    --metric-name NetworkOut \
    --namespace AWS/EC2 \
    --period 3600 \
    --statistics Average \
    --dimensions Name=InstanceId,Value=$INSTANCE_ID \
    --start-time $START_TIME \
    --end-time $END_TIME > network_out_metrics.json


