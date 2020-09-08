#!/bin/bash

# Set Session title
export PROMPT_COMMAND='echo -ne "\033]0;Connect Cluster\007"'
echo -e "\033];Connect Cluster\007"

# Terminal 1
# Start Connect Worker
connect-distributed connect-avro_distributed.properties
