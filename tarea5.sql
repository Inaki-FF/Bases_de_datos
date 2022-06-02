ith movies_per_store as (select store_id, count(i.film_id) as "num pels" from inventory i group by store_id),


	nummax as (select 50/.5 as "pels por cilindro"),

--altura del cilindro, aquí suponemos que están pegadas todas las películas, 
-- si les quisiéramos dar una separación de 1 cm entre c/u sería algo como 
-- select 2.5*nm."pels por cilindro"-1 as "altura"  from nummax nm, el -1 porque para el techo ya no necesitas separación
	ht as (select 1.5*nm."pels por cilindro" as "altura"  from nummax nm),

	rad as (select sqrt(power(30/2,2) + power(21/2,2)) as "radio")


 select pi()*power(r."radio",2)*h."altura" as "volumen" from rad r, ht h;



select store_id, ceil(mps."num pels"/100) as "cilindros necesarios por tienda" from movies_per_store mps


