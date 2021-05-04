/*
Procedimiento almacenado: sp_nuevo_cliente

Descripcion: Proceso a ser llamado por un usuario cuando se desea insertar un nuevo cliente al sistema.

Entradas: 
- ID de una tienda, integer
- Primer nombre, varchar
- Apillido, varchar
- Email, varchar
- ID de la dirección
- Variable de retorno de id del cliente

Usuarios autorizados:
- video

Roles autorizados:
- emp
- admin

Autor: Andres Cornejo
*/
Create or Replace Procedure "public".sp_nuevo_cliente(
    in p_first_name varchar,
    in p_last_name varchar, 
    in p_email varchar,
    in p_city_name varchar,
    in p_address1 varchar, 
    in p_address2 varchar,
    in p_district varchar, 
    in p_zipcode varchar, 
    in p_phone  varchar)

Language plpgsql
--SECURITY DEFINER
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
    raise notice 'city_id--> %', var_city_id;

    -- Luego se inserta la dirección del cliente.
	insert into "public"."address" (address, address2, district, city_id, postal_code, phone, last_update)
		values(p_address1, p_address2, p_district, var_city_id, p_zipcode, p_phone, var_current_time)
        returning address_id into var_address_id;

    -- Finalmente se inserta el cliente.
	insert into "public"."customer"(store_id, first_name, last_name, email, address_id, activebool, create_date, last_update, active)
        -- store_id es alambrada a 1 por limitación del diseño de la base de datos.
		values(1, p_first_name, p_last_name, p_email, var_address_id, true, var_current_date, var_current_time, 1)
        returning customer_id into var_customer_id;

exception when others then
        raise notice 'La transaccion tiene un estado corrupto. Se abortó.';

    raise notice '% %', SQLERRM, SQLSTATE;

end;
$$ ;
