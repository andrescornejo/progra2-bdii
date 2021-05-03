CREATE or replace FUNCTION func_get_country_ID(IN city_name varchar,OUT out_id int) AS $$
BEGIN
	if city_name in (select c.city from "public".city as c) then
        select c.city_id 
        into out_id 
        from "public".city as c
        where c.city = city_name
        limit 1;

	else
	    --RAISE EXCEPTION 'City doesnt exist--> %', city_name;
        out_id = -1;
	end if;
END;
$$ 
LANGUAGE plpgsql
SECURITY DEFINER;