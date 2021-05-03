create LANGUAGE plpgsql;

set varout int;
set varbool int;

begin
CALL public.sp_get_country_id(
	'Abha', 
	varout, 
	varbool
)
end;