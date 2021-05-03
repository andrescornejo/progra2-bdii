Create or Replace Procedure "public".sp_insertar_address(
    in p_city_name varchar,
    in p_address1 varchar, 
    in p_address2 varchar,
    in p_district varchar, 
    in p_zipcode varchar, 
    in p_phone  varchar,
    inout p_out_id integer)

Language plpgsql
SECURITY DEFINER
AS 
$$
declare
    var_city_id int;
	var_current_time timestamp := (SELECT CURRENT_TIMESTAMP(0));
begin
    select c.city_id 
    into var_city_id
    from "public".city as c
    where c.city = p_city_name;

	insert into "public"."address" (address, address2, district, city_id, postal_code, phone, last_update)
		values(p_address1, p_address2, p_district, var_city_id, p_zipcode, p_phone, var_current_time)
        returning address_id into p_out_id;

exception when others then
    raise notice 'The transaction is in an uncommittable state. '
                 'Transaction was rolled back';

    raise notice '% %', SQLERRM, SQLSTATE;
    rollback;

end;
$$ ;