-- performance_schema and sys_schema
-- https://frankma.netlify.app/posts/mysql/mysql-query-optimization/#performance-schema

-- 1、查看process：show processlist包含的信息较少可以通过下面语句

select * from sys.session;
select * from sys.processlist;

-- 2、查看数据库中热SQL

select db,exec_count,query from sys.statement_analysis order by exec_count desc limit 10;

-- 3、查看SQL用了临时表与磁盘临时表

select db, query, tmp_tables, tmp_disk_tables 
from sys.statement_analysis where tmp_tables>0 or tmp_disk_tables >0 
order by (tmp_tables+tmp_disk_tables) desc limit 20;

-- 4、查看冗余索引与unused索引

select * from sys.schema_redundant_indexes;
select * from sys.schema_unused_indexes;

-- 5、没有正确关闭数据库连接的用户

SELECT ess.user, ess.host, 
(a.total_connections - a.current_connections) - ess.count_star as not_closed, 
(a.total_connections - a.current_connections) as total_closed, 
((a.total_connections - a.current_connections) - ess.count_star) * 100 / (a.total_connections - a.current_connections) as pct_not_closed
FROM performance_schema.events_statements_summary_by_account_by_event_name ess
JOIN performance_schema.accounts a on (ess.user = a.user and ess.host = a.host)
WHERE ess.event_name = 'statement/com/quit' AND (a.total_connections - a.current_connections) > ess.count_star;

-- 6、查看最大延迟的SQL

select query, db, full_scan, exec_count, err_count, warn_count, sys.format_time(total_latency) as total_latency, sys.format_time(max_latency) as max_latency, sys.format_time(avg_latency) as avg_latency, sys.format_time(lock_latency) as lock_latency, first_seen, last_seen
from sys.x$statement_analysis where order by max_latency desc limit 10\G

-- 7、查看全表扫描的SQL

select * from sys.statements_with_full_table_scans order by exec_count desc limit 10\G

-- 8、用到临时表的SQL

select * from sys.statements_with_temp_tables

-- 9、查看MySQL event对应的次数和延迟

select * from sys.waits_global_by_latency
-- 其中events参考 https://dev.mysql.com/doc/refman/8.0/en/performance-schema-instrument-naming.html




-- optimizer_trace

set optimizer_trace='enabled=on';
select sum(price) from go_dev.test where weight between 1 and 100000;
select trace from information_schema.optimizer_trace;
set optimizer_trace='enabled=off';

-- 排序时MySQL可以最大分配的内存大小，如果数据量大于这个值就会使用磁盘临时表(默认256KB)
show variables like 'sort_buffer_size';



-- Query execution plan

-- SQL1
explain format=json
select SQL_NO_CACHE count(weight)
from ( select weight from test group by weight ) as g;

-- SQL2
explain format=json
select SQL_NO_CACHE count(distinct(weight))
from test;

