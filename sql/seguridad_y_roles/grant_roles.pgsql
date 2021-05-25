GRANT USAGE ON SCHEMA public TO emp;

CREATE ROLE empleado1 PASSWORD '123' LOGIN;
grant emp to empleado1;

grant execute on function public.func_nuevo_cliente(p_store_id integer, p_first_name character varying, p_last_name character varying, p_email character varying, p_city_name character varying, p_address_line1 character varying, p_address_line2 character varying, p_district character varying, p_zipcode character varying, p_phone character varying, OUT out_code integer) to emp;
grant execute on function public.func_registrar_alquiler(p_customer_id integer, p_staff_id integer, p_film_id integer, OUT out_code integer) to emp;
grant execute on function public.func_registrar_devolucion(p_customer_id integer, p_staff_id integer, p_rental_id integer, OUT out_code integer) to emp;
grant execute on function public.func_buscar_pelicula(p_film_name text, p_film_year year, p_lang_id integer, OUT out_code integer) to emp;

grant usage on schema public to admin_sys;

CREATE ROLE administrador1 PASSWORD '123' LOGIN;
grant admin_sys to administrador1;
grant emp to administrador1;

grant execute on function public.func_nueva_pelicula(p_film_title text, p_description text, p_release_year year, p_lang_id integer, p_rental_duration integer, p_rental_rate numeric, p_length integer, p_replacement_cost numeric, p_rating mpaa_rating, p_special_features text[], p_fulltext tsvector, OUT out_code integer) to admin_sys;
grant execute on function public.func_insertar_inventario(p_film_id integer, p_store_id integer, p_copies integer, OUT out_code integer) to admin_sys;