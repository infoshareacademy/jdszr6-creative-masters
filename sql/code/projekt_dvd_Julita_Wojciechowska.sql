create or replace view film_analysis_2 as 
select c2.category_id, c2."name" , c3.city , c4.country , i.store_id, c.customer_id , p.rental_id , p.amount , f.title , f.film_id , f.length , f.rental_rate, i.inventory_id 
from customer c
join rental r 
on c.customer_id =r.customer_id 
join inventory i 
on r.inventory_id =i.inventory_id 
join film f 
on i.film_id = f.film_id 
join film_category fc 
on i.film_id = fc.film_id
join category c2 
on fc.category_id = c2.category_id 
join address a 
on c.address_id = a.address_id 
join city c3 
on a.city_id = c3.city_id 
join country c4 
on c3.country_id = c4.country_id 
join payment p 
on p.customer_id = c.customer_id 

----najpopularniejsze filmy w kategoriach ogolne zapytanie--ok
create view a as
select distinct name as kategoria_filmu, 
mode() within group (order by title) as tytul_filmu
from film_analysis_2
group by name
order by name asc 

--1a --OK
select kategoria_filmu, tytul_filmu, count(tytul_filmu), fa.country
from a
join film_analysis_2 fa 
on fa.name = a.kategoria_filmu
group by kategoria_filmu, tytul_filmu, fa.country
order by fa.country

--1b DO DOKONCZENIA
select distinct kategoria_filmu, tytul_filmu, count(r.rental_id) over (partition by tytul_filmu)
from a
join film f 
on f.title = a.tytul_filmu
join inventory i 
on i.film_id = f.film_id
join rental r 
on r.inventory_id = i.inventory_id 
group by kategoria_filmu, tytul_filmu, r.rental_id
order by count(r.rental_id) over (partition by tytul_filmu) desc

select distinct customer_id, count(rental_id) over (partition by customer_id) as wypozyczenia_klienta
from rental r 
order by count(rental_id) over (partition by customer_id) desc


--2a OK
select distinct kategoria_filmu, tytul_filmu, f.length
from a
join film f 
on f.title = a.tytul_filmu
order by f.length desc 

--2b,c --OK
select distinct kategoria_filmu, tytul_filmu, f.film_id, f.rental_rate, 
count(i.inventory_id) over (partition by i.film_id) as ile_wypozyczen, 
(count(i.inventory_id) over (partition by i.film_id))*f.rental_rate as przychod_z_filmu
from a
join film f 
on f.title = a.tytul_filmu
join inventory i 
on f.film_id = i.film_id 
order by (count(i.inventory_id) over (partition by i.film_id))*f.rental_rate desc

select distinct film_id, count(inventory_id) over (partition by film_id)
from inventory i 
order by count(inventory_id) over (partition by film_id) desc

--2d ZROBIC/analiza
create view v_trailery as
select distinct f.special_features ,count(f.special_features) as ile_trailerow
from film f 
join inventory i 
on f.film_id = i.film_id 
join rental r 
on i.inventory_id =r.inventory_id
where f.special_features::text like '%railers%'
group by f.special_features
order by count(f.special_features) desc

select f.inventory_id, count(f.special_features)
from v_trailery
join film f 
on f.special_features = v_trailery.special_features



--3a OK
select kategoria_filmu, mode() within group (order by (ac.first_name ||' '||ac.last_name)) as najpopularniejszy_aktor
from a
join film_analysis_2 fa 
on fa.name = a.kategoria_filmu
join actor ac 
on fa.film_id = ac.actor_id 
group by a.kategoria_filmu

--3b  OK
select distinct a.actor_id,a.first_name ||' '||a.last_name, count(fa.film_id) over (partition by a.actor_id) as ile_razy_wystepuje
from film_actor fa 
join actor a 
on fa.actor_id = a.actor_id 
group by a.actor_id, fa.film_id 
order by count(fa.film_id) over (partition by a.actor_id) desc

--3c  OK
select kategoria_filmu, mode() within group (order by ac.first_name ||' '||ac.last_name) as im_nazw
from a 
join film f 
on f.title = a.tytul_filmu
join film_actor fa2 
on fa2.film_id = f.film_id
join actor ac 
on ac.actor_id = fa2.actor_id 
group by kategoria_filmu--, ac.first_name , ac.last_name 
order by kategoria_filmu asc

--4a OK
select distinct name, count(rental_id) over (partition by name)
from film_analysis_2 fa
group by name, rental_id 

create view v_analiza_do_pktd as
select distinct r.inventory_id , i.film_id, fc.category_id , c."name" , count(r.inventory_id) over (partition by i.film_id) as ile_razy
from inventory i 
join rental r 
on r.inventory_id = i.inventory_id 
join film_category fc 
on fc.film_id = i.film_id
join category c 
on c.category_id = fc.category_id
order by r.inventory_id 

select mode() within group (order by name)
from v_analiza_do_pktd 


--4b ok

select distinct c.category_id ,c."name" , sum(f.rental_rate) over (partition by c."name")
from category c 
join film_category fc 
on c.category_id = fc.category_id 
join film f 
on fc.film_id =f.film_id 
order by sum(f.rental_rate) over (partition by c."name") desc


