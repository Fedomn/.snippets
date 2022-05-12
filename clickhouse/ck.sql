-- ClickHouse = Click Stream, Data WareHouse
-- SIMD + 选择不同场景下的高性能算法/ 数据结构



-- # create table schema inference
-- https://github.com/ClickHouse/ClickHouse/issues/14450
-- https://github.com/ClickHouse/ClickHouse/pull/32455
--
-- Parquet, ORC, Arrow, ArrowStream, Avro, Native, formats with suffix -WithNamesAndTypes
-- These formats contains the schema directly in the data file, in order to determine the schema ClickHouse reads some part of the data.



-- # create external database
-- https://clickhouse.com/docs/en/engines/database-engines/mysql/
-- https://clickhouse.com/docs/en/engines/table-engines/integrations/mysql/

create database if not exists external_db engine = MySQL('172.17.0.1:3307','db','root','123456');



-- # create table
create table if not exists ingest.db ENGINE = MergeTree() 
partition by insert_date order by tuple() 
as select external_db.dealer.*, '2021023' as insert_date from external_db.dealer limit 0;



-- # alter parition
-- https://clickhouse.com/docs/en/sql-reference/statements/alter/partition/
-- https://github.com/ClickHouse/ClickHouse/issues/16702
-- Currently none of these partition related alter commands are atomic. We only have part-level atomicity.

alter table target_table.table_name replace partition partition_value from target_table.table_name;



-- # systems
select * from system.tables where database = 'external_db' format Vertical;
select * from system.parts where database = 'db' and table = 'table' format Vertical;

