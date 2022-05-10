-- https://www.postgresql.org/docs/current/indexes-types.html

create table testing_table (like from_table including all);


create unique index if not exists idx on testing_table using btree ("number" desc nulls last);
create index idx on testing_table using btree (("content"->>'is_active'));

create index if not exists idx on testing_table using hash (num);

create index if not exists idx on testing_table using gin (name gin_trgm_ops);
create index if not exists idx on testing_table using gin ((substring(phone from 1 for 3) || '****') gin_trgm_ops);


ANALYZE cus_members_m;

