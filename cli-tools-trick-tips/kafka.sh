Cheatsheet - Kafka
All commands are executed from your Kafka bin directory (e.g., /opt/kafka/bin).

Core Concepts Quick Reference
Term	Description
Broker	A single Kafka server. A cluster is made up of one or more brokers.
Topic	A named stream of records, similar to a table in a database.
Partition	A topic is split into one or more partitions. Partitions allow for parallelism.
Offset	A unique, sequential ID for each record within a partition.
Producer	An application that writes (publishes) records to a Kafka topic.
Consumer	An application that reads (subscribes to) records from a Kafka topic.
Consumer Group	One or more consumers that jointly consume a topic. Each partition is consumed by exactly one consumer in the group.
Zookeeper / KRaft	The metadata management service. Zookeeper is the traditional choice; KRaft is the modern, built-in replacement.
Topic Management (kafka-topics.sh)
This is the primary tool for managing topics.

List All Topics:

./kafka-topics.sh --bootstrap-server localhost:9092 --list
Create a Topic:

# Simple topic with 3 partitions and a replication factor of 1
./kafka-topics.sh --bootstrap-server localhost:9092 --create \
  --topic my-topic \
  --partitions 3 \
  --replication-factor 1
Describe a Topic: This is crucial for viewing the leader, replicas, and in-sync replicas (ISR) for each partition.

./kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic my-topic
Alter a Topic: The most common alteration is increasing the number of partitions. You cannot decrease the partition count.

./kafka-topics.sh --bootstrap-server localhost:9092 --alter \
  --topic my-topic \
  --partitions 5
Delete a Topic: Requires delete.topic.enable=true to be set in your server.properties broker configuration.

./kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic my-topic
Console Producer (kafka-console-producer.sh)
A handy tool for sending messages from the command line for testing.

Start an Interactive Producer: After running, type your messages line-by-line. Press Ctrl+C to exit.

./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic
Produce Messages with Keys: Keys and values are separated by a delimiter (default is \t). Set the parse.key and key.separator properties.

./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic \
  --property "parse.key=true" \
  --property "key.separator=:"
# Now you can type messages like:
# key1:this is my first message
# key2:this is another message
Console Consumer (kafka-console-consumer.sh)
Read messages from the command line for debugging and verification.

Consume All Messages from the Beginning:

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning
Consume New Messages (Live): This is the default behavior. It will only show messages produced after the consumer starts.

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic
Consume as Part of a Consumer Group: This is how real applications consume. The group will track offsets.

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --group my-test-group
Display Keys and Other Properties: Very useful for debugging.

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning \
  --formatter kafka.tools.DefaultMessageFormatter \
  --property print.timestamp=true \
  --property print.key=true \
  --property print.value=true \
  --property print.partition=true
Consumer Group Management (kafka-consumer-groups.sh)
The essential tool for monitoring consumer lag and managing groups.

List All Consumer Groups:

./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
Describe a Consumer Group (View Lag): This is the most important monitoring command. It shows the current offset, the last committed offset (log-end-offset), and the difference (lag) for each partition.

./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group my-test-group
Reset Consumer Group Offsets: Useful for re-processing data. The --execute flag is required to actually perform the reset.

To the beginning:
./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-test-group \
  --reset-offsets --to-earliest --topic my-topic --execute
To a specific timestamp (format: YYYY-MM-DDTHH:mm:ss.sss):
./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-test-group \
  --reset-offsets --to-datetime 2023-10-27T10:00:00.000 --topic my-topic --execute
Configuration Management (kafka-configs.sh)
View and dynamically alter configurations for topics and brokers.

Describe Topic-Level Configs:

./kafka-configs.sh --bootstrap-server localhost:9092 --describe \
  --entity-type topics --entity-name my-topic
Alter a Topic's Retention Time: Set the retention for my-topic to 3 days (in milliseconds).

./kafka-configs.sh --bootstrap-server localhost:9092 --alter \
  --entity-type topics --entity-name my-topic \
  --add-config retention.ms=259200000