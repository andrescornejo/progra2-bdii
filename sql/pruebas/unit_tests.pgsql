-- empleado tests
SELECT public.func_nuevo_cliente(
	2, 
	'Enrique', 
	'Arayita', 
	'arayita@gmail.com', 
	'Abha', 
	'idk', 
	'idk2', 
	'idk3', 
	'969696', 
	'905-286-0101'
);

select * from customer order by customer_id desc;

SELECT public.func_registrar_alquiler(
	600, 
	2, 
	1000
);

select * from rental order by rental_id desc;

update rental
	set rental_date = rental_date - make_interval(days=>50)
where rental_id = 16051;

SELECT public.func_registrar_devolucion(
	600, 
	2, 
	16051
);

select * from payment order by payment_id desc;

SELECT public.func_buscar_pelicula(
	'Grosse Wonderful', 
	2006, 
	1
);

select * from film;

--administrador tests

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
	ARRAY['bts'], 
	'Tomates xd kolombia'::tsvector
);

select * from film order by film_id desc;

SELECT public.func_insertar_inventario(
	1001, 
	2, 
	5
);

select * from inventory order by inventory_id desc;