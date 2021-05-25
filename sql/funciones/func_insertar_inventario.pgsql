/*
Función: func_insertar_inventario

Descripción: Funcion llamada para ingresar nuevas películas al sistema.

Entradas: 
nombre de película, varchar
año de publicación de película, year
language_id, int
staff_id, int

Usuarios autorizados:
- video

Roles autorizados:
- emp

Autor: Andres Cornejo
*/

CREATE or replace FUNCTION func_insertar_inventario(
    in p_film_id int,
    in p_store_id int,
    in p_copies int,
    out out_code int
)
AS 
$$
begin

    for counter in 1..p_copies loop
        insert into public.inventory(film_id, store_id, last_update)
        values(p_film_id, p_store_id, current_timestamp);
    end loop;

    out_code := 0;
	exception
		when others then
			out_code := -1;
			raise notice 'Ha ocurrido un error al intentar insertar copias.';
            raise notice '% %', SQLERRM, SQLSTATE;
end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;