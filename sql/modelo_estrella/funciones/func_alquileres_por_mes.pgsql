CREATE or replace FUNCTION func_olap_alquileres_por_mes(
    in in_num_mes int,
    in in_categoria text,
    out out_alq_por_mes int --Output de la función va a ser usado para verificar su validez.
) 
AS 
$$
begin

    if in_num_mes > 0 and in_num_mes < 13 then
        out_alq_por_mes := (select count(*) from hechos_ventas h
        inner join dim_tiempo dt on dt.dim_tiempo_id = h.hechos_ventas_id
        inner join dim_pelicula dp on dp.dim_pelicula_id = h.dim_pelicula_fk
        where dt.mes = in_num_mes and dp.categoria = in_categoria);
    else
		raise exception 'P0001';
    end if;

    exception 
		when sqlstate 'P0001' then 
			out_alq_por_mes = -1;
			raise notice 'ERROR: Ha ingresado un número de mes inválido --> %', in_num_mes;
        when others then
            out_alq_por_mes  := -1;
            raise notice 'La transaccion tiene un estado corrupto. Se abortó.';
            raise notice '% %', SQLERRM, SQLSTATE;

end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;