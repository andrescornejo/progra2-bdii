CREATE or replace FUNCTION func_olap_rollup_anno_mes_monto() 
returns table (
	"Año" int, 
	"Mes" int, 
	"Monto cobrado" money) 
AS 
$$
begin

    return query
    	select
    		dt.anno,
    		dt.mes,
    		sum(h.monto_cobrado_alquileres)
    	from hechos_ventas h
    	inner join dim_tiempo dt on h.dim_tiempo_fk = dt.dim_tiempo_id
    	group by 
    		rollup(dt.anno, dt.mes);

    exception 
        when others then
            raise notice 'La transaccion tiene un estado corrupto. Se abortó.';
            raise notice '% %', SQLERRM, SQLSTATE;

end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;