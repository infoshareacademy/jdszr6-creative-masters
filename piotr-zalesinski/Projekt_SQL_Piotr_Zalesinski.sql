select distinct 
to_char(r.rental_date, 'yyyy-mm-dd') as rental_date,
 cast(r.return_date as date) as return_date,
 case when cast(r.return_date as date) - cast(r.rental_date as date) = 0 then 1 else cast(r.return_date as date) - cast(r.rental_date as date) end as Actual_Rental_Duration,
 p.amount as Rental_Payment, r.rental_id, i.film_id, r.customer_id,
 c.name as film_category as Film_Category, f.title as film_title, f.rating, f.rental_rate, f.rental_duration as Planned_Rental_Duration, 
 f.release_year, f.length as film_length,
 case when to_char(r.return_date , 'YYYYMMDD')::integer - to_char(r.rental_date , 'YYYYMMDD')::integer > f.rental_duration then 'Exceeded Limit' else 'Just in time' end as Actual_Rental_Duration,
 p.amount-f.rental_rate as rental_rate_amount_diff, 
 cl.*
 from rental r
 inner join payment p on r.rental_id = p.rental_id
 inner join inventory i on r.inventory_id = i.inventory_id
 inner join film f on i.film_id = f.film_id
 inner join film_category fc on f.film_id = fc.film_id
 inner join category c on fc.category_id = c.category_id
 inner join customer_list cl on p.customer_id = cl.id
 where to_char(r.rental_date, 'yyyy') like '2005'
 -- 2006 ignored - obserwacje tylko w jednym dniu
 order by to_char(r.rental_date, 'yyyy-mm-dd') asc
