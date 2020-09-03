#!/bin/bash
# set titke
export PROMPT_COMMAND='echo -ne "\033]0;Consume from ccloud: Compliance issue\007"'
echo -e "\033];Consume from ccloud: Compliance issued\007"

# consume Terminal 3
kafka-console-consumer --topic cmorders --consumer.config ./ccloud_user1.properties  --bootstrap-server $(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid1 | sed 's/SASL_SSL:\/\///g') --property print.timestamp=true --consumer-property group.id=cmsuvad-compliance-issue

