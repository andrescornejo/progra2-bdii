/*
Funcion: func_get_city_id 

Descripcion: Retorna el id de una ciudad a partir del nombre.

Entradas: 
- Nombre de la ciudad, varchar 

Usuarios autorizados:
- video

Roles autorizados:
- emp
- admin

Autor: Andres Cornejo
*/
CREATE or replace FUNCTION func_get_city_id(IN city_name varchar,OUT out_id int) AS $$
BEGIN
	-- Buscar si la ciudad existe en la tabla y seleccionar su id.
	if city_name in (select c.city from "public".city as c) then
        select c.city_id 
        into out_id 
        from "public".city as c
        where c.city = city_name
        limit 1;
	else
		raise exception 'P0001';
	end if;

	exception
		when sqlstate 'P0001' then 
			out_id = -1;
			raise notice 'No se encontró una ciudad con ese nombre.--> %', city_name;
			raise notice 'out_id--> %', out_id;
			
		when others then
			raise exception 'La función tiene un estado corrupto.';
END;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;