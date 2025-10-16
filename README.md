# Простейшая сборка для Confluent JDBC Connector со schema registry и AVRO Converter


## Команды docker

**Запуск docker-compose.yaml**
```bash
docker compose up -d
```

**Проверка доступных коннекторов**
```bash
curl -s http://localhost:8083/connector-plugins | jq
```

**Список зарегистрированных коннекторов**
```bash
curl -s http://localhost:8083/connectors | jq
```

**Регистрация коннектора**
```bash
curl -X POST -H "Content-Type: application/json" --data @connectors/source_connector.json http://localhost:8083/connectors
```

**Статус коннектора**
```bash
curl -s http://localhost:8083/connectors/jdbc-source-postgres/status | jq
```

**Удаление коннектора**
```bash
curl -X DELETE http://localhost:8083/connectors/jdbc-source-postgres
```

Kafka UI доступна по адресу
http://localhost:8280

## Для БД (pg_source)
```sql
create table t_orders
(
	id serial primary key,
	num varchar(100)
);

select * from t_orders;

insert into t_orders
values
(1, '100-456468')
;

alter table t_orders add dt date;

insert into t_orders
(num, dt)
select substr(md5(random()::text), 1, 25), now();
;

-- Массовая вставка
INSERT INTO t_orders (num, dt)
SELECT 
    substr(md5(random()::text), 1, 25),
    now()
FROM generate_series(1, 1000000);

```


