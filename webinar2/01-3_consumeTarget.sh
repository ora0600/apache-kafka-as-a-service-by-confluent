#!/bin/bash
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Consume from Target AWS Frankfurt\007"'
echo -e "\033];Consume from Target AWS Frankfurt\007"

# Terminal 3
# Consume from Destination Cluster (AWS in Franfurt)
echo "consume from target: "
kafka-avro-console-consumer --bootstrap-server $(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid2 | sed 's/SASL_SSL:\/\///g') --topic cmorders_avro \
 --consumer.config ./ccloud_user2.properties \
 --property basic.auth.credentials.source=USER_INFO \
 --property schema.registry.url=$(awk '/endpoint_url/{print $NF}'  ../webinar1/srcluster) \
 --property schema.registry.basic.auth.user.info=$(awk '/key/{print $NF}' ../webinar1/srkey):$(awk '/secret/{print $NF}' ../webinar1/srkey)
