# Dataflow show case
Fully automatic demo will create cluster and start consumer and producer.
![Dataflow in CCloud](https://docs.confluent.io/current/_images/ccloud-data-flow-inspect-producers.png)

This demo expects some preparation work, before you can execute the scripts. If all the preparation is done, then everything starts automatically:
* Confluent Platform 5.4 is installed locally
* confluent cloud cli is installed locally
* iterm2 with "install shell integration enables (see iterm2->Install Shell integration)" is installed
* A Confluent Cloud Account have to be created
* An environment in Confluent Cloud have to be created and named in the script `env-vars`
* Schema Registry has to be enabled for Confluent Cloud Environment

## Pre-Configure
the shell script `env-vars` has some variables which need to fit to your Confluent Cloud environment
* Your Confluent Cloud Environment:  XX_CCLOUD_ENV=XXXXXX
* Your Confluent Cloud Login: XX_CCLOUD_EMAIL=YYYYYYY
* Your Confluent Cloud Password: XX_CCLOUD_PASSWORD=ZZZZZZZZZ
* The name for the Confluent Cluster: XX_CCLOUD_CLUSTERNAME=DEMODATAFLOW

## Start the demo showcase
Start the demo
```bash
source env-vars
./00_create_ccloudcluster.sh
```
iterm Terminals with producer and consumer start automatically. You can login into your Confluent Cloud Account and check in GUI:
* Dataflow
* Topic
Note: It will a while to everything working fine in GUI.

## Stop the demo showcase
To delete the complete environment:
```bash
./02_drop_ccloudcluster.sh
```


