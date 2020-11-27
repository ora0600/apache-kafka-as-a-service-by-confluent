# Webinar 5: Building Microservices with Apache Kafka as Service in Cloud

Demo application to demonstrate building microservices using Springboot and Apache Kafka. Application is a simple Bookmarks manager. It allows you to:
* Create a new bookmark
* Update a bookmark 
* Delete a bookmark
* All bookmarks are stored with some username
* Read list of bookmarks for some user

![Application User Interface](images/appUI.png)

This demo consist of two microservices which are using Java Springboot:
* Bookmarks Producer - is used to send messages to Kafka
* Bookmarks  Consumer - is used to retrieving messages from Kafka and storing them in local  state store. 

Demo Application architecture
![Architecture](images/architecture.png)

## Requirements to run it locally:
* Java 8
* Maven
* Connectivity to Confluent Cloud

## Create topics in Confluent Cloud
* Create a topic "bookmarks" in Confluent Cloud. For future scaling purposes I recommend to create a topic with 3 or more partitions.

## Configure the Producer properties
Configure connection to Confluent Cloud and Topic to be used. Make sure that the topic already exists. Application is not allowed to create the new topic for you.
You MUST set all properties in [/BookmarksProducer/src/main/resources/application.properties.EXAMPLE](/webinar5/BookmarksProducer/src/main/resources/application.properties.EXAMPLE)

Example of application.properties for Confluent Cloud:
```
server.port=8080

spring.cloud.stream.kafka.binder.brokers=pkc-XXXXX.europe-west3.gcp.confluent.cloud:9092
spring.cloud.stream.kafka.binder.configuration.security.protocol=SASL_SSL
spring.cloud.stream.kafka.binder.configuration.sasl.mechanism=PLAIN
spring.cloud.stream.kafka.binder.configuration.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule   required username="XXXXX"   password="XXXXXXXXXX";
spring.cloud.stream.kafka.binder.configuration.ssl.endpoint.identification.algorithm=https

spring.cloud.stream.bindings.output.destination=bookmarks
spring.cloud.stream.bindings.output.contentType=application/json
```

## Start the Producer
Start the Producer microservices with your properties file
```bash
cd BookmarksProducer
mvn spring-boot:run -Dspring.config.location=application.properties
```

## Test the Producer
Open your favorite browser and enter following url (assuming you have not changed the port 8080 in your properties file)
```
http://localhost:8080/bookmarksProducer/jan
```
Congrats you are logged in as a user "jan". You can change the name to anything you want. Bookmark events will be stored in the bookmarks topic in Kafka using this key! This means that all bookmark events from the same user will use the same partition.

## Configure the Consumer properties
TODO

## Start the Consumer
TODO

## Test the Consumer
TODO

## Stop the demo showcase
TODO


