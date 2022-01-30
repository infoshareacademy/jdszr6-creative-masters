/*
 This function defines top 1 category for each country
 */
select country, name, amount
from (
         select cat.name,
                cou.country,
                count(*)                                                      amount,
                count(distinct rental_id)                                     amount1,
                RANK() OVER (partition by cou.country order by count(*) desc) rank_num
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
         group by cat.name, cou.country
         order by 2, 4
     ) zz
where zz.rank_num = 1
order by 1;