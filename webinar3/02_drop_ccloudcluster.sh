#!/bin/bash

###### set environment variables
# CCloud environment CMWORKSHOPS, have to be created before
source ../webinar1/ccloud-vars
# CCloud environment CMWORKSHOPS
BASEDIR=$(cat basedir)
CCLOUD_CLUSTERID1=$(awk '/id:/{print $NF}' ../webinar1/clusterid1)
CCLOUD_CLUSTERID1_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' ../webinar1/clusterid1 | sed 's/SASL_SSL:\/\///g')
CCLOUD_KEY2=$(awk '/key/{print $NF}' ../webinar1/apikey1)
CCLOUD_DGENPAGEVIEWSID=$(awk '/id:/{print $NF}' datagen-pageviews)
CCLOUD_DGENUSERSID=$(awk '/id:/{print $NF}' datagen-users)
CCLOUD_KSQLDB_ID=$(sed 's/|//g' ksqldbid | awk '/Id/{print $NF}')
CCLOUD_KSQLDBKEY1=$(sed 's/|//g' ksqldbapi | awk '/API Key/{print $NF}')



# drop topic in ccloud
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic competitionprices --command-config ./ccloud_user1.properties 
echo "topic competitionprices deleted"
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic users --command-config ./ccloud_user1.properties 
echo "topic users deleted"
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic pageviews --command-config ./ccloud_user1.properties 
echo "topic pageviews deleted"
kafka-topics --delete --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic orders --command-config ./ccloud_user1.properties 
echo "topic orders deleted"

# drop connectors
ccloud connector delete $CCLOUD_DGENUSERSID --cluster $CCLOUD_CLUSTERID1
ccloud connector delete $CCLOUD_DGENPAGEVIEWSID --cluster $CCLOUD_CLUSTERID1
echo "fully managed Connectors deleted"

# DELETE CCLOUD cluster 
ccloud login
# set environment and cluster
ccloud environment use $XX_CCLOUD_ENV
ccloud kafka cluster use $CCLOUD_CLUSTERID1

# delete API Key
ccloud api-key delete $CCLOUD_KSQLDBKEY1

# delete ksqlDB
ccloud ksql app delete $CCLOUD_KSQLDB_ID

# Delete files
echo "delete generated files"
rm -rf  $BASEDIR/basedir
rm -rf  $BASEDIR/ccloud_user1.properties
rm -rf  $BASEDIR/datagen-pageviews
rm -rf  $BASEDIR/datagen-pageviews.json
rm -rf  $BASEDIR/datagen-users
rm -rf  $BASEDIR/datagen-users.json
rm -rf  $BASEDIR/ksqldbapi
rm -rf  $BASEDIR/ksqldbid

# Finish
echo "Don't forget to stop python microservice and JaVaApp"