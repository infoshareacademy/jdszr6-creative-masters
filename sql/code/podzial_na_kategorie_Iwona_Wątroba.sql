--1. ktora kategoria jest najbardziej popularna? Co ma najwiêkszy wp³yw na jej popularnoœæ

--która kategoriajest najczesciej wypozyczana ogolem
create view v_orders_quantity as
select
c."name" ,
count (c."name") as liczba_wypozyczen
from film f  
join film_category fc 
on fc.film_id = f.film_id 
join category c 
on c.category_id = fc.category_id
join inventory i 
on f.film_id = i.film_id
join rental r 
on r.inventory_id = i.inventory_id 
join customer c2 
on c2.customer_id = r.customer_id 
join address a 
on a.address_id = c2.address_id 
join city c3
on c3.city_id = a.city_id 
join country c4 
on c4.country_id = c3.country_id
group by c."name"
order by count (c."name") desc

--b)film
--podzial ze wzgledu na cene
create view v_length as
select distinct *
from(select
		c."name" ,
		round(avg(f.rental_rate) over (partition by c.category_id)::numeric,2) as srednia_cena_kategorii
		from film f 
		join film_category fc 
		on f.film_id = fc.film_id 
		join category c 
		on fc.category_id = c.category_id)rental_rate
order by srednia_cena_kategorii

--podzial ze wzgledu na dlugosc
create view v_length as
select distinct *
from(select 
		c.category_id ,
		c."name" ,
		round(avg(f.length) over (partition by c.category_id)::numeric,2) as srednia_dlugosc
		from film f 
		join film_category fc 
		on f.film_id = fc.film_id 
		join category c 
		on fc.category_id = c.category_id ) dlugosc
order by srednia_dlugosc

--która kategoria filmow przynosi najwieksze korzysci finansowe
create view v_przydod_z_danej_kategorii as
select distinct 
rental_rate."name",
srednia_cena_kategorii,
liczba_wypozyczen,
srednia_cena_kategorii*liczba_wypozyczen as przychod_z_danej_kat
from(select
		c."name" ,
		round(avg(f.rental_rate) over (partition by c.category_id)::numeric,2) as srednia_cena_kategorii
		from film f 
		join film_category fc 
		on f.film_id = fc.film_id 
		join category c 
		on fc.category_id = c.category_id)rental_rate
join(select
		c."name" ,
		count (c."name") as liczba_wypozyczen
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id 
		group by c."name"
		order by count (c."name")) ilosc_wypozyczen_danej_kat
on ilosc_wypozyczen_danej_kat."name"=rental_rate."name"
order by srednia_cena_kategorii*liczba_wypozyczen desc

--kategorie filmow z ktorymi dodtkami sa najczesciej wypozyczane
create view v_trailers as
select "name",
sum(ilosc_wypozyczen1) as ilosc_wypozyczen_z_trailers
from(
		select
		c."name" ,
		f.special_features, 
		count (f.special_features) as ilosc_wypozyczen1
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id  
		group by f.special_features,c."name"
		having f.special_features::varchar like '%Trailers%') ilosc_wypozyczonych_trailers
group by "name"		
		
create view v_bez_trailers as
select "name",
sum(ilosc_wypozyczen2) as ilosc_wypozyczen_bez_trailers
from(select
		c."name" ,
		f.special_features, 
		count (f.special_features) as ilosc_wypozyczen2
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id  
		group by f.special_features,c."name"
		having f.special_features::varchar not like '%Trailers%')ilosc_wypozyczonych_bez_trailers 
group by "name"	

create view v_commentaries as
select "name",
sum(ilosc_wypozyczen3) as ilosc_wypozyczen_z_Commentaries
from(select
		c."name" ,
		f.special_features, 
		count (f.special_features) as ilosc_wypozyczen3
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id  
		group by f.special_features,c."name"
		having f.special_features::varchar like '%Commentaries%')ilosc_wypozyczen_z_Commentaries 
group by "name"

create view v_deleted_scenes as
select "name",
sum(ilosc_wypozyczen4) as ilosc_wypozyczen_z_Deleted_Scenes
from(select
		c."name" ,
		f.special_features, 
		count (f.special_features) as ilosc_wypozyczen4
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id  
		group by f.special_features,c."name"
		having f.special_features::varchar like '%Deleted Scenes%')ilosc_wypozyczen_z_Deleted_Scenes 
group by "name"

create view v_behind_the_scenes as
select "name",
sum(ilosc_wypozyczen5) as ilosc_wypozyczen_z_Behind_the_Scenes 
from(select
		c."name" ,
		f.special_features, 
		count (f.special_features) as ilosc_wypozyczen5
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id  
		group by f.special_features,c."name"
		having f.special_features::varchar like '%Behind the Scenes%')ilosc_wypozyczen_z_Behind_the_Scenes 
group by "name"

select v_trailers.*,
ilosc_wypozyczen_z_Commentaries,
ilosc_wypozyczen_z_Deleted_Scenes,
ilosc_wypozyczen_z_Behind_the_Scenes,
v_przydod_z_danej_kategorii.liczba_wypozyczen,
srednia_dlugosc,
srednia_cena_kategorii,
przychod_z_danej_kat
from v_trailers
join v_commentaries
on v_trailers."name" =v_commentaries."name"
join v_deleted_scenes
on v_commentaries."name" =v_deleted_scenes."name"
join v_behind_the_scenes
on v_deleted_scenes."name" =v_behind_the_scenes."name"
join v_orders_quantity
on v_behind_the_scenes."name"=v_orders_quantity."name"
join v_length
on v_orders_quantity."name"=v_length."name"
join v_przydod_z_danej_kategorii
on v_length."name"=v_przydod_z_danej_kategorii."name"

