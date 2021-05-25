/*
Función: func_buscar_pelicula

Descripción: Funcion llamada para registrar la devolución de una película alquilada.

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

CREATE or replace FUNCTION func_buscar_pelicula(
    in p_film_name text,
    in p_film_year year,
    in p_lang_id int,
    out out_code int
)
AS 
$$
begin
    out_code := (select f.film_id from film f
                    where f.title = p_film_name and 
                    f.release_year = p_film_year and
                    f.language_id = p_lang_id);

    if out_code is null then
        raise exception 'P0001';
    end if;

	exception
	    when sqlstate 'P0001' then 
            out_code = -1;
	        raise exception 'La película % no fue encontrada.', p_film_name;

		when others then
			out_code := -1;
			raise notice 'Ha ocurrido un error al intentar realizar una devolución.';
            raise notice '% %', SQLERRM, SQLSTATE;
end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;
