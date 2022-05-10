--------------------------------------------------- parameter group --------------------------------------
log_min_duration_statement = 0
log_rotation_size = 1000000
log_lock_waits = 1


--------------------------------------------------- tuning tips --------------------------------------
-- https://postgresqlco.nf/doc/en/param/
work_mem如果过小，可以适当调大(1G)，防止写临时文件
shared_buffers如果过下，适当调大，增加block cache命中率(25%)

SHOW work_mem;
SHOW max_parallel_workers_per_gather;
SHOW min_parallel_table_scan_size;
SHOW max_worker_processes;
show shared_buffers;
max_worker_processes = 12
max_parallel_workers_per_gather = 4
max_parallel_workers = 12

SET work_mem TO '1 GB';
SET maintenance_work_mem TO '4 GB';
SET max_parallel_maintenance_workers TO 4;

ANALYZE table;
ALTER table "table" set (fillfactor = 70);
VACUUM FULL VERBOSE ANALYZE table;


-- show table size
SELECT pg_size_pretty(pg_relation_size('tablename'));
\di+ cus_*


---------------------------------------------------- extension --------------------------------------
SELECT * from pg_extension;
CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA "file";
set search_path = file, citext;
ALTER EXTENSION citext SET SCHEMA file;



-- HOT: Heap Only Tuple, It is a feature that overcomes some of the inefficiencies of how PostgreSQL handles UPDATEs.
-- https://www.cybertec-postgresql.com/en/hot-updates-in-postgresql-for-better-performance/
-- https://www.postgresql.org/docs/current/monitoring-stats.html
ALTER TABLE "test_table" SET (fillfactor = 30);
VACUUM FULL VERBOSE ANALYZE "test_table";
SELECT ctid, id, content from "test_table" limit 100;
SELECT * from pg_class;
SELECT * from pg_stat_all_tables where schemaname='test_table';



CREATE EXTENSION pg_stat_statements;

-- 表scan次数
SELECT schemaname, relname, seq_scan, seq_tup_read, idx_scan, seq_tup_read / seq_scan AS avg
FROM   pg_stat_user_tables 
WHERE  seq_scan > 0
ORDER BY seq_tup_read DESC 
LIMIT 20;

-- 看SQL查询次数 和平均执行时间 等
SELECT query,
round(total_time::numeric, 2) AS total_time,
calls,
round(mean_time::numeric, 2) AS mean,
round((100 * total_time / sum(total_time::numeric) OVER ())::numeric, 2) AS percentage_cpu
FROM  pg_stat_statements
ORDER BY total_time DESC
LIMIT 20;

SELECT 
substring(query for 1000),
round(total_exec_time::numeric, 2) AS total_time,
calls,
round(mean_exec_time::numeric, 2) AS mean,
round((100 * total_exec_time / sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage_cpu
FROM  pg_stat_statements
ORDER BY total_time DESC
LIMIT 1;

-- reset stats
select pg_stat_statements_reset();


select indexrelid,schemaname,relname,indexrelname,idx_scan,idx_tup_read from pg_stat_all_indexes where schemaname not in ('pg_toast','pg_catalog');

-- The pgstattuple module provides various functions to obtain tuple-level statistics.
CREATE EXTENSION pgstattuple;
SELECT * FROM pgstattuple('oauth_access_token');
SELECT * FROM pgstatindex('oauth_access_token_pkey');



---------------------------------------------------- explain --------------------------------------
explain (analyze, verbose, timing, costs, buffers)
explain (analyze, format yaml, buffers)



---------------------------------------------------- locking --------------------------------------
-- 看当前locking的情况
-- https://wiki.postgresql.org/wiki/Lock_Monitoring
SELECT blocked_locks.pid     AS blocked_pid,
blocked_activity.usename  AS blocked_user,
blocking_locks.pid     AS blocking_pid,
blocking_activity.usename AS blocking_user,
blocked_activity.query    AS blocked_statement,
blocking_activity.query   AS current_statement_in_blocking_process
FROM  pg_catalog.pg_locks         blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks         blocking_locks 
ON blocking_locks.locktype = blocked_locks.locktype
AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

-- kill sql
-- https://stackoverflow.com/questions/35319597/how-to-stop-kill-a-query-in-postgresql
SELECT * FROM pg_stat_activity WHERE state = 'active';
SELECT pg_cancel_backend(6249);
SELECT pg_terminate_backend(6249);

