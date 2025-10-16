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

При удалении SINK коннектора обязательно нужно удалять consumer group. Иначе при пересоздании коннектора offset будет сохранен.

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

На pg_dest создаем таблицу с именем топика
```sql
create table pg_source_t_orders
(
	id INTEGER,
	num varchar(100),
	dt date
);
```

## Что нужно помнить
На стороне Consumer ни при каких обстоятельствах нельзя создавать Primary Key, даже когда он есть в исходной таблице. Это связано с гарантиями доставки AT-LEAST-ONCE, когда одно сообщение может прийти несколько раз. В таком случае наличие CONSTRAINT'а инвалидирует SINK-коннектор.

При запуске SINK коннектора, все сообщения, которые есть в топике будут обработаны. И тогда в случае, если insert.mode:
1. insert.mode = insert. Записи обязательно будут вставлены в целевую таблицу. Если уже сделан init, это приведет к их задвоению.
2. insert.mode = upsert. При накате необработанных сообщений будет произведена операция UPDATE, что не должно повлиять на корректность данных. Также этот режим весьма успешно помогает справляться с дублями, связанными с гарантиями доставки.
