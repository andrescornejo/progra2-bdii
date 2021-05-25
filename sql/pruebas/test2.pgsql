select * from customer; --601 and 602, staff 1 and 2 respectively

select * from staff;

select * from rental
order by rental_id desc; -- 16051 and 16052

select * from payment
order by payment_id desc;

select * from inventory where film_id = 4; -- film_id 4 store 2

select public.func_registrar_alquiler(
	602,
	2,
	4
);

update rental
	set rental_date = rental_date - make_interval(days=>50)
where rental_id = 16057;

SELECT public.func_registrar_devolucion(
	602,
	2,
	16057
);

SELECT ('2021-05-20 23:16:14'::date - '2019-03-25 02:16:14'::date);

SELECT extract(days FROM '2019-03-25 17:16:14'::timestamp);

SELECT ('2021-05-20 23:16:14'::timestamp > '2019-03-25 02:16:14'::timestamp);