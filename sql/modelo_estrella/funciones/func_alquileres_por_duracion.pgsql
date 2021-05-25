CREATE or replace FUNCTION func_olap_alquileres_por_duracion(
    in in_num_dias int
) 
returns table (
	"Duración de préstamo" int, 
	"Número de alquileres" int, 
	"Monto cobrado" money) 
AS 
$$
begin

    if in_num_dias >= 0 then
		return query
			select 
			in_num_dias::int,
			count(h.numero_alquileres)::int,
			sum(h.monto_cobrado_alquileres)

			from hechos_ventas h
			inner join dim_duracion_alquiler da on da.dim_duracion_alquiler_id = h.dim_duracion_alquiler_fk
			where da.dias = in_num_dias;
    else
		raise exception 'P0001';
    end if;

    exception 
		when sqlstate 'P0001' then 
			raise notice 'ERROR: Ha ingresado un número de días inválido --> %', in_num_dias;
        when others then
            raise notice 'La transaccion tiene un estado corrupto. Se abortó.';
            raise notice '% %', SQLERRM, SQLSTATE;

end;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;