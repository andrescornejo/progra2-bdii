create role video nologin;
create role emp nologin;
create role admin_sys nologin;

REVOKE ALL PRIVILEGES ON SCHEMA pg_catalog FROM emp;
REVOKE ALL PRIVILEGES ON SCHEMA pg_catalog FROM admin_sys;
REVOKE ALL PRIVILEGES ON SCHEMA information_schema FROM emp;
REVOKE ALL PRIVILEGES ON SCHEMA information_schema FROM admin_sys;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM emp;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM admin_sys;

REVOKE EXECUTE ON FUNCTION public.func_nuevo_cliente FROM emp;
REVOKE EXECUTE ON FUNCTION public.func_insertar_inventario(integer, integer, integer) FROM emp;

GRANT EXECUTE ON FUNCTION public.func_nuevo_cliente TO emp;
GRANT EXECUTE ON FUNCTION public.func_registrar_alquiler TO emp;
GRANT EXECUTE ON FUNCTION public.func_registrar_devolucion TO emp;
GRANT EXECUTE ON FUNCTION public.func_buscar_pelicula TO emp;

GRANT EXECUTE ON FUNCTION public.func_nuevo_cliente TO admin_sys;
GRANT EXECUTE ON FUNCTION public.func_insertar_inventario TO admin_sys;
GRANT EXECUTE ON FUNCTION public.func_buscar_pelicula(text, year, integer) to empleado1;
alter role admin_sys nologin inherit;
grant emp to admin_sys;

CREATE ROLE empleado1 PASSWORD '123' LOGIN;
CREATE ROLE administrador1 PASSWORD '123' LOGIN;

REVOKE ALL PRIVILEGES ON SCHEMA pg_catalog FROM empleado1;
REVOKE ALL PRIVILEGES ON SCHEMA pg_catalog FROM administrador1;
REVOKE ALL PRIVILEGES ON SCHEMA information_schema FROM empleado1;
REVOKE ALL PRIVILEGES ON SCHEMA information_schema FROM administrador1;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM empleado1;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM administrador1;
REVOKE EXECUTE ON FUNCTION public.func_nuevo_cliente FROM empleado1;
REVOKE EXECUTE ON FUNCTION public.func_insertar_inventario(integer, integer, integer) FROM empleado1;
REVOKE EXECUTE ON FUNCTION public.func_insertar_inventario FROM public;
REVOKE EXECUTE ON FUNCTION public.func_insertar_inventario(integer, integer, integer) FROM public;
grant emp to empleado1;
grant admin_sys to administrador1;

alter role video nologin;

show data_directory;