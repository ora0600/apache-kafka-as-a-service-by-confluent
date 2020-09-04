#!/usr/bin/env python
#
# Copyright 2020 Confluent Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# =============================================================================
#
# Consume messages from Confluent Cloud
# Using Confluent Python Client for Apache Kafka
# Reads Avro data, integration with Confluent Cloud Schema Registry
#
# =============================================================================

from confluent_kafka import DeserializingConsumer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer
from confluent_kafka.serialization import StringDeserializer
import requests
import json
import ccloud_lib_rssfeeds
import time

BOT_TOKEN = "6672772772:ß09710923ohdhkjwjdhkajshd"
CHANNEL_ID = "@my-channel-link" 

def send_message(message):
    requests.get(f'https://api.telegram.org/bot{BOT_TOKEN}/sendMessage?chat_id={CHANNEL_ID}&text={message}')

if __name__ == '__main__':

    # Read arguments and configurations and initialize
    args = ccloud_lib_rssfeeds.parse_args()
    config_file = args.config_file
    topic = args.topic
    conf = ccloud_lib_rssfeeds.read_ccloud_config(config_file)

    schema_registry_conf = {
        'url': conf['schema.registry.url'],
        'basic.auth.user.info': conf['schema.registry.basic.auth.user.info']}
    schema_registry_client = SchemaRegistryClient(schema_registry_conf)
    # schema for value
    value_avro_deserializer = AvroDeserializer(ccloud_lib_rssfeeds.value_schema,
                                               schema_registry_client,
                                               ccloud_lib_rssfeeds.Value.dict_to_value)

    # for full list of configurations, see:
    #   https://docs.confluent.io/current/clients/confluent-kafka-python/#deserializingconsumer
    consumer_conf = {
        'bootstrap.servers': conf['bootstrap.servers'],
        'sasl.mechanisms': conf['sasl.mechanisms'],
        'security.protocol': conf['security.protocol'],
        'sasl.username': conf['sasl.username'],
        'sasl.password': conf['sasl.password'],
#        'key.deserializer': name_avro_deserializer,
        'value.deserializer': value_avro_deserializer,
        'group.id': 'rssfeed-consumer-1',
        'auto.offset.reset': 'earliest' }

    consumer = DeserializingConsumer(consumer_conf)

    # Subscribe to topic
    consumer.subscribe([topic])

    # Process messages
    total_count = 0
    while True:
        try:
            msg = consumer.poll(1.0)
            if msg is None:
                # No message available within timeout.
                # Initial message consumption may take up to
                # `session.timeout.ms` for the consumer group to
                # rebalance and start consuming
                print("Waiting for message or event/error in poll()")
                continue
            elif msg.error():
                print('error: {}'.format(msg.error()))
            else:
                value_object = msg.value()
                title = value_object.title
                link = value_object.link
                author = value_object.author
                send_message("{} written by {} \n {}".format(title, author, link))
                print("Consumed record with value {}, {}, {}".format(title, link, author))
        except KeyboardInterrupt:
            break

    # Leave group and commit final offsets
    consumer.close()

