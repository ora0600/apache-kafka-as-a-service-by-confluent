# Webinar Serie: Apache Kafka as a Service in GCP, Azure and AWS by Confluent fully managed

A deep dive Webinar serie: Apache Kafka as a Service in GCP, Azure and AWS by Confluent
focused on these main Confluent Kafka components
* Kafka in general,
* Connect,
* Schema Registry,
* Kafka Streams,
* CP Ansible,
* and Confluent Cloud

## Presenters from Confluent:
* Jan Svoboda
* Suvad Sahovic
* Carsten Mützlitz

## Attendees:
* All industries, all titles 

## Webinar content:
### Title: Apache Kafka as a Service - Kafka in der Cloud - in GCP, Azure and AWS by Confluent fully-managed
A webinar serie with  5  deep dive session

### Content of the serie:
Based on real stories like price scaping, marketing channels in telegram, micro services platform and AR APP Confluent will explain how easy it is to work with Confluent Cloud.

### Webinar Serie
Structure of a session:
  * Start with an overview - what to achieve
  * Wrap-up of last session (if this is not the first session)
  * Only a few slides
  * We running live
  * Step-by-Step explanation based on the current use case
  * Automatic script and explanation
  * Wrap-up and what is coming next

### [1.Webinar](webinar1/Readme.md): Apache Kafka as a Service by Confluent Cloud Overview
  * Confluent Cloud Service overview
    * Subscription types (direkt, marketplace)
    * create Cluster (UI, cli)
    * Monitoring / Compliance
      * Data flow
      * Schema Registry (JSON/AVRO/PROTOBUF)
      * Matric API Monitoring
    * Topics Management
      * Message Browser
      * Producer   
      * Consumer
  * Security Session:
    * User Management 
    * ACL and service Account
    * RBAC in Confluent Cloud
    * Authentication and Authorization
      * Client Access
    * Audit Logs in der Confluent Cloud
    * SSO

### [2.Webinar](webinar2/Readme.md): Using Connector with Apache Kafka as a Service, self-managed and fully-managed
  * Fully managed connectors
    * DataGen Connector Users
    * Datagen Connector Pageviews
  * Self-Managed connectors
     * RSS feed connector
     * Replicator (OnPrem -> CCloud -> OnPrem)

### [3.Webinar](webinar3/Readme.md): Doing Analytics with Apache Kafka as Service
  * Provision ksqlDB APP
    * generate Data
    * do analytics in a realtime on streams of events

### 4.Webinar: Connectivity possibilities with Apache Kafka as Service in Cloud
How to access the Confluent Cloud and deal with different connectivities
 * Internet Endpoints
 * VPC/VNet Peering
 * Private Link
 * HA Proxy
 * kafka-Proxy
 * site-to-site VPN
 * (Transit Gateway)

### [5.Webinar](webinar5/Readme.md): Building Microservices with Apache Kafka as Service in Cloud
Let's build Java Springboot Microservices with Confluent Cloud
 * CQRS pattern example
 * Spring Cloud Streams library usage example with Kafka
 * State Store for storing Microservice state and state recovery
 * Microservices Decoupling and Microservices intercommunication
 * Stateless and Stateful Microservices Scaling Up or Down
 
### 6.Webinar: cost optimization, total cost of ownership
The last session of one of the most importan. What are the costs, benefits, things to know.
* Cost optimization (less traffic, storage)
  * compression
  * Avro/SR
  * batching
  * Automatic test, serverless Kafka (startup and shutdown)
* Infinite storage
* multi-tenancy (chargeBack: Throughput per Topics * price factor)
* Use of managed CP enterprise components with Confluent Cloud
* Fully-managed vs. Self-managed components
* TCO on-prem vs. Ccloud

# License / Costs
To play around with these samples here, you need to have a Confluent Cloud account.

