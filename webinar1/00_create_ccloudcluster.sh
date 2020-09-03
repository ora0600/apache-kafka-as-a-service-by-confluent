#!/bin/bash

###### set environment variables
# CCloud environment CMWORKSHOPS, have to be created before
source env-vars

pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

###### Create cluster automatically

# CREATE CCLOUD cluster 
ccloud update
ccloud login
# environment CMWorkshops
ccloud environment use $XX_CCLOUD_ENV
# Cluster1
echo "Create new cluster $XX_CCLOUD_CLUSTERNAME"
ccloud kafka cluster create $XX_CCLOUD_CLUSTERNAME --cloud 'gcp' --region 'europe-west1' --type basic -o yaml > clusterid1
# set cluster id as parameter
export CCLOUD_CLUSTERID1=$(awk '/id:/{print $NF}' clusterid1)
export CCLOUD_CLUSTERID1_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid1 | sed 's/SASL_SSL:\/\///g')
echo $CCLOUD_CLUSTERID1
echo $CCLOUD_CLUSTERID1_BOOTSTRAP
ccloud kafka cluster use $CCLOUD_CLUSTERID1
ccloud kafka cluster describe $CCLOUD_CLUSTERID1 -o human
# create API Keys
ccloud api-key create --resource $CCLOUD_CLUSTERID1 --description "API Key for cluster user" -o yaml > apikey1
export CCLOUD_KEY1=$(awk '/key/{print $NF}' apikey1)
export CCLOUD_SECRET1=$(awk '/secret/{print $NF}' apikey1)
echo $CCLOUD_KEY1
echo $CCLOUD_SECRET1
# create property-file for ccloud user1
echo "ssl.endpoint.identification.algorithm=https
sasl.mechanism=PLAIN
request.timeout.ms=20000
bootstrap.servers=$CCLOUD_CLUSTERID1_BOOTSTRAP
retry.backoff.ms=500
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$CCLOUD_KEY1\" password=\"$CCLOUD_SECRET1\";
security.protocol=SASL_SSL" > ccloud_user1.properties
echo "************************************************"
echo "Cluster is created give it 2 Minutes to start..."
sleep 120

# create topic
# topic in ccloud
#kafka-topics --create --bootstrap-server $(sed 's/|//g' clusterid1 | awk '/Endpoint     SASL_SSL:\/\//{print $NF}' | sed 's/SASL_SSL:\/\///g') --topic cmorders \
#--replication-factor 3 --partitions 6 --command-config ./ccloud_user1.properties 
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic cmorders \
--replication-factor 3 --partitions 6 --command-config ./ccloud_user1.properties 
echo "Topic created"

# open Producer and Consumer Terminals
echo "Open producer and consumer Terminals with iterm...."
open -a iterm
sleep 10
osascript 01_produce.scpt $BASEDIR
echo ">>>>>>>>>> 150 records will be produced..."
echo ">>>>>>>>>>Now switch to iTerm 2 and see producing and consuming"
echo ">>>>>>>>>>login into ccloud to show Dataflow (this will take a while to see something)"

# Finish
echo "Cluster $XX_CCLOUD_CLUSTERNAME created"