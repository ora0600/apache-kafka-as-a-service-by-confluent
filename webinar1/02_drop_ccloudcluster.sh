#!/bin/bash

###### set environment variables
source ccloud-vars
# CCloud environment CMWORKSHOPS
CCLOUD_CLUSTERID1=$(awk '/id:/{print $NF}' clusterid1)
CCLOUD_CLUSTERID1_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid1 | sed 's/SASL_SSL:\/\///g')
CCLOUD_KEY1=$(awk '/key/{print $NF}' apikey1)
CCLOUD_SRKEY1=$(awk '/key/{print $NF}' srkey)

# DELETE CCLOUD cluster 
cd /Users/cmutzlitz/Demos/ccloud/unpack_and_execute_produce4dataflow
ccloud login
# environment CMWorkshops
ccloud environment use $XX_CCLOUD_ENV

# delete API Key
ccloud api-key delete $CCLOUD_KEY1
ccloud api-key delete $CCLOUD_SRKEY1

# Delete cluster
ccloud kafka cluster delete $CCLOUD_CLUSTERID1

# Delete files
rm basedir
rm apikey1
rm ccloud_user1.properties
rm clusterid1
rm srcluster
rm srkey
rm ccloud.config
rm terraform/ccloud-tvars

# Finish
echo "Cluster $XX_CCLOUD_CLUSTERNAME dropped"