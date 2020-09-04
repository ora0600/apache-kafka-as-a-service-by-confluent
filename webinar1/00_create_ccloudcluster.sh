#!/bin/bash

###### set environment variables
# CCloud environment CMWORKSHOPS, have to be created before
source ccloud-vars

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

# enable if Schema registry, if it still enabled, no new will be created
ccloud schema-registry cluster enable --geo eu --cloud gcp -o yaml > srcluster
export CCLOUD_SRURL1=$(awk '/endpoint_url/{print $NF}' srcluster)
export CCLOUD_SRID1=$(awk '/id/{print $NF}' srcluster)
# create SR KEy, Secret
ccloud api-key create --resource $CCLOUD_SRID1 --description 'SR Key for webinar1, can be deleted' -o yaml > srkey
export CCLOUD_SRKEY1=$(awk '/key/{print $NF}' srkey)
export CCLOUD_SRSECRET1=$(awk '/secret/{print $NF}' srkey)

# create topic
# topic in ccloud
#kafka-topics --create --bootstrap-server $(sed 's/|//g' clusterid1 | awk '/Endpoint     SASL_SSL:\/\//{print $NF}' | sed 's/SASL_SSL:\/\///g') --topic cmorders \
#--replication-factor 3 --partitions 6 --command-config ./ccloud_user1.properties 
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic cmorders \
--replication-factor 3 --partitions 1 --command-config ./ccloud_user1.properties 
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic rssfeeds \
--replication-factor 3 --partitions 1 --command-config ./ccloud_user1.properties 
echo "Topic created"

# create terraform vars
echo "export TF_VAR_cc_broker_url=${CCLOUD_CLUSTERID1_BOOTSTRAP}
export TF_VAR_cc_broker_key=${CCLOUD_KEY1}
export TF_VAR_cc_broker_secret=${CCLOUD_SECRET1}
export TF_VAR_cc_schema_url=${CCLOUD_SRURL1}
export TF_VAR_cc_schema_key=${CCLOUD_SRKEY1}
export TF_VAR_cc_schema_secret=${CCLOUD_SRSECRET1}" > terraform/ccloud-tvars

# Python config file
echo "bootstrap.servers=${CCLOUD_CLUSTERID1_BOOTSTRAP}
security.protocol=SASL_SSL
sasl.mechanisms=PLAIN
sasl.username=${CCLOUD_KEY1}
sasl.password=${CCLOUD_SECRET1}
# Confluent Cloud Schema Registry
schema.registry.url=${CCLOUD_SRURL1}
basic.auth.credentials.source=USER_INFO
schema.registry.basic.auth.user.info=${CCLOUD_SRKEY1}:${CCLOUD_SRSECRET1}" > ccloud.config

#Producer and Consumer Terminals
echo "Open producer and consumer Terminals with iterm...."
open -a iterm
sleep 10
osascript 01_produce.scpt $BASEDIR
echo ">>>>>>>>>> 150 records will be produced..."
echo ">>>>>>>>>>Now switch to iTerm 2 and see producing and consuming"
echo ">>>>>>>>>>login into ccloud to show Dataflow (this will take a while to see something)"

# Finish
echo "Cluster $XX_CCLOUD_CLUSTERNAME created"