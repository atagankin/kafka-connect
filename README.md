Простейшая сборка для Confluent JDBC Connector со schema registry и AVRO Converter

Для запуска выполни команды

Запуск docker-compose.yaml
```
docker compose up -d
```
Регистрация коннектора
```
curl -X POST -H "Content-Type: application/json" --data @connectors/source_connector.json http://localhost:8083/connectors
```

Для БД (pg_source)
```
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
```


