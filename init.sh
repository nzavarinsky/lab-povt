#!/usr/bin/env bash
192.168.0.112
docker stop kafka zookeeper
docker rm kafka zookeeper

docker run -d --name zookeeper -p 2181:2181 jplock/zookeeper
docker run -d --name kafka -p 7203:7203 -p 9092:9092 -e KAFKA_ADVERTISED_HOST_NAME=${STRATEGY_LAB_IP} -e ZOOKEEPER_IP=${STRATEGY_LAB_IP} ches/kafka

sleep 5
docker run --rm ches/kafka kafka-topics.sh -create --topic es-data --replication-factor 1 --partitions 1 --zookeeper ${STRATEGY_LAB_IP}:2181 --config retention.ms=86400000
docker run --rm ches/kafka kafka-topics.sh -create --topic cassandra-data --replication-factor 1 --partitions 1 --zookeeper ${STRATEGY_LAB_IP}:2181 --config retention.ms=300000
c3uy-2p5r