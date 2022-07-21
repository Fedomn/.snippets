-- sha1
create extension pgcrypto;
SELECT encode(digest(random()::text, 'sha1'), 'hex');

-- pg_stat_statements: 
-- add pg_stat_statements (error: pg_stat_statements must be loaded via shared_preload_libraries)
-- 1. kubectl -n namespace edit statefulset pg
-- 2. POSTGRESQL_SHARED_PRELOAD_LIBRARIES changed to "pg_stat_statements,pgaudit"
-- 3. save and restart pg

-- auto_explain:
-- https://www.postgresql.org/docs/current/auto-explain.html
-- https://pgmustard.com/blog/auto-explain-overhead-with-timing
-- LOAD 'auto_explain';
-- SET auto_explain.log_min_duration = 0;
-- SET auto_explain.log_analyze = true;

-- pg_stat_kcache:
-- Gather statistics about physical disk access and CPU consumption done by backends.
-- https://github.com/powa-team/pg_stat_kcache

-- pg_wait_sampling:
-- https://github.com/postgrespro/pg_wait_sampling
-- Sampling based statistics of wait events
