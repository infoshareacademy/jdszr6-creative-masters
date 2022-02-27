--1. ktora kategoria jest najbardziej popularna? Co ma najwiêkszy wp³yw na jej popularnoœæ

create view v_trailers as
select
c."name" as category_name, 
count (f.special_features) as orders_quantity
from film f  
join film_category fc 
on fc.film_id = f.film_id 
join category c 
on c.category_id = fc.category_id
join inventory i 
on f.film_id = i.film_id
join rental r 
on r.inventory_id = i.inventory_id  
group by f.special_features, c."name"
having f.special_features::varchar like '%Trailers%'

create view v_commentaries as
select
c."name" as category_name, 
count (f.special_features) as orders_quantity
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
having f.special_features::varchar like '%Commentaries%'

create view v_deleted_scenes as
select
c."name" as category_name,
count (f.special_features) as orders_quantity
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
having f.special_features::varchar like '%Deleted Scenes%'

create view v_behind_the_scenes as
select
c."name" as category_name,
count (f.special_features) as orders_quantity
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
having f.special_features::varchar like '%Behind the Scenes%'

--tabela categories

select distinct 
rental_rate."name" as category_name,
avg_price,
orders_quantity,
avg_price*orders_quantity as income,
avg_length,
trailers,
Commentaries,
Deleted_Scenes,
Behind_the_Scenes
from(select
		c."name" ,
		round(avg(f.rental_rate) over (partition by c.category_id)::numeric,2) as avg_price,
		round(avg(f.length) over (partition by c.category_id)::numeric,2) as avg_length
		from film f 
		join film_category fc 
		on f.film_id = fc.film_id 
		join category c 
		on fc.category_id = c.category_id)rental_rate
join(select
		c."name" ,
		count (c."name") as orders_quantity
		from film f  
		join film_category fc 
		on fc.film_id = f.film_id 
		join category c 
		on c.category_id = fc.category_id
		join inventory i 
		on f.film_id = i.film_id
		join rental r 
		on r.inventory_id = i.inventory_id 
		group by c."name") orders_quantity
on orders_quantity."name"=rental_rate."name"
join(select v_trailers.category_name,
		sum(orders_quantity) as trailers,
		Commentaries,
		Deleted_Scenes,
		Behind_the_Scenes
		from v_trailers
		join (select category_name, sum(orders_quantity) as Commentaries from v_commentaries group by category_name) com
		on v_trailers.category_name=com.category_name
		join (select category_name, sum(orders_quantity) as Behind_the_Scenes from v_behind_the_scenes group by category_name) bts
		on com.category_name=bts.category_name
		join (select category_name,sum(orders_quantity) as Deleted_Scenes from v_deleted_scenes group by category_name) ds
		on bts.category_name=ds.category_name
		group by v_trailers.category_name, Commentaries, Deleted_Scenes, Behind_the_Scenes)specials
on specials.category_name=rental_rate."name"

--tabela specials

create temp table specials as
select
	(select sum(orders_quantity) as "Action" from v_trailers where category_name='Action'),
	(select sum(orders_quantity) as Animation from v_trailers where category_name='Animation'),
	(select sum(orders_quantity) as Children from v_trailers where category_name='Children'),
	(select sum(orders_quantity) as Classics from v_trailers where category_name='Classics'),
	(select sum(orders_quantity) as Comedy from v_trailers where category_name='Comedy'),
	(select sum(orders_quantity) as Documentary from v_trailers where category_name='Documentary'),
	(select sum(orders_quantity) as Drama from v_trailers where category_name='Drama'),
	(select sum(orders_quantity) as "Family" from v_trailers where category_name='Family'),
	(select sum(orders_quantity) as "Foreign" from v_trailers where category_name='Foreign'),
	(select sum(orders_quantity) as Games from v_trailers where category_name='Games'),
	(select sum(orders_quantity) as Horror from v_trailers where category_name='Horror'),
	(select sum(orders_quantity) as Music from v_trailers where category_name='Music'),
	(select sum(orders_quantity) as "New" from v_trailers where category_name='New'),
	(select sum(orders_quantity) as "Sci-Fi" from v_trailers where category_name='Sci-Fi'),
	(select sum(orders_quantity) as Sports from v_trailers where category_name='Sports'),
	(select sum(orders_quantity) as Travel from v_trailers where category_name='Travel'),
sum(orders_quantity) as sum_specials from v_trailers
union all
select
	(select sum(orders_quantity) as "Action" from v_commentaries where category_name='Action'),
	(select sum(orders_quantity) as Animation from v_commentaries where category_name='Animation'),
	(select sum(orders_quantity) as Children from v_commentaries where category_name='Children'),
	(select sum(orders_quantity) as Classics from v_commentaries where category_name='Classics'),
	(select sum(orders_quantity) as Comedy from v_commentaries where category_name='Comedy'),
	(select sum(orders_quantity) as Documentary from v_commentaries where category_name='Documentary'),
	(select sum(orders_quantity) as Drama from v_commentaries where category_name='Drama'),
	(select sum(orders_quantity) as "Family" from v_commentaries where category_name='Family'),
	(select sum(orders_quantity) as "Foreign" from v_commentaries where category_name='Foreign'),
	(select sum(orders_quantity) as Games from v_commentaries where category_name='Games'),
	(select sum(orders_quantity) as Horror from v_commentaries where category_name='Horror'),
	(select sum(orders_quantity) as Music from v_commentaries where category_name='Music'),
	(select sum(orders_quantity) as "New" from v_commentaries where category_name='New'),
	(select sum(orders_quantity) as "Sci-Fi" from v_commentaries where category_name='Sci-Fi'),
	(select sum(orders_quantity) as Sports from v_commentaries where category_name='Sports'),
	(select sum(orders_quantity) as Travel from v_commentaries where category_name='Travel'),
sum(orders_quantity) as sum_specials from v_commentaries
union all
select
	(select sum(orders_quantity) as "Action" from v_behind_the_scenes where category_name='Action'),
	(select sum(orders_quantity) as Animation from v_behind_the_scenes where category_name='Animation'),
	(select sum(orders_quantity) as Children from v_behind_the_scenes where category_name='Children'),
	(select sum(orders_quantity) as Classics from v_behind_the_scenes where category_name='Classics'),
	(select sum(orders_quantity) as Comedy from v_behind_the_scenes where category_name='Comedy'),
	(select sum(orders_quantity) as Documentary from v_behind_the_scenes where category_name='Documentary'),
	(select sum(orders_quantity) as Drama from v_behind_the_scenes where category_name='Drama'),
	(select sum(orders_quantity) as "Family" from v_behind_the_scenes where category_name='Family'),
	(select sum(orders_quantity) as "Foreign" from v_behind_the_scenes where category_name='Foreign'),
	(select sum(orders_quantity) as Games from v_behind_the_scenes where category_name='Games'),
	(select sum(orders_quantity) as Horror from v_behind_the_scenes where category_name='Horror'),
	(select sum(orders_quantity) as Music from v_behind_the_scenes where category_name='Music'),
	(select sum(orders_quantity) as "New" from v_behind_the_scenes where category_name='New'),
	(select sum(orders_quantity) as "Sci-Fi" from v_behind_the_scenes where category_name='Sci-Fi'),
	(select sum(orders_quantity) as Sports from v_behind_the_scenes where category_name='Sports'),
	(select sum(orders_quantity) as Travel from v_behind_the_scenes where category_name='Travel'),
sum(orders_quantity) as sum_specials from v_behind_the_scenes
union all
select
	(select sum(orders_quantity) as "Action" from v_deleted_scenes where category_name='Action'),
	(select sum(orders_quantity) as Animation from v_deleted_scenes where category_name='Animation'),
	(select sum(orders_quantity) as Children from v_deleted_scenes where category_name='Children'),
	(select sum(orders_quantity) as Classics from v_deleted_scenes where category_name='Classics'),
	(select sum(orders_quantity) as Comedy from v_deleted_scenes where category_name='Comedy'),
	(select sum(orders_quantity) as Documentary from v_deleted_scenes where category_name='Documentary'),
	(select sum(orders_quantity) as Drama from v_deleted_scenes where category_name='Drama'),
	(select sum(orders_quantity) as "Family" from v_deleted_scenes where category_name='Family'),
	(select sum(orders_quantity) as "Foreign" from v_deleted_scenes where category_name='Foreign'),
	(select sum(orders_quantity) as Games from v_deleted_scenes where category_name='Games'),
	(select sum(orders_quantity) as Horror from v_deleted_scenes where category_name='Horror'),
	(select sum(orders_quantity) as Music from v_deleted_scenes where category_name='Music'),
	(select sum(orders_quantity) as "New" from v_deleted_scenes where category_name='New'),
	(select sum(orders_quantity) as "Sci-Fi" from v_deleted_scenes where category_name='Sci-Fi'),
	(select sum(orders_quantity) as Sports from v_deleted_scenes where category_name='Sports'),
	(select sum(orders_quantity) as Travel from v_deleted_scenes where category_name='Travel'),
sum(orders_quantity) as sum_specials from v_deleted_scenes;
alter table specials add column
special_name varchar; 
update specials
set special_name = 'Trailers'
where "Action" = 611;
update specials
set special_name = 'Commentaries'
where "Action" = 510;
update specials
set special_name = 'Behind_the_Scenes'
where "Action" = 704;
update specials
set special_name = 'Deleted_Scenes'
where "Action" = 555;
select * from specials

