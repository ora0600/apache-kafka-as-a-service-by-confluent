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
# Helper module
#
# =============================================================================

import argparse, sys
from confluent_kafka import avro, KafkaError
from confluent_kafka.admin import AdminClient, NewTopic
from uuid import uuid4

# Schema used for serializing Count class, passed in as the Kafka value
value_schema = """
{
  "connect.name": "org.kaliy.kafka.rss.Item",
  "connect.version": 1,
  "fields": [
    {
      "name": "feed",
      "type": {
        "connect.name": "org.kaliy.kafka.rss.Feed",
        "connect.version": 1,
        "fields": [
          {
            "default": null,
            "name": "title",
            "type": [
              "null",
              "string"
            ]
          },
          {
            "name": "url",
            "type": "string"
          }
        ],
        "name": "Feed",
        "type": "record"
      }
    },
    {
      "name": "title",
      "type": "string"
    },
    {
      "name": "id",
      "type": "string"
    },
    {
      "name": "link",
      "type": "string"
    },
    {
      "default": null,
      "name": "content",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "author",
      "type": [
        "null",
        "string"
      ]
    },
    {
      "default": null,
      "name": "date",
      "type": [
        "null",
        "string"
      ]
    }
  ],
  "name": "Item",
  "namespace": "org.kaliy.kafka.rss",
  "type": "record"
}
"""


class Value(object):
    """
        stores the deserialized Avro record for the Kafka value.
    """

    # Use __slots__ to explicitly declare all data members.
    #__slots__ = ["feed","title", "id", "link", "content", "author", "date"]

    def __init__(self, title=None, link=None, author=None):
        self.title = title
        self.link = link
        self.author = author
        # Unique id used to track produce request success/failures.
        # Do *not* include in the serialized object.
#        self.id = uuid4()

    @staticmethod
    def dict_to_value(obj, ctx):
        if obj is None:
            return None
        return Value(obj['title'],
                     obj['link'],
                     obj['author'])

    #@staticmethod
    #def value_to_dict(title, ctx):
    #    return Value.to_dict(title)

    #def to_dict(self):
    #    """
    #        The Avro Python library does not support code generation.
    #        For this reason we must provide a dict representation of our class for serialization.
    #    """
    #    return dict(title=self.title)


def parse_args():
    """Parse command line arguments"""

    parser = argparse.ArgumentParser(
             description="Confluent Python Client example to produce messages \
                  to Confluent Cloud")
    parser._action_groups.pop()
    required = parser.add_argument_group('required arguments')
    required.add_argument('-f',
                          dest="config_file",
                          help="path to Confluent Cloud configuration file",
                          required=True)
    required.add_argument('-t',
                          dest="topic",
                          help="topic name",
                          required=True)
    args = parser.parse_args()

    return args

def read_ccloud_config(config_file):
    """Read Confluent Cloud configuration for librdkafka clients"""

    conf = {}
    with open(config_file) as fh:
        for line in fh:
            line = line.strip()
            if len(line) != 0 and line[0] != "#":
                parameter, value = line.strip().split('=', 1)
                conf[parameter] = value.strip()

    return conf

