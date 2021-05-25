--Tables
SELECT 'ALTER TABLE '|| schemaname || '."' || tablename ||'" OWNER TO video;'
FROM pg_tables WHERE NOT schemaname IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;
--Sequences
SELECT 'ALTER SEQUENCE '|| sequence_schema || '."' || sequence_name ||'" OWNER TO video;'
FROM information_schema.sequences WHERE NOT sequence_schema IN ('pg_catalog', 'information_schema')
ORDER BY sequence_schema, sequence_name;
--Views
SELECT 'ALTER VIEW '|| table_schema || '."' || table_name ||'" OWNER TO video;'
FROM information_schema.views WHERE NOT table_schema IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;
--Materialized views
SELECT 'ALTER TABLE '|| oid::regclass::text ||' OWNER TO video;'
FROM pg_class WHERE relkind = 'm'
ORDER BY oid;
--Functions
select 'alter function '||nsp.nspname||'.'||p.proname||'('||pg_get_function_identity_arguments(p.oid)||') owner to video;'
from pg_proc p
  join pg_namespace nsp ON p.pronamespace = nsp.oid
where nsp.nspname = 'public';
 
-- Revoke all functions from all users.
select 'revoke execute on function '||nsp.nspname||'.'||p.proname||'('||pg_get_function_identity_arguments(p.oid)||') from public;'
from pg_proc p
  join pg_namespace nsp ON p.pronamespace = nsp.oid
where nsp.nspname = 'public';

-- Grant functions to a user.
-- Revoke all functions from all users.
select 'grant execute on function '||nsp.nspname||'.'||p.proname||'('||pg_get_function_identity_arguments(p.oid)||') to admin_sys;'
from pg_proc p
  join pg_namespace nsp ON p.pronamespace = nsp.oid
where nsp.nspname = 'public';