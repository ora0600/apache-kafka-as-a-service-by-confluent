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
* create topic "bookmarks" in Confluent Cloud. For future scaling purposes I recommend to create a topic with 3 or more partitions. This is a topic that will store all incoming bookmarks events.
* create topics "bookmarks-store-repartition" and "bookmarks-store-changelog" in Confluent Cloud. These topics will be used by Kafka Streams. These topics must have the same number of partitions as your "bookmarks" topic.

## Configure the Producer properties
Configure connection to Confluent Cloud and Topic to be used. Make sure that the topic already exists. Application is not allowed to create the new topic for you.
You MUST set all properties in [/BookmarksProducer/application.properties](/webinar5/BookmarksProducer/application.properties)

Example of Producer application.properties for Confluent Cloud:
```
# Local port to run Producer Tomcat
server.port=8080

# Connection to Confluent Cloud
spring.cloud.stream.kafka.binder.brokers=XXX.europe-west3.gcp.confluent.cloud:9092
spring.cloud.stream.kafka.binder.configuration.security.protocol=SASL_SSL
spring.cloud.stream.kafka.binder.configuration.sasl.mechanism=PLAIN
spring.cloud.stream.kafka.binder.configuration.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule   required username="XXX"   password="XXXXXX";
spring.cloud.stream.kafka.binder.configuration.ssl.endpoint.identification.algorithm=https

# Topic to use in Confluent Cloud to store incoming bookmarks events
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
Configure connection to Confluent Cloud and your topic for Kafka Streams.
You MUST set all properties in [/BookmarksConsumer/application.properties](/webinar5/BookmarksConsumer/application.properties)

Example of Consumer application.properties for Confluent Cloud:
```
# application name and port where the application Tomcat will be running
spring.application.name=kafkastream
server.port=8090

# incoming topic for Kafka Streams events processing
spring.cloud.stream.bindings.reduce-in-0.destination=bookmarks
# Kafka consumer group id
spring.cloud.stream.kafka.streams.binder.applicationId=bookmarks

# Kafka connection settings
spring.cloud.stream.kafka.streams.binder.brokers=XXX.europe-west3.gcp.confluent.cloud:9092
spring.cloud.stream.kafka.streams.binder.configuration.security.protocol=SASL_SSL
spring.cloud.stream.kafka.streams.binder.configuration.sasl.mechanism=PLAIN
spring.cloud.stream.kafka.streams.binder.configuration.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule   required username="XXX"   password="XXXXXX";
spring.cloud.stream.kafka.streams.binder.configuration.ssl.endpoint.identification.algorithm=https

# Show Kafka where is the local state sore running
spring.cloud.stream.kafka.streams.binder.configuration.application.server=localhost:${server.port}
spring.cloud.stream.kafka.streams.binder.configuration.default.key.serde=org.apache.kafka.common.serialization.Serdes$StringSerde
spring.cloud.stream.kafka.streams.binder.configuration.default.value.serde=org.apache.kafka.common.serialization.Serdes$StringSerde
spring.cloud.stream.kafka.streams.binder.configuration.commit.interval.ms=1000
```

## Start the Consumer
Start the Consumer microservices with your properties file
```bash
cd BookmarksConsumer
mvn spring-boot:run -Dspring.config.location=application.properties
```

## Test the Consumer
Open your favorite browser and enter following url (assuming you have not changed the port 8090 in your properties file)
```
http://localhost:8090/bookmarksConsumer/jan
```
Congrats you are logged in as a user "jan". Now you can view all the bookmarks that were stored as a user "jan". Change the name to be able to see bookmarks from some other users (if they exist).

## Stop the demo showcase
Hit Control+C to stop the microservices.



