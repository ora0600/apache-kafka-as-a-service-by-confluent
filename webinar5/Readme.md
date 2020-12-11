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

## Create Confluent Cloud cluster from  webinar 1
```bash
cd ../webinar1/
source ccloud-vars
```
Start the demo
```bash
./00_create_ccloudcluster.sh
```
Create properties files fpr Producer and Consumer
```bash
cd ../webinar5
./01_genProperties.sh
```
## Create topics in Confluent Cloud
Topics are created if you run `00_create_ccloudcluster.sh` `webinar1-dir`. Otherwise create it manually.
* create topic "bookmarks" in Confluent Cloud. For future scaling purposes I recommend to create a topic with 3 or more partitions. This is a topic that will store all incoming bookmarks events.
* create topics "bookmarks-store-repartition" and "bookmarks-store-changelog" in Confluent Cloud. These topics will be used by Kafka Streams. These topics must have the same number of partitions as your "bookmarks" topic.

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
and Stop the cluster
```bash
cd ../webinar1
./02_drop_ccloudcluster.sh
```



