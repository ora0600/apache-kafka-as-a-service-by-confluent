#!/bin/bash

# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Produce to ccloud\007"'
echo -e "\033];Produce to ccloud\007"

# produce Terminal 1
for i in `seq 1 150`; do echo "{ \"Name\": \"Table\", \"Count\": ${i} }" | kafka-console-producer --broker-list $(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid1 | sed 's/SASL_SSL:\/\///g') --producer.config ./ccloud_user1.properties --topic cmorders ; date +%s;  done
