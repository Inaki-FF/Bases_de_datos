--1
create table pago as (
with t as (
	select p.payment_date as fecha, p.payment_id as id from payment p
	where p.payment_id > 1), 
	s as(
	select sum(age(t.fecha, pa.payment_date)) as tiempo, pa.customer_id as id2, count(pa.payment_id) as suma 
	from payment pa join t on (pa.payment_id = t.id-1)
	where age(t.fecha, pa.payment_date)>'00:00'::interval
	group by pa.customer_id 
) 
select concat(c.first_name, ' ', c.last_name) as "nombre", (s.tiempo/s.suma) as "Tiempo promedio de pago", c.customer_id as id 
from customer c join s on (c.customer_id = s.id2)
group by c.customer_id,(s.tiempo/s.suma),concat(c.first_name, ' ', c.last_name) order by c.customer_id asc
)

select * from pago;

--2
select * from histogram('pago', 'extract(epoch from
"Tiempo promedio de pago")') 



-- 3 --
create sequence seq minvalue 1 maxvalue 300000 increment by 1

create sequence seq2 minvalue 2 maxvalue 300000 increment by 1



create table renta as(
with r as (
	select nextval ('seq') as "secuencia", r2.rental_date as fecha, r2.rental_id as id from rental r2
	where r2.rental_id <>76 order by r2.customer_id, r2.rental_date asc), 
	x as (
	select nextval ('seq2') as "secuencia2", r2.customer_id, r2.rental_date as fecha, r2.rental_id as id from rental r2
	order by r2.customer_id, r2.rental_date asc ),
	 w as(
	select sum(age(r.fecha, x.fecha)) as tiempo, x.customer_id as id2, count(x.id) as suma 
	from x join r on (r."secuencia" = x."secuencia2"-1)
	where age(r.fecha, x.fecha)>'00:00'::interval
	group by x.customer_id
)
select concat(c.first_name, ' ', c.last_name) as "nombre", (w.tiempo/w.suma) as "Tiempo promedio de renta", c.customer_id as id 
from customer c join w on (c.customer_id=w.id2)
group by c.customer_id,(w.tiempo/w.suma),concat(c.first_name, ' ', c.last_name)
)
select * from renta


select p."nombre", (p."Tiempo promedio de pago"-r."Tiempo promedio de renta") as "diferencia", p.id 
from pago p 
join renta r using (id) 
order by p.id asc; 
