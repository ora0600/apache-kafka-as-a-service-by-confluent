#!/bin/bash

# get ccloud endpoint
export CCLOUD_CLUSTERID1_BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' ../webinar1/clusterid1 | sed 's/SASL_SSL:\/\///g')
export CCLOUD_KEY1=$(awk '/key/{print $NF}' ../webinar1/apikey1)
export CCLOUD_SECRET1=$(awk '/secret/{print $NF}' ../webinar1/apikey1)
export SERVERPORT=8090

# Create Producer and COnsumer properties
echo "# Local port to run Producer Tomcat
server.port=8080
# Connection to Confluent Cloud
spring.cloud.stream.kafka.binder.brokers=$CCLOUD_CLUSTERID1_BOOTSTRAP
spring.cloud.stream.kafka.binder.configuration.security.protocol=SASL_SSL
spring.cloud.stream.kafka.binder.configuration.sasl.mechanism=PLAIN
spring.cloud.stream.kafka.binder.configuration.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule   required username=\"$CCLOUD_KEY1\"   password=\"$CCLOUD_SECRET1\";
spring.cloud.stream.kafka.binder.configuration.ssl.endpoint.identification.algorithm=https
# Topic to use in Confluent Cloud to store incoming bookmarks events
spring.cloud.stream.bindings.output.destination=bookmarks
spring.cloud.stream.bindings.output.contentType=application/json" > BookmarksProducer/application.properties

echo "# application name and port where the application Tomcat will be running
spring.application.name=kafkastream
server.port=8090
# incoming Kafka Topic for Kafka Streams
spring.cloud.stream.bindings.reduce-in-0.destination=bookmarks
# Kafka consumer group id
spring.cloud.stream.kafka.streams.binder.applicationId=bookmarks
# Kafka connection settings
spring.cloud.stream.kafka.streams.binder.brokers=$CCLOUD_CLUSTERID1_BOOTSTRAP
spring.cloud.stream.kafka.streams.binder.configuration.security.protocol=SASL_SSL
spring.cloud.stream.kafka.streams.binder.configuration.sasl.mechanism=PLAIN
spring.cloud.stream.kafka.streams.binder.configuration.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule   required username=\"$CCLOUD_KEY1\"   password=\"$CCLOUD_SECRET1\";
spring.cloud.stream.kafka.streams.binder.configuration.ssl.endpoint.identification.algorithm=https
# Show Kafka where is the local state sore running
spring.cloud.stream.kafka.streams.binder.configuration.application.server=localhost:$SERVERPORT
spring.cloud.stream.kafka.streams.binder.configuration.default.key.serde=org.apache.kafka.common.serialization.Serdes\$StringSerde
spring.cloud.stream.kafka.streams.binder.configuration.default.value.serde=org.apache.kafka.common.serialization.Serdes\$StringSerde
spring.cloud.stream.kafka.streams.binder.configuration.commit.interval.ms=1000" > BookmarksConsumer/application.properties