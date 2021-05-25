SELECT public.func_nueva_pelicula(
	'El papá de los tomates'::text, 
	'Un tomate se vuelve el papá de los tomates'::text, 
	2021::year, 
	2, 
	5, 
	10.99, 
	90, 
	100.99, 
	'PG-13'::mpaa_rating, 
	2, -- category_id
	ARRAY['bts'], 
	'Tomates xd kolombia'::tsvector
)

SELECT public.func_nueva_pelicula(
	'Ya logramos la replicacion'::text, 
	':D yosoytec VivaSanPedro'::text, 
	2021::year, 
	2, 
	3, 
	99.99, 
	90, 
	100.99, 
	'R'::mpaa_rating, 
	ARRAY['vivalaliga'], 
	'kolombia'::tsvector
)


select * from film
order by film_id desc;

select * from language