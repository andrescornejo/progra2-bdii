/*
Función: func_check_stock

Descripción: Función que devuelve cuanto inventario le queda a una pelicula

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

CREATE or replace FUNCTION func_check_stock(
    in p_store_id int,
    in p_film_id int,
    out out_code int
)
AS 
$$
declare
	var_current_time timestamp := (SELECT CURRENT_TIMESTAMP(0));
    var_rental_days int := (select f.rental_duration from public.film f where p_film_id = f.film_id);
    var_return_date timestamp := var_current_time + make_interval(days=>var_rental_days);
    var_store_id int := (select s.store_id from staff s where s.staff_id = p_staff_id limit 1);
    var_stock_left int := (select public.func_check_stock(var_store_id, p_film_id))
    var_inventory_id int;
begin
    -- Contar cuantas peliculas quedan por sucursal.
    out_code := (
        select count(*) from inventory i
        where i.film_id = p_film_id and i.store_id = p_store_id);

    exception when others then
        out_code := -1;
        raise notice 'La transaccion tiene un estado corrupto. Se abortó.';
        raise notice '% %', SQLERRM, SQLSTATE;
end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;
