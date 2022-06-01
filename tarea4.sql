
with dif_pagos as(
select c.customer_id, 
p.payment_date,
p.payment_date - lag(p.payment_date) over(partition by c.customer_id order by c.customer_id,p.payment_date)
as delta_pago
from customer c 
join payment p using (customer_id)
),

promedios as (
select dp.customer_id, 
	   concat(c2.first_name,' ', c2.last_name) as full_name,
	   (date_part('day', avg(dp.delta_pago))||' días')||' '||(date_part('hour',avg(dp.delta_pago))||' horas') as "Tiempo promedio entre pagos"
from dif_pagos dp
join customer c2 using (customer_id)
group by dp.customer_id, full_name
)

select * from promedios;




create or replace view tiempo_de_pago_promedio_epoch as 
with dif_pagos as(
select c.customer_id, 
p.payment_date,
p.payment_date - lag(p.payment_date) over(partition by c.customer_id order by c.customer_id,p.payment_date)
as delta_pago
from customer c 
join payment p using (customer_id)
)

select dp.customer_id,  extract(epoch from avg(dp.delta_pago)) as dias_promedio
from dif_pagos dp
join customer c2 using (customer_id)
group by dp.customer_id;


select * from histogram('tiempo_de_pago_promedio_epoch', 'dias_promedio')


create or replace view tiempo_de_pago_promedio_dias as 
with dif_pagos as(
select c.customer_id, 
p.payment_date,
p.payment_date - lag(p.payment_date) over(partition by c.customer_id order by c.customer_id,p.payment_date)
as delta_pago
from customer c 
join payment p using (customer_id)
)

select dp.customer_id,  extract(day from avg(dp.delta_pago))::numeric as dias_promedio
from dif_pagos dp
join customer c2 using (customer_id)
group by dp.customer_id;

select * from tiempo_de_pago_promedio_dias

select * from histogram('tiempo_de_pago_promedio_dias','dias_promedio')



with dif_pagos as(
select c.customer_id, 
		p.payment_date,
		p.payment_date - lag(p.payment_date) over(partition by c.customer_id order by c.customer_id,p.payment_date) as delta_pago	
from customer c 
join payment p using (customer_id)
),

promedios_pagos as (
select dp.customer_id, 
	   concat(c2.first_name,' ', c2.last_name) as full_name,
	   avg(dp.delta_pago) as avg_delta_pagos
from dif_pagos dp
join customer c2 using (customer_id)
group by dp.customer_id, full_name
),



dif_rentas as(
select c.customer_id, r.rental_date,
		r.rental_date - lag(r.rental_date) over(partition by c.customer_id order by c.customer_id, r.rental_date)
		as delta_renta
from customer c 
join rental r using (customer_id)
),

promedios_rentas as (
select dr.customer_id, 
	   concat(c2.first_name,' ', c2.last_name) as full_name,
	  avg(dr.delta_renta) as avg_delta_rentas
from dif_rentas dr
join customer c2 using (customer_id)
group by dr.customer_id, full_name
)

select *, 
(date_part('day', avg_delta_pagos-avg_delta_rentas)||' días'||' '||(date_part('hour',avg_delta_pagos-avg_delta_rentas)||' horas'))
as "Diferencia entre tiempo entre pago promedio y tiempo entre renta promedio"
from promedios_rentas
join promedios_pagos using (customer_id,full_name)


