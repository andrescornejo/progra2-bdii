/*
Función: func_nueva_pelicula

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

CREATE or replace FUNCTION func_nueva_pelicula(
    in p_film_title text,
    in p_description text,
    in p_release_year year,
    in p_lang_id int,
    in p_rental_duration int,
    in p_rental_rate numeric(4,2),
    in p_length int,
    in p_replacement_cost numeric(5,2),
    in p_rating mpaa_rating,
    in p_special_features text[],
    in p_fulltext tsvector,
    out out_code int
)
AS 
$$
begin
    insert into film(title, description, release_year, language_id, rental_duration,
                    rental_rate, length, replacement_cost,
                    rating, last_update, special_features, fulltext)
    values(p_film_title, p_description, p_release_year, p_lang_id, p_rental_duration,
        p_rental_rate, p_length, p_replacement_cost, p_rating, CURRENT_TIMESTAMP,
        p_special_features, p_fulltext);

    out_code := 0;
	exception
		when others then
			out_code := -1;
			raise notice 'Ha ocurrido un error al intentar insertar la película %.', p_film_title;
            raise notice '% %', SQLERRM, SQLSTATE;
end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;
