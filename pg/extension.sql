-- sha1
create extension pgcrypto;
SELECT encode(digest(random()::text, 'sha1'), 'hex');


-- add pg_stat_statements (error: pg_stat_statements must be loaded via shared_preload_libraries)
-- 1. kubectl -n namespace edit statefulset pg
-- 2. POSTGRESQL_SHARED_PRELOAD_LIBRARIES changed to "pg_stat_statements,pgaudit"
-- 3. save and restart pg

