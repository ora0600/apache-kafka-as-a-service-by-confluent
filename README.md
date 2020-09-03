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

### 1.Webinar: Apache Kafka as a Service by Confluent Cloud Overview
  * ccloud overview
=> Subscription types (direkt, marketplace)
=> create Cluster (UI, cli)
=> Data Flow
    => Monitoring / Compliance
    => Schema Registry
    => different formats (JSON, AVRO)
=> Topics
    => Message Browser
    => Producer   
    => Consumer
=> API Monitoring
Security Session:
=> User Management 
=> ACL and service Account
=> RBAC in Confluent Cloud
=> Authentication and Authorization
=> Audit Logs in der Confluent Cloud
=> SSO

### 2.Webinar: Using Connector with Apache Kafka as a Service, self-managed and fully-managed
Fully managed connectors
    => DataGen Connector
    => S3/Azure Blob
Self-Managed connectors
     => RSS feed connector
     => Replicator (OnPrem -> CCloud -> OnPrem)

### 3.Webinar: Doing Analytics with Apache Kafka as Service
ksqlDB

### 4.Webinar: Connectivity possibilities with Apache Kafka as Service in Cloud
=> Internet Endpoints
=> VPC/VNet Peering
=> Private Link
=> HA Proxy
=> kafka-Proxy
=> site-to-site VPN
=> (Transit Gateway)

### 5.Webinar: cost optimization, total cost of ownership
compression
Avro/SR
multi-tenancy (chargeBack: Throughput per Topics * price factor)
Automatic test, serverless Kafka (startup and shutdown)
Infinite storage
Use of managed CP enterprise components with Confluent Cloud
Fully-managed vs. Self-managed components
TCO on-prem vs. Ccloud

# License / Costs
To play around with these samples here, you need to have a Confluent Cloud account.
