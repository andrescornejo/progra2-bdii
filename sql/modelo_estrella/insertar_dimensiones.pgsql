-- Dimensión pelicula.
INSERT INTO public.dim_pelicula(dim_pelicula_id, categoria)
select f.film_id, cat.name
	from film f
	inner join film_category fc on f.film_id = fc.film_id
	inner join category cat on fc.category_id = cat.category_id
ON CONFLICT DO NOTHING;
	
-- select * from dim_pelicula;

-- Dimensión lenguaje.
INSERT INTO public.dim_lenguaje(dim_lenguaje_id, lenguaje)
	select language_id, name from language
	ON CONFLICT DO NOTHING;
	
-- select * from dim_lenguaje;

-- Dimensión lugar.
INSERT INTO public.dim_lugar(dim_lugar_id, city, country)
	select s.store_id, ci.city, co.country
	from store s
	inner join address ad on s.address_id = ad.address_id
	inner join city ci on ad.city_id = ci.city_id
	inner join country co on ci.country_id = co.country_id
	ON CONFLICT DO NOTHING;

-- Dimensión duracion de alquiler.
INSERT INTO public.dim_duracion_alquiler(dim_duracion_alquiler_id, dias)
	select r.rental_id, (SELECT (r.return_date::date - r.rental_date::date))
	from rental r 
	ON CONFLICT DO NOTHING;

-- Dimensión de tiempo/fecha.
INSERT INTO public.dim_tiempo(dim_tiempo_id, anno, mes, dia)
	select rental_id, 
	EXTRACT(year FROM rental_date)::int,
	EXTRACT(MONTH FROM rental_date)::int,
	EXTRACT(day FROM rental_date)::int
	from rental 
	ON CONFLICT DO NOTHING;
	
	-- select * from dim_tiempo;

-- Tabla de hechos
CREATE TEMP TABLE temp_hechos(
    dim_pelicula_id int not null,
    dim_lugar_id int not null,
    dim_lenguaje_id int not null,
    dim_tiempo_id int not null,
    dim_duracion_alquiler_id int not null,
	num_alquileres int not null,
    monto_cobrado_alquileres_tmp money
);

insert into temp_hechos(dim_pelicula_id, dim_lugar_id, dim_lenguaje_id, 
						dim_tiempo_id, dim_duracion_alquiler_id, num_alquileres, monto_cobrado_alquileres_tmp)
select f.film_id, s.store_id, l.language_id, dt.dim_tiempo_id, r.rental_id, 1, pay.amount
	from rental r
	inner join public.inventory i on i.inventory_id=r.inventory_id
	inner join public.film f on f.film_id = i.film_id
	inner join public.store s on s.store_id=i.store_id
	inner join public.language l on l.language_id=f.language_id
	inner join public.dim_duracion_alquiler da on (SELECT (r.return_date::date - r.rental_date::date)) = da.dim_duracion_alquiler_id
	left join public.payment pay on pay.rental_id=r.rental_id
	inner join public.dim_tiempo dt on dt.dim_tiempo_id = r.rental_id;
	 --select * from temp_hechos;
	 --drop table temp_hechos;

INSERT INTO public.hechos_ventas(
	dim_pelicula_fk, dim_lugar_fk, dim_lenguaje_fk, dim_tiempo_fk, 
	dim_duracion_alquiler_fk, numero_alquileres, monto_cobrado_alquileres)
	
	select dim_pelicula_id, dim_lugar_id, dim_lenguaje_id, dim_tiempo_id, 
		   dim_duracion_alquiler_id, count(*), sum(monto_cobrado_alquileres_tmp)
	from temp_hechos
	group by dim_pelicula_id, dim_lugar_id, dim_lenguaje_id, dim_tiempo_id, dim_duracion_alquiler_id;