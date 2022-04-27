/*Tarea 1
#Iñaki Fernández*/


SELECT *
from suppliers s 
where contact_title = 'Sales Representative'


select *
from suppliers s 
where contact_title != 'Makerting Managers'


select *
from orders o join customers c on (o.customer_id = c.customer_id )
where c.country != 'USA'


select p
from orders o join order_details od on(o.order_id=od.order_id) join products p on(od.product_id=p.product_id)
where p.category_id = 4

select *
from orders o 
where o.ship_country ='Belgium' 
or o.ship_country ='France'

select ship_country 
from orders o 
where ship_country  in ('Mexico','Brazil','Venezuela','Argentina')

select ship_country 
from orders o 
where ship_country not in ('Mexico','Brazil','Venezuela','Argentina')

select concat( e.first_name,' ',e.last_name) as Nombre
from employees e 

select sum(unit_price*units_in_stock)
from products p 

select c.country, count (customer_id) 
from customers c 
group by c.country 

select e.first_name, e.last_name,  AGE(e.birth_date)
from employees e 

select o.customer_id, c.contact_name, max(o.order_id)
from orders o join customers c using(customer_id)
group by customer_id,contact_name;

select contact_title, count(*)
from customers c 
group by contact_title 

select category_name, count(*)
from products p join categories c using(category_id)
group by category_name

select p.product_name, p.reorder_level,p.units_in_stock, count(od.order_id)
from products p join order_details od using(product_id) join orders o using(order_id)
where p.reorder_level >= p.units_in_stock and p.discontinued !=1
group by p.product_name, p.reorder_level, p.units_in_stock 

select distinct o.ship_address
from orders o join order_details od using(order_id)
where od.quantity = ( select max(od2.quantity)from order_details od2)

select c.customer_id, count(o.order_id) as "no_orders",
case
	when(count(o.order_id)<10 ) then 'malo'
	when(count(o.order_id) >= 10 and count(o.order_id)<20) then 'regular'
	when(count(o.order_id) >= 20 ) then 'bueno'
end as Rating

from orders o right outer join customers c using(customer_id) 
group by c.customer_id 
order by 2 asc

select distinct e.employee_id, (e.first_name || ' ' || e.last_name)   
from orders o join employees e using(employee_id) 
where extract(month from o.order_date) = 12 
and extract(day from o.order_date) = 25
or extract(day from o.order_date) = 24

select distinct p.product_name 
from products p join order_details od using(product_id) join orders o using(order_id)
where extract(month from o.shipped_date) = 12 
and extract(day from o.shipped_date) = 25


select distinct o.ship_country 
from orders o join order_details od2 using(order_id) 
where od2.quantity = (select max(od.quantity) from order_details od)

