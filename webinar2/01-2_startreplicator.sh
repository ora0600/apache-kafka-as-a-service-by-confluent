#!/bin/bash

# set title
export PROMPT_COMMAND='echo -ne "\033]0;Replicator: Consume from Source GCP Belgium\007"'
echo -e "\033];Replicator: Consume from Source GCP Belgium\007"
echo "Wait 4 min till Connect cluster has started..."
sleep 240
# Terminal 2
# check connect worker
curl localhost:8083/ | jq
# connector plugins
#curl localhost:8083/connector-plugins | jq

# Run Replicator
#curl -X DELETE http://localhost:8083/connectors/replicate-topic
#curl -X DELETE http://localhost:8083/connectors/dbsource-atp
curl -X POST -d @replicator_avro.json  http://localhost:8083/connectors --header "content-Type:application/json"

# Running connectors
curl localhost:8083/connectors

# Status Replicator Connector
curl localhost:8083/connectors/replicate-topic/status | jq

# Still in Terminal 2
# consume from source cluser (cmgibquery GCP Belgium)
echo "consume from source:"
kafka-avro-console-consumer --bootstrap-server $(awk '/endpoint: SASL_SSL:\/\//{print $NF}' ../webinar1/clusterid1 | sed 's/SASL_SSL:\/\///g') --topic cmorders_avro \
 --consumer.config ccloud_user1.properties \
 --property basic.auth.credentials.source=USER_INFO \
 --property schema.registry.url=$(awk '/endpoint_url/{print $NF}'  ../webinar1/srcluster)\
 --property schema.registry.basic.auth.user.info=$(awk '/key/{print $NF}' ../webinar1/srkey):$(awk '/secret/{print $NF}' ../webinar1/srkey)
