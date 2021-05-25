/*
Funcion: func_get_customer_id

Descripcion: Retorna el id del cliente a partir del nombre.

Entradas: 
- email del cliente

Usuarios autorizados:
- video

Roles autorizados:
- emp
- admin

Autor: Andres Cornejo
*/
CREATE or replace FUNCTION func_get_customer_id(IN in_email varchar, OUT out_id int) AS $$
BEGIN
	-- Buscar si la ciudad existe en la tabla y seleccionar su id.
	if in_email in (select c.email from "public".customer as c) then
        select c.customer_id
        into out_id 
        from "public".customer as c
        where c.email = in_email
        limit 1;
	else
		raise exception 'P0001';
	end if;

	exception
		when sqlstate 'P0001' then 
			out_id = -1;
			raise notice 'No se encontró una ciudad con ese nombre.--> %', in_email;
			raise notice 'out_id--> %', out_id;
			
		when others then
			raise exception 'La función tiene un estado corrupto.';
END;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;