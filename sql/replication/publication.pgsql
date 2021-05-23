CREATE ROLE rep REPLICATION LOGIN PASSWORD 'admin';

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rep;

create publication dvd_publication for all tables;

--drop publication dvd_publication;

--select privilege_type, table_name from information_schema.role_table_grants where grantee = 'rep';