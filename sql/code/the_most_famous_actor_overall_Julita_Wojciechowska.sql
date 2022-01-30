/* the_most_famous_actor_overall*/

create view najpopul_aktor_ogolem as
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

create view rank_najpopular_aktor as 
select imie_nazwisko, title, count(imie_nazwisko) over (partition by imie_nazwisko) as ile_razy_wystepowal, name
from najpopul_aktor_ogolem 
order by count(imie_nazwisko) over (partition by imie_nazwisko) desc

select dense_rank() over (order by ile_razy_wystepowal desc) as ranking, ile_razy_wystepowal, imie_nazwisko, title as tytul, name as kategoria
from rank_najpopular_aktor 

