#!/bin/bash
yum -y update
yum -y install curl which
yum install java-1.8.0-openjdk-devel.x86_64 -y
yum install jq -y
# clean
yum clean all

#install python
yum install python3 -y
yum install python3-devel -y
yum install gcc -y

#install packages
install python-telegram-bot --upgrade
install requests
pip3 install fastavro
pip3 install confluent_kafka[avro]==1.5.0
pip3 install json

# Confluent Public Key for repo
rpm --import https://packages.confluent.io/rpm/5.5/archive.key
# create repo for yum
cd /etc/yum.repos.d/
echo "[Confluent.dist]
name=Confluent repository (dist)
baseurl=https://packages.confluent.io/rpm/5.5/7
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/5.5/archive.key
enabled=1

[Confluent]
name=Confluent repository
baseurl=https://packages.confluent.io/rpm/5.5
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/5.5/archive.key
enabled=1" > confluent.repo
# Install Confluent Connect
yum -y install confluent-hub-client
yum install confluent-platform-2.12 -y
mkdir -p /usr/share/java/confluent-hub-components
confluent-hub install kaliy/kafka-connect-rss:0.1.0 --component-dir /usr/share/java/confluent-hub-components --no-prompt

# Create Property file for Kafka Rest Proxy to work with Confluent Cloud
cd /home/ec2-user/
echo "bootstrap.servers=${confluent_cloud_broker}
key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=org.apache.kafka.connect.json.JsonConverter
key.converter.schemas.enable=false
value.converter.schemas.enable=false
internal.key.converter=org.apache.kafka.connect.json.JsonConverter
internal.value.converter=org.apache.kafka.connect.json.JsonConverter
internal.key.converter.schemas.enable=false
internal.value.converter.schemas.enable=false
offset.storage.file.filename=/tmp/connect.offsets
offset.flush.interval.ms=10000
ssl.endpoint.identification.algorithm=https
sasl.mechanism=PLAIN
request.timeout.ms=20000
retry.backoff.ms=500
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"${confluent_cloud_broker_key}\" password=\"${confluent_cloud_broker_secret}\";
security.protocol=SASL_SSL
consumer.ssl.endpoint.identification.algorithm=https
consumer.sasl.mechanism=PLAIN
consumer.request.timeout.ms=20000
consumer.retry.backoff.ms=500
consumer.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"${confluent_cloud_broker_key}\" password=\"${confluent_cloud_broker_secret}\";
consumer.security.protocol=SASL_SSL
producer.ssl.endpoint.identification.algorithm=https
producer.sasl.mechanism=PLAIN
producer.request.timeout.ms=20000
producer.retry.backoff.ms=500
producer.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"${confluent_cloud_broker_key}\" password=\"${confluent_cloud_broker_secret}\";
producer.security.protocol=SASL_SSL
value.converter=io.confluent.connect.avro.AvroConverter
value.converter.basic.auth.credentials.source=USER_INFO
value.converter.schema.registry.basic.auth.user.info=${confluent_cloud_schema_key}:${confluent_cloud_schema_secret}
value.converter.schema.registry.url=${confluent_cloud_schema_url}
plugin.path=/usr/share/java/confluent-hub-components" > my_standalone-connect.properties

# rssfeed connector properties
echo "name=RssSourceConnectorDemo
tasks.max=1
connector.class=org.kaliy.kafka.connect.rss.RssSourceConnector
rss.urls=https://www.kai-waehner.de/feed/
#rss.urls=https://www.kai-waehner.de/feed/ https://rss.app/feeds/djRu8z7eUSewRfWC.xml
topic=rssfeeds" > rssfeed.properties

chown ec2-user:ec2-user my_standalone-connect.properties
chown ec2-user:ec2-user rssfeed.properties

# Start as daemon
#sudo KAFKA_HEAP_OPTS="-Xms128m -Xmx256M" connect-standalone -daemon ./my_standalone-connect.properties ./rssfeed.properties

