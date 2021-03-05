# CassandraGraphql

## Cassandra Quickstart

Docker setup.

```sh
docker pull cassandra:latest
docker network create -d bridge cassandra-network
docker run --name cassandra-db --network=cassandra-network -p 9042:9042 -d cassandra:latest
docker run -it --network cassandra-network --rm cassandra:latest cqlsh cassandra-db
```

Tables and test data.

```cql
// create table
CREATE KEYSPACE IF NOT EXISTS cassandra_graphql
  WITH REPLICATION = { 
    'class' : 'SimpleStrategy',
    'replication_factor' : 1 
  };
USE cassandra_graphql;
CREATE TABLE IF NOT EXISTS item (
   item_id       text PRIMARY KEY,
   category_list list<text>
);
CREATE INDEX ON item (category_list);

// insert test data
BEGIN BATCH
INSERT INTO item JSON '{"item_id":"a", "category_list": ["1A", "2B", "3C"]}';
INSERT INTO item JSON '{"item_id":"b", "category_list": ["4D", "5E"]}';
INSERT INTO item JSON '{"item_id":"c", "category_list": ["6F", "7G", "8H", "9I"]}';
INSERT INTO item JSON '{"item_id":"d", "category_list": ["00", "1A", "2B", "3C", "4D", "5E", "6F", "7G", "8H", "9I"]}';
APPLY BATCH;

// select test data
SELECT * FROM item;
SELECT * FROM item LIMIT 3;
SELECT * FROM item WHERE item_id='a';
SELECT * FROM item WHERE item_id IN ('b', 'd');
SELECT * FROM item WHERE category_list CONTAINS '2B';
SELECT * FROM item WHERE category_list CONTAINS '2B' AND category_list CONTAINS '7G' ALLOW FILTERING;
```

## Sample GraphQL

Query.

```graphql
query($itemId: String!, $limit: Int) {
  ping {
    date
    datetime
    pong
    success
    time
  }
  info {
    date
    datetime
    remoteIp
    time
    version
  }
  item(itemId: $itemId) {
    itemId
    categoryList
  }
  itemList(limit: $limit) {
    itemId
    categoryList
  }
}
```

Query variables.

```json
{
  "itemId": "a",
  "limit": 2
}
```

