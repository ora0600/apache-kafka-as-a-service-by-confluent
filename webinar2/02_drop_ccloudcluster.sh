#!/bin/bash

###### set environment variables
# CCloud environment CMWORKSHOPS, have to be created before
source ccloud-vars
# CCloud environment CMWORKSHOPS
BASEDIR=$(cat basedir)
CCLOUD_CLUSTERID1=$(awk '/id:/{print $NF}' ../webinar1/clusterid1)
CCLOUD_CLUSTERID1_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' ../webinar1/clusterid1 | sed 's/SASL_SSL:\/\///g')
CCLOUD_CLUSTERID2=$(awk '/id:/{print $NF}' clusterid2)
CCLOUD_CLUSTERID2_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid2 | sed 's/SASL_SSL:\/\///g')
CCLOUD_KEY2=$(awk '/key/{print $NF}' apikey2)
CCLOUD_DGENPAGEVIEWSID=$(awk '/id:/{print $NF}' datagen-pageviews)
CCLOUD_DGENUSERSID=$(awk '/id:/{print $NF}' datagen-users)

# drop topic in ccloud
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic cmorders_avro --command-config ./ccloud_user1.properties 
echo "topic cmorders_avro deleted"
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic users --command-config ./ccloud_user1.properties 
echo "topic users deleted"
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic pageviews --command-config ./ccloud_user1.properties 
echo "topic pageviews deleted"
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID2_BOOTSTRAP --topic cmorders_avro --command-config ./ccloud_user2.properties 
echo "topic cmorders_avro deleted"

# drop connectors
ccloud connector delete $CCLOUD_DGENUSERSID --cluster $CCLOUD_CLUSTERID1
ccloud connector delete $CCLOUD_DGENPAGEVIEWSID --cluster $CCLOUD_CLUSTERID1
echo "fully managed Connectors deleted"

# DELETE CCLOUD cluster 
ccloud login
# environment CMWorkshops
ccloud environment use $XX_CCLOUD_ENV

# delete API Key
ccloud api-key delete $CCLOUD_KEY2

# Delete cluster
ccloud kafka cluster delete $CCLOUD_CLUSTERID2
ccloud kafka cluster list

# Delete files
echo "delete generated files"
rm -rf  $BASEDIR/apikey2
rm -rf  $BASEDIR/basedir
rm -rf  $BASEDIR/ccloud_user1.properties
rm -rf  $BASEDIR/ccloud_user2.properties
rm -rf  $BASEDIR/clusterid2
rm -rf  $BASEDIR/connect-avro_distributed.properties
rm -rf  $BASEDIR/replicator_avro.json
rm -rf  $BASEDIR/datagen-pageviews
rm -rf  $BASEDIR/datagen-pageviews.json
rm -rf  $BASEDIR/datagen-users
rm -rf  $BASEDIR/datagen-users.json

# Finish
echo "Clusters TARGET dropped"