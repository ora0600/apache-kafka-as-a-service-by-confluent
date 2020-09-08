#!/bin/bash
# set title
export PROMPT_COMMAND='echo -ne "\033]0;Produce to Source GCP Belgium\007"'
echo -e "\033];Produce to Source GCP Belgium\007"

# Terminal 4
# Produce data to source from local laptop and check how fast both consumer windows are reading (almost real-time)
echo '{"name":"Apple Magic Mouse","count":1}'
echo '{"name":"Mac Book Pro","count":1}'
echo "produce into source:"
kafka-avro-console-producer --broker-list $(awk '/endpoint: SASL_SSL:\/\//{print $NF}' ../webinar1/clusterid1 | sed 's/SASL_SSL:\/\///g') --topic cmorders_avro \
 --producer.config ./ccloud_user1.properties \
 --property value.schema='{"type":"record","name":"schema","fields":[{"name":"name","type":"string"},{"name":"count", "type": "int"}]}' \
 --property basic.auth.credentials.source=USER_INFO \
 --property schema.registry.url=$(awk '/endpoint_url/{print $NF}'  ../webinar1/srcluster) \
 --property schema.registry.basic.auth.user.info=$(awk '/key/{print $NF}' ../webinar1/srkey):$(awk '/secret/{print $NF}' ../webinar1/srkey)