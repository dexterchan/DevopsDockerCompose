docker network create rmoff_kafka
docker run --network=rmoff_kafka --rm --detach --name zookeeper -e ZOOKEEPER_CLIENT_PORT=2181 confluentinc/cp-zookeeper:5.5.0
docker run --network=rmoff_kafka --rm --detach --name broker \
           -p 9092:9092 \
           -e KAFKA_BROKER_ID=1 \
           -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
           -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://broker:9092 \
           -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
           confluentinc/cp-kafka:5.5.0
docker run --network=rmoff_kafka --rm --name python_kafka_test_client \
        --tty python_kafka_test_client broker:9092
