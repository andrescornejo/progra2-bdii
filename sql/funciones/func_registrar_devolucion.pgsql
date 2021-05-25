/*
Función: func_registrar_devolucion

Descripción: Funcion llamada para registrar la devolución de una película alquilada.

Entradas: 
customer_id integer,
staff_id integer,
rental_id integer,
amount numeric(5,2)

Usuarios autorizados:
- video

Roles autorizados:
- emp

Autor: Andres Cornejo
*/

CREATE or replace FUNCTION func_registrar_devolucion(
    in p_customer_id int,
    in p_staff_id int,
    in p_rental_id int,
    out out_code int
)
AS 
$$
declare
	var_current_date timestamp := (SELECT CURRENT_TIMESTAMP(0));
    -- Conseguir el id del inventario del que se alquiló la pelicula.
    var_inventory_id int := (select r.inventory_id from rental r where r.rental_id = p_rental_id);
    -- Conseguir el id de la pelicula alquilada.
    var_film_id int := (select i.film_id from inventory i where i.inventory_id = var_inventory_id);
    -- Conseguir la cantidad de días de alquiler por película.
    var_rental_days int := (select f.rental_duration from public.film f where var_film_id = f.film_id);
    -- Conseguir la fecha en la que se alquiló la película.
    var_date_rented timestamp := (select r.rental_date from public.rental r where r.rental_id = p_rental_id);
    -- Conseguir la fecha límite de devolución de la película.
    var_return_date timestamp := var_date_rented + make_interval(days=>var_rental_days);
    -- Conseguir la monto a pagar, en caso de que no se entregue tarde la película.
    var_std_amount numeric(5,2) := (select f.rental_rate from public.film f where var_film_id = f.film_id);

    var_days_late int := 0;
    
begin
    if (select r.return_date from rental r where r.rental_id = p_rental_id) is not null then 
		raise exception 'P0001';
    end if;
    -- Verificar si la devolución es tardía.
    if var_return_date < var_current_date then
        -- Conseguir la cantidad de días tardíos en la devolución.
        var_days_late := (SELECT (var_current_date::date - var_return_date::date));
        -- Por cada día tardío se cobra el 100% del alquiler.
        var_std_amount := var_std_amount + (var_std_amount * var_days_late);
    end if;

    -- Registrar la devolución.
    update rental
        set return_date = var_current_date
    where rental_id = p_rental_id;

    -- Insertar el pago.
    insert into payment(customer_id, staff_id, rental_id, amount, payment_date)
    values(p_customer_id, p_staff_id, p_rental_id, var_std_amount, var_current_date);

    out_code := 0;

	exception
		when sqlstate 'P0001' then 
			out_code = -1;
			raise notice 'ERROR: Ese alquiler ya fue pagado. ID--> %', p_rental_id;
		when others then
			out_code := -1;
			raise notice 'Ha ocurrido un error al intentar realizar una devolución.';
            raise notice '% %', SQLERRM, SQLSTATE;
end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;
