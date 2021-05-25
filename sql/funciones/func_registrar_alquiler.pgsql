/*
Función: func_registrar_alquiler

Descripción: Proceso a ser llamado por un usuario cuando se desea insertar un
nuevo cliente al sistema.

Entradas: 
customer_id integer,
staff_id integer,
film_id integer

Usuarios autorizados:
- video

Roles autorizados:
- emp

Autor: Andres Cornejo
*/

CREATE or replace FUNCTION func_registrar_alquiler(
    in p_customer_id int,
    in p_staff_id int,
    in p_film_id int,
    out out_code int
)
AS 
$$
declare
	var_current_time timestamp := (SELECT CURRENT_TIMESTAMP(0));
    --var_rental_days int := (select f.rental_duration from public.film f where p_film_id = f.film_id);
    --var_return_date timestamp := var_current_time + make_interval(days=>var_rental_days);
    var_store_id int := (select s.store_id from staff s where s.staff_id = p_staff_id limit 1);
    var_stock_left int := (select count(*) from (SELECT public.film_in_stock(
                               p_film_id, var_store_id)) as stock);
    var_inventory_id int := 0;
    
begin
    if var_stock_left > 0 then
        var_inventory_id := (select * from (SELECT public.film_in_stock(
                               p_film_id, var_store_id)) as stock limit 1);

        insert into public.rental(rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
        values(var_current_time, var_inventory_id, p_customer_id, null, p_staff_id, var_current_time);

        out_code := 0;

    else
		raise exception 'P0001';
    end if;

	exception
		when sqlstate 'P0001' then 
			out_code = -1;
			raise notice 'La tienda no tiene suficiente inventario para realizar el alquiler';
			
		when others then
			out_code = -1;
            raise notice '% %', var_inventory_id, var_stock_left;
			raise exception 'Ha ocurrido un error al intentar realizar un alquiler.';
end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;
