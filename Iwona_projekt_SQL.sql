--1. ktora kategoria jest najbardziej popularna? Co ma najwiêkszy wp³yw na jej popularnoœæ

--która kategoriajest najczesciej wypozyczana ogolem
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

--a)typ klienta
--ktora kategoria by³a najbardziej popularna w posczegolnych panstawch

--wyliczam ile ile filmow danej kategorii zostalo wypozyczone w danym panstwie
create view v_liczba_wypozyczen as
select
c4.country, 
count (c."name") over (partition by c4.country) as overall,
c."name" ,
count (c."name") over (partition by c4.country, c."name") as liczba_wypozyczen
from film f  
join film_category fc 
on fc.film_id = f.film_id 
join category c 
on c.category_id = fc.category_id
left join inventory i 
on f.film_id = i.film_id
left join rental r 
on r.inventory_id = i.inventory_id 
left join customer c2 
on c2.customer_id = r.customer_id 
join address a 
on a.address_id = c2.address_id 
join city c3
on c3.city_id = a.city_id 
left join country c4 
on c4.country_id = c3.country_id
--ktora kat jest najczesciej wybierana w danym panstwie z uwzglednieniem powtorzen
create view v_moda_w_danym_panstwie as
select 
country,
"name",
najczesciej_wybierane_kategorie_w_panstwie
from 
	(select tab3.country, t1."name",najczesciej_wybierane_kategorie_w_panstwie from
		(select country, "name", count(*) as najczesciej_wybierane_kategorie_w_panstwie
		from v_liczba_wypozyczen
		group by country, "name")t1,
	(select country, max(najczesciej_wybierane_kategorie_w_panstwie) as max_najczesciej_wybierane_kategorie_w_panstwie from
		(select country, "name", count(*) as najczesciej_wybierane_kategorie_w_panstwie
		from v_liczba_wypozyczen
		group by country, "name")t2
	group by country
	)tab3
	where t1.country = tab3.country and t1.najczesciej_wybierane_kategorie_w_panstwie = tab3.max_najczesciej_wybierane_kategorie_w_panstwie
	order by tab3.country)tab4
group by country, najczesciej_wybierane_kategorie_w_panstwie, "name"

--obliczam staosunek najczesciej wybieranych kat w danym anstwie do wszystkich wypozyczonnyech w danym panstwie

create view v_tabela_ze_stosunkiem_kategotii as
with tabela_podsumowujaca as (select distinct
	v_moda_w_danym_panstwie.country,
	overall,
	v_moda_w_danym_panstwie."name",
	najczesciej_wybierane_kategorie_w_panstwie
	from v_moda_w_danym_panstwie
	join v_liczba_wypozyczen
	on v_liczba_wypozyczen.country=v_moda_w_danym_panstwie.country)
select *,
round(((najczesciej_wybierane_kategorie_w_panstwie::numeric)/(overall::numeric)), 3) odsetek_najlepszych_categorii
from tabela_podsumowujaca

-- ladna tabelka podsumowujaca
select country,
overall,
"name",
najczesciej_wybierane_kategorie_w_panstwie,
sum(odsetek_najlepszych_categorii) over (partition by country)
from v_tabela_ze_stosunkiem_kategotii

--ktora kategoria jest najpopularniejsza wsrod wypozyczajacych malo/duzo filmow

--obliczam ile wypozyczen mial dany klient
create view v_ranking_klientow as
select r.customer_id, 
c.first_name||' '||c.last_name as "name",
count(distinct r.rental_id) liczba_wypozyczen
from rental r 
join customer c 
on c.customer_id =r.customer_id 
group by r.customer_id ,c.first_name||' '||c.last_name
order by count(distinct r.rental_id)

--obliczam srednia liczbe wypozyczen
create view v_srednia as
select *,
		(select 
		round(avg (liczba_wypozyczen)::numeric,2) as srednia
		from v_ranking_klientow)
from v_ranking_klientow

--dziele klientow na tych co wypozyczyli malo i duzo wzgledem sredniej
create view v_podzial as
select *,
case
	when liczba_wypozyczen > srednia then 'duzo'
	when liczba_wypozyczen < srednia then 'malo'
end
from v_srednia

--obliczam ile filmow poszeczegolnych kategorii wypozyczyl dany klient
create view v_najczesciej_wypozyczana_kategoria as
select
c.customer_id ,
c2."name",
count (c2."name") over (partition by c.customer_id, c2."name") as liczba_wypozyczen
from film f  
join inventory i 
on f.film_id = i.film_id
join rental r 
on r.inventory_id = i.inventory_id 
join customer c 
on c.customer_id = r.customer_id
join film_category fc 
on fc.film_id = f.film_id 
join category c2 
on c2.category_id = fc.category_id
order by c.customer_id, count (c2."name") over (partition by c.customer_id, c2."name") desc

--najczesciej wybierane kategorie przez danego klienta w uwzglednieniem mozliwosci powtorzen
create view v_moda_wsrod_klientow as
select 
customer_id,
"name", 
najczesciej_wypozyczana_kategoria
from 
	(select tab3.customer_id, tab1."name",najczesciej_wypozyczana_kategoria from
		(select customer_id, "name", count(*) as najczesciej_wypozyczana_kategoria
		from v_najczesciej_wypozyczana_kategoria
		group by customer_id, "name")tab1,
	(select customer_id, max(najczesciej_wypozyczana_kategoria) as max_najczesciej_wypozyczana_kategoria from
		(select customer_id, "name", count(*) as najczesciej_wypozyczana_kategoria
		from v_najczesciej_wypozyczana_kategoria
		group by customer_id, "name")tab2
	group by customer_id
	)tab3
	where tab1.customer_id = tab3.customer_id and tab1.najczesciej_wypozyczana_kategoria = tab3.max_najczesciej_wypozyczana_kategoria
	order by tab3.customer_id)tab4
group by customer_id, najczesciej_wypozyczana_kategoria, "name"

--przedstawiam ktora kategoria filmow byla najpopularniejsza wsrod klientow kategorii molo i duzo
select 
"case",
mode() within group (order by v_moda_wsrod_klientow."name") as najpopularniejsza_kategoria
from v_podzial
join v_moda_wsrod_klientow
on v_podzial.customer_id=v_moda_wsrod_klientow.customer_id
group by "case"

--ladna babelka podsumowujaca
select 
v_podzial.customer_id,
v_moda_wsrod_klientow."name",
"case",
najczesciej_wypozyczana_kategoria
from v_podzial
join v_moda_wsrod_klientow
on v_podzial.customer_id=v_moda_wsrod_klientow.customer_id
order by v_podzial.customer_id

--b)film
--podzial ze wzgledu na cene
select distinct *
from(select
		c."name" ,
		round(avg(f.rental_rate) over (partition by c.category_id)::numeric,2) as srednia_cela_kategorii
		from film f 
		join film_category fc 
		on f.film_id = fc.film_id 
		join category c 
		on fc.category_id = c.category_id)rental_rate
order by srednia_cela_kategorii

--podzial ze wzgledu na dlugosc
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

--która kategoria filmow przynosi najwieksze korzysci finansiwe
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
ilosc_wypozyczen_bez_trailers,
ilosc_wypozyczen_z_Commentaries,
ilosc_wypozyczen_z_Deleted_Scenes,
ilosc_wypozyczen_z_Behind_the_Scenes
from v_trailers
join v_bez_trailers
on v_trailers."name" =v_bez_trailers."name"
join v_commentaries
on v_bez_trailers."name" =v_commentaries."name"
join v_deleted_scenes
on v_commentaries."name" =v_deleted_scenes."name"
join v_behind_the_scenes
on v_deleted_scenes."name" =v_behind_the_scenes."name"

--c) aktor
--w filmach jakiej kategorii gra najczesciej dany aktor

create view v_w_jakich_kat_gra_aktor as
select 
a.first_name ||' '||a.last_name as aktor,
c."name" as kategoria
from film f 
join film_actor fa 
on f.film_id =fa.film_id 
join actor a 
on fa.actor_id =a.actor_id 
join film_category fc 
on f.film_id = fc.film_id 
join category c 
on fc.category_id = c.category_id

create view v_katrgoria_w_ktorej_aktor as
select 
aktor,
kategoria, 
ilosc_wystapien_w_kat
from 
	(select tab3.aktor, tab1.kategoria,ilosc_wystapien_w_kat from
		(select aktor, kategoria, count(kategoria) as ilosc_wystapien_w_kat
		from v_w_jakich_kat_gra_aktor
		group by aktor, kategoria)tab1,
	(select aktor, max(ilosc_wystapien_w_kat) as max_ilosc_wystapien_w_kat from
		(select aktor, kategoria, count(kategoria) as ilosc_wystapien_w_kat
		from v_w_jakich_kat_gra_aktor
		group by aktor, kategoria)tab2
	group by aktor
	)tab3
	where tab1.aktor = tab3.aktor and tab1.ilosc_wystapien_w_kat = tab3.max_ilosc_wystapien_w_kat
	order by tab3.aktor)tab4
group by aktor, ilosc_wystapien_w_kat, kategoria
order by aktor

--kategorie z jakim aktorem sa najczesciej wypozyczane/ jaki aktor gra najczescie w filmach z danej kategorii
create view v_jaki_aktor_gra_w_kat as
select 
c."name" as kategoria,
a.first_name ||' '||a.last_name as aktor
from film f 
join film_actor fa 
on f.film_id =fa.film_id 
join actor a 
on fa.actor_id =a.actor_id 
join film_category fc 
on f.film_id = fc.film_id 
join category c 
on fc.category_id = c.category_id

create view v_ktory_aktor_w_kategoriib as
select 
kategoria,
aktor,
najpopularnieszy_aktor_w_kat
from 
	(select tab3.kategoria, tab1.aktor,najpopularnieszy_aktor_w_kat from
		(select kategoria, aktor,count(aktor) as najpopularnieszy_aktor_w_kat
		from v_jaki_aktor_gra_w_kat
		group by kategoria, aktor)tab1,
	(select kategoria, max(najpopularnieszy_aktor_w_kat) as max_najpopularnieszy_aktor_w_kat from
		(select kategoria, aktor,count(aktor) as najpopularnieszy_aktor_w_kat
		from v_jaki_aktor_gra_w_kat
		group by kategoria, aktor)tab2
	group by kategoria
	)tab3
	where tab1.kategoria = tab3.kategoria and tab1.najpopularnieszy_aktor_w_kat = tab3.max_najpopularnieszy_aktor_w_kat
	order by tab3.kategoria)tab4
group by kategoria,aktor, najpopularnieszy_aktor_w_kat
order by aktor
-- wyeliminowuje mozliwosc z ktorej aktor po ktorym nastepuje join nie jest pierwszy w danej kategorii
create view v_tab_1 as
select v_katrgoria_w_ktorej_aktor.aktor, v_katrgoria_w_ktorej_aktor.kategoria,
max(ilosc_wystapien_w_kat)
from v_ktory_aktor_w_kategoriib
join v_katrgoria_w_ktorej_aktor
on v_ktory_aktor_w_kategoriib.kategoria = v_katrgoria_w_ktorej_aktor.kategoria
group by v_katrgoria_w_ktorej_aktor.aktor, v_katrgoria_w_ktorej_aktor.kategoria

create view v_tab_2 as
select v_ktory_aktor_w_kategoriib.aktor, v_ktory_aktor_w_kategoriib.kategoria,
max(najpopularnieszy_aktor_w_kat)
from v_ktory_aktor_w_kategoriib
join v_katrgoria_w_ktorej_aktor
on v_ktory_aktor_w_kategoriib.kategoria = v_katrgoria_w_ktorej_aktor.kategoria
group by v_ktory_aktor_w_kategoriib.aktor, v_ktory_aktor_w_kategoriib.kategoria

select * from v_tab_2
join v_tab_1 on v_tab_2.aktor=v_tab_1.aktor

--d)kategoria
-- jaka kategoria byla najczesciej wypozyczana w poszczegolnych miesiacach

create view v_data_wypozyczenia as
select
to_char(r.rental_date ,'yyyy-mm') as data_wypozyczenia,
c."name"
from film f  
join film_category fc 
on fc.film_id = f.film_id 
join category c 
on c.category_id = fc.category_id
join inventory i 
on f.film_id = i.film_id
join rental r 
on r.inventory_id = i.inventory_id

create view v_najczesciej_wybierana_kat_w_miesiacu as
select 
data_wypozyczenia,
"name",
ilosc_wypozyczen_w_mieciacu
from 
	(select tab3.data_wypozyczenia, t1."name",ilosc_wypozyczen_w_mieciacu from
		(select data_wypozyczenia, "name", count("name") as ilosc_wypozyczen_w_mieciacu
		from v_data_wypozyczenia
		group by data_wypozyczenia, "name")t1,
	(select data_wypozyczenia, max(ilosc_wypozyczen_w_mieciacu) as max_ilosc_wypozyczen_w_mieciacu from
		(select data_wypozyczenia, "name", count("name") as ilosc_wypozyczen_w_mieciacu
		from v_data_wypozyczenia
		group by data_wypozyczenia, "name"
		order by data_wypozyczenia)t2
	group by data_wypozyczenia
	)tab3
	where t1.data_wypozyczenia = tab3.data_wypozyczenia and t1.ilosc_wypozyczen_w_mieciacu = tab3.max_ilosc_wypozyczen_w_mieciacu
	order by tab3.data_wypozyczenia)tab4
group by data_wypozyczenia, ilosc_wypozyczen_w_mieciacu, "name"

-- ktora kategoria przyniosla najwiecej zyskow w poszczegolnych miesiacach (czy pokrywa sie z najczesciej wypozyczana kategoria)

create view v_kwota as
select
to_char(r.rental_date ,'yyyy-mm') as data_wypozyczenia,
c."name",
f.rental_rate
from film f  
join film_category fc 
on fc.film_id = f.film_id 
join category c 
on c.category_id = fc.category_id
join inventory i 
on f.film_id = i.film_id
join rental r 
on r.inventory_id = i.inventory_id

select 
data_wypozyczenia,
"name",
kwota_wypozyczen_w_mieciacu
from 
	(select tab3.data_wypozyczenia, t1."name",kwota_wypozyczen_w_mieciacu from
		(select data_wypozyczenia, "name", sum(rental_rate) as kwota_wypozyczen_w_mieciacu
		from v_kwota
		group by data_wypozyczenia, "name")t1,
	(select data_wypozyczenia, max(kwota_wypozyczen_w_mieciacu) as max_kwota_wypozyczen_w_mieciacu from
		(select data_wypozyczenia, "name", sum(rental_rate) as kwota_wypozyczen_w_mieciacu
		from v_kwota
		group by data_wypozyczenia, "name")t2
	group by data_wypozyczenia
	)tab3
	where t1.data_wypozyczenia = tab3.data_wypozyczenia and t1.kwota_wypozyczen_w_mieciacu = tab3.max_kwota_wypozyczen_w_mieciacu
	order by tab3.data_wypozyczenia)tab4
group by data_wypozyczenia, kwota_wypozyczen_w_mieciacu, "name"

