#!/bin/bash

###### set environment variables
# CCloud environment CMWORKSHOPS, have to be created before
source ../webinar1/ccloud-vars

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

# Read env from webinar1
export CCLOUD_CLUSTERID1=$(awk '/id:/{print $NF}' ../webinar1/clusterid1)
export CCLOUD_CLUSTERID1_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' ../webinar1/clusterid1 | sed 's/SASL_SSL:\/\///g')
echo $CCLOUD_CLUSTERID1
echo $CCLOUD_CLUSTERID1_BOOTSTRAP
export CCLOUD_KEY1=$(awk '/key/{print $NF}' ../webinar1/apikey1)
export CCLOUD_SECRET1=$(awk '/secret/{print $NF}' ../webinar1/apikey1)
echo $CCLOUD_KEY1
echo $CCLOUD_SECRET1
export CCLOUD_SRURL1=$(awk '/endpoint_url/{print $NF}' ../webinar1/srcluster)
export CCLOUD_SRID1=$(awk '/id/{print $NF}' ../webinar1/srcluster)
export CCLOUD_SRKEY1=$(awk '/key/{print $NF}' ../webinar1/srkey)
export CCLOUD_SRSECRET1=$(awk '/secret/{print $NF}' ../webinar1/srkey)

# create property-file for ccloud user1
echo "ssl.endpoint.identification.algorithm=https
sasl.mechanism=PLAIN
request.timeout.ms=20000
bootstrap.servers=$CCLOUD_CLUSTERID1_BOOTSTRAP
retry.backoff.ms=500
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$CCLOUD_KEY1\" password=\"$CCLOUD_SECRET1\";
security.protocol=SASL_SSL" > ccloud_user1.properties

# create topic
# topic in ccloud in source
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic users \
--replication-factor 3 --partitions 1 --command-config ./ccloud_user1.properties 
echo "Topic users created"
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic pageviews \
--replication-factor 3 --partitions 1 --command-config ./ccloud_user1.properties 
echo "Topic pageviews created"
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic competitionprices \
--replication-factor 3 --partitions 1 --command-config ./ccloud_user1.properties 
echo "Topic competitionprices created"
kafka-topics --create --bootstrap-server $CCLOUD_CLUSTERID1_BOOTSTRAP --topic orders \
--replication-factor 3 --partitions 1 --command-config ./ccloud_user1.properties 
echo "Topic competitionprices created"

# open Price Checker
echo "Open microserice Terminal with iterm...."
open -a iterm
sleep 10
osascript 01_pricechecker.scpt $BASEDIR $CCLOUD_CLUSTERID1_BOOTSTRAP $CCLOUD_KEY1 $CCLOUD_SECRET1
echo ">>>>>>>>>> Start Microservice to check prices..."
echo ">>>>>>>>>> Now switch to iTerm 2 and see producing and consuming"
echo ">>>>>>>>>> login into ccloud to show prices from competition and later orders"

# create connectors
echo "{
  \"connector.class\": \"DatagenSource\",
  \"name\": \"datagen-users\",
  \"kafka.api.key\": \"$CCLOUD_KEY1\",
  \"kafka.api.secret\": \"$CCLOUD_SECRET1\",
  \"kafka.topic\": \"users\",
  \"output.data.format\": \"AVRO\",
  \"quickstart\": \"USERS\",
  \"max.interval\": \"1000\",
  \"tasks.max\": \"1\"
}" > datagen-users.json
ccloud connector create --cluster $CCLOUD_CLUSTERID1 --config datagen-users.json  -o yaml > datagen-users
export CCLOUD_DGENUSERSID=$(awk '/id:/{print $NF}' datagen-users)
echo "datagen-users connector created"

echo "{
  \"connector.class\": \"DatagenSource\",
  \"name\": \"datagen-pageviews\",
  \"kafka.api.key\": \"$CCLOUD_KEY1\",
  \"kafka.api.secret\": \"$CCLOUD_SECRET1\",
  \"kafka.topic\": \"pageviews\",
  \"output.data.format\": \"AVRO\",
  \"quickstart\": \"PAGEVIEWS\",
  \"max.interval\": \"1000\",
  \"tasks.max\": \"1\"
}" > datagen-pageviews.json
ccloud connector create --cluster $CCLOUD_CLUSTERID1 --config datagen-pageviews.json -o yaml > datagen-pageviews
export CCLOUD_DGENPAGEVIEWSID=$(awk '/id:/{print $NF}' datagen-pageviews)
echo "datagen-pageviews connector created"


# Create KSQLDB APP
echo "create ksqldb APP"
ccloud ksql app create realtimeprices --cluster $CCLOUD_CLUSTERID1 > ksqldbid
export CCLOUD_KSQLDB_REST=$(sed 's/|//g' ksqldbid | awk '/Endpoint/{print $NF}')
export CCLOUD_KSQLDB_ID=$(sed 's/|//g' ksqldbid | awk '/Id/{print $NF}')
echo "************************************************"
echo "⌛ Give KSQLDB APP 12 Minutes to start...in the meatime I explain web scraping"
sleep 720

echo "Add acl to topics for ksqldb"
ccloud ksql app configure-acls $CCLOUD_KSQLDB_ID order competitionprices users pageviews --cluster $CCLOUD_CLUSTERID1
echo "Create API Key for REST Access"
ccloud api-key create --resource $CCLOUD_KSQLDB_ID --description "API KEY for KSQLDB cluster $CCLOUD_KSQLDB_ID" > ksqldbapi
export CCLOUD_KSQLDBKEY1=$(sed 's/|//g' ksqldbapi | awk '/API Key/{print $NF}')
export CCLOUD_KSQLDBSECRET1=$(sed 's/|//g' ksqldbapi | awk '/Secret/{print $NF}')
echo "#########  Following actions for you ############"
echo "Add the following Code to KSQLDB to add a stream and a table"
PRETTY_CODE="\e[1;100;37m"
printf "${PRETTY_CODE}%s\e[0m\n" "${1}"
# Add streams to KSQLDB
echo "Create Streams and Tables first: see github webinar3 readme"
echo "Try ksqldb cli..."
KSQLCLI="ksql -u $CCLOUD_KSQLDBKEY1  -p $CCLOUD_KSQLDBSECRET1 $CCLOUD_KSQLDB_REST"
printf "${PRETTY_CODE}%s\e[0m\n" "${KSQLCLI}"
echo "Try ksqldb rest via curl..."
CURLREST="curl -X \"POST\" \"$CCLOUD_KSQLDB_REST/query\" \
     -H \"Content-Type: application/vnd.ksql.v1+json; charset=utf-8\" \
     -u '$CCLOUD_KSQLDBKEY1:$CCLOUD_KSQLDBSECRET1' \
     -d $'{
           \"ksql\": \"SELECT lowestprice_5minutes-(lowestprice_5minutes/100) as ourPrice from competitionprices_table emit changes limit 1;\",
           \"streamsProperties\": {}
        }'|jq"
printf "${PRETTY_CODE}%s\e[0m\n" "${CURLREST}"
# set properties for microservice
echo "set properties for microservice"
echo "server.port=8080
ksql.url=$CCLOUD_KSQLDB_REST
ksql.user=$CCLOUD_KSQLDBKEY1
ksql.password=$CCLOUD_KSQLDBSECRET1" > java_app/src/main/resources/application.properties
# run microservice
cd java_app
echo "Run microservice..."
nohup mvn spring-boot:run &
MICROSERVICE="run microservice webshop under http://localhost:8080/sale.html"
printf "${PRETTY_CODE}%s\e[0m\n" "${MICROSERVICE}"
printf "${PRETTY_CODE}%s\e[0m\n" "Show microservice job: jobs -l"
# Finish
echo "Connectors, kslDB, Microservice and JavaApp started..."
echo "Delete Cluster extensions with ./02_drop_ccloudcluster.sh"
echo "***************************************************"