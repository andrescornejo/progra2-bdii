CREATE or replace FUNCTION func_olap_cube_anno_cat_monto() 
returns table (
	"Año" int, 
    "Categoría" text,
	"Número de alquileres" int, 
	"Monto cobrado" money) 
AS 
$$
begin

    return query
        select
        	dt.anno,
        	dp.categoria,
        	count(h.numero_alquileres)::int,
        	sum(h.monto_cobrado_alquileres)
        from hechos_ventas h
        inner join dim_tiempo dt on h.dim_tiempo_fk = dt.dim_tiempo_id
        inner join dim_pelicula dp on h.dim_pelicula_fk = dp.dim_pelicula_id
        	group by cube(dt.anno, dp.categoria);

    exception 
        when others then
            raise notice 'La transaccion tiene un estado corrupto. Se abortó.';
            raise notice '% %', SQLERRM, SQLSTATE;

end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;