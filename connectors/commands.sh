curl -s http://localhost:8083/connector-plugins | jq
curl -X POST -H "Content-Type: application/json" --data @connectors/source_connector.json http://localhost:8083/connectors
curl -X POST -H "Content-Type: application/json" --data @connectors/sink_connector.json http://localhost:8083/connectors

curl -X DELETE http://localhost:8083/connectors/jdbc-sink-postgres