/* the_most_famous_actor_sport*/

create view v_analiza_aktor1 as
select f.film_id , a.first_name , a.last_name , c."name" , a.first_name ||' '|| a.last_name as imie_nazwisko, f.title 
from film f 
join film_actor fa 
on fa.film_id = f.film_id 
join actor a 
on a.actor_id = fa.actor_id 
join film_category fc 
on fc.film_id = f.film_id 
join category c 
on c.category_id = fc.category_id 
where name = 'Sports'

create view v_analiza_aktor_wyliczenie3 as
select imie_nazwisko, count(imie_nazwisko) over (partition by imie_nazwisko) as ile_razy_wystepowal, title, name as kategoria
from v_analiza_aktor1
order by imie_nazwisko, count(imie_nazwisko) over (partition by imie_nazwisko) desc

select distinct dense_rank() over (order by ile_razy_wystepowal desc) as ranking, ile_razy_wystepowal, imie_nazwisko, title as tytul, kategoria
from v_analiza_aktor_wyliczenie3
order by dense_rank() over (order by ile_razy_wystepowal desc) 