/*
Funcion: func_nuevo_cliente

Descripcion: Función a ser llamada por un usuario cuando se desea insertar un nuevo cliente al sistema.
Descripcion: Proceso almacenado que funciona como un wrapper para sp_nuevo_cliente.

Entradas: 
- ID de una tienda, integer
- Primer nombre, varchar
- Apillido, varchar
- Email, varchar
- Nombre de la ciudad, varchar
- Línea de dirección 1, varchar
- Línea de dirección 2, varchar (nullable)
- Distrito, varchar
- Código postal, varchar
- Teléfono, varchar

Usuarios autorizados:
- video

Roles autorizados:
- emp
- admin

Autor: Andres Cornejo
*/

CREATE or replace FUNCTION func_nuevo_cliente(
    in p_store_id int,
    in p_first_name varchar,
    in p_last_name varchar, 
    in p_email varchar,
    in p_city_name varchar,
    in p_address_line1 varchar, 
    in p_address_line2 varchar,
    in p_district varchar, 
    in p_zipcode varchar, 
    in p_phone  varchar,
    out out_code int --Output de la función va a ser usado para verificar su validez.
) 
AS 
$$
declare
    var_city_id integer;
    var_address_id integer;
    var_customer_id integer;
	var_current_time timestamp := (SELECT CURRENT_TIMESTAMP(0));
    var_current_date date := (SELECT CURRENT_DATE);
begin

    --Primero se selecciona el id de la ciudad, utilizando el parámetro de entrada.
    var_city_id := (SELECT public.func_get_city_id(p_city_name));
    --raise notice 'city_id--> %', var_city_id; --DEBUG

    -- Luego se inserta la dirección del cliente.
	insert into "public"."address" (address, address2, district, city_id, postal_code, phone, last_update)
		values(p_address_line1, p_address_line2, p_district, var_city_id, p_zipcode, p_phone, var_current_time)
        returning address_id into var_address_id;

    -- Finalmente se inserta el cliente.
	insert into "public"."customer"(store_id, first_name, last_name, email, address_id, activebool, create_date, last_update, active)
		values(p_store_id, p_first_name, p_last_name, p_email, var_address_id, true, var_current_date, var_current_time, 1)
        returning customer_id into var_customer_id;
    
    out_code := 0;

    exception when others then
        out_code := -1;
        raise notice 'La transaccion tiene un estado corrupto. Se abortó.';
        raise notice '% %', SQLERRM, SQLSTATE;

end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;