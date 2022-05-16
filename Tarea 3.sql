---195421 Iñaki Fernández Fiscal

select c.first_name, c.last_name, c.email,c4.country 
from customer c join address a using(address_id) join city c3 using(city_id) join country c4 using(country_id)
where c4.country = 'Canada';


select c.first_name || ' ' || c.last_name as cliente , count(*) as numRenta
from customer c join rental r using (customer_id) join inventory i using(inventory_id) join film f using(film_id) 
where f.rating='R'	
group by c.customer_id
order by numRenta desc
limit 1;



--por tienda MALDITO DISTINCT ON no me acobarda de la sintaxis XD (odio overthinkear)--
select distinct on(s.store_id) s.store_id,f.title,count(*) numero_rentas
from customer c join store s using(store_id)  join rental r using (customer_id) join inventory i using(inventory_id) join film f using(film_id)
group by s.store_id,f.title
order by 1,3 desc;

--total--
select f.title, count(*)
from customer c join store s using(store_id)  join rental r using (customer_id) join inventory i using(inventory_id) join film f using(film_id)
group by f.title
order by 2 desc
limit 1;


select s.store_id, sum(p.amount)
from store s join inventory i using(store_id) join rental r using (inventory_id) join payment p using (rental_id)
group by s.store_id;
