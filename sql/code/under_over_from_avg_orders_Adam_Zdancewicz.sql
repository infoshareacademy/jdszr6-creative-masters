/*
 this query compares each customer total orders quantity to average of all orders for customers and define it its
 under or above
 */

with total_orders_by_customer as
         (select r.customer_id,
                 concat(c.first_name, ' ', c.last_name) as full_name,
                 count(distinct r.rental_id)            as orders_quantity
          from rental r
                   join customer c
                        on c.customer_id = r.customer_id
          group by r.customer_id, full_name
          order by orders_quantity desc),

     avg_orders_quantity as
         (
             select round(avg(orders_quantity)) as avg_orders
             from total_orders_by_customer
         ),

most_popular_category_by_customer as (
    select customer_id, name, amount
from (
         select cat.name,
                cu.customer_id,
                count(*)                                                      amount,
                count(distinct rental_id)                                     amount1,
                RANK() OVER (partition by cu.customer_id order by count(*) desc) rank_num
         from rental r
                  inner join customer cu
                             on r.customer_id = cu.customer_id
                  inner join inventory i
                             on i.inventory_id = r.inventory_id
                  inner join film f
                             on f.film_id = i.film_id
                  inner join film_category fc
                             on f.film_id = fc.film_id
                  inner join category cat
                             on fc.category_id = cat.category_id
                  inner join address a
                             on cu.address_id = a.address_id
                  inner join city c
                             on c.city_id = a.city_id
                  inner join country cou
                             on c.country_id = cou.country_id
         group by cat.name, cu.customer_id
         order by 2, 4
     ) zz
where zz.rank_num = 1
order by 1)

select tobc.customer_id,
       tobc.full_name,
       tobc.orders_quantity,
       case
           when tobc.orders_quantity > aoq.avg_orders then 'above'
           when tobc.orders_quantity < aoq.avg_orders then 'under'
           else 'equal'
           end as avg_orders_status,
       mpcbc.name

from total_orders_by_customer tobc
         inner join avg_orders_quantity aoq on tobc.customer_id = tobc.customer_id
inner join most_popular_category_by_customer mpcbc on tobc.customer_id = mpcbc.customer_id
order by customer_id