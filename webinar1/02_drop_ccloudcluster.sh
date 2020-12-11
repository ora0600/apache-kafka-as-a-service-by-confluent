#!/bin/bash

###### set environment variables
source ccloud-vars

# CCloud environment CMWORKSHOPS
BASEDIR=$(cat basedir)
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

# list kafka clusters
ccloud kafka cluster list

# Delete files
echo "delete generated files from disk"
rm -rf $BASEDIR/basedir
rm -rf $BASEDIR/apikey1
rm -rf $BASEDIR/ccloud_user1.properties
rm -rf $BASEDIR/clusterid1
rm -rf $BASEDIR/srcluster
rm -rf $BASEDIR/srkey
rm -rf $BASEDIR/ccloud.config
rm -rf $BASEDIR/terraform/ccloud-tvars

# Finish
echo "Cluster $XX_CCLOUD_CLUSTERNAME dropped"