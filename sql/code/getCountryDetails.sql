/*
 This function displays details of selected country
    Input:
        country as a string ex. 'China'
    Output:
        country,
        most_popular_category (in selected country)
        category_orders_quantity (of most popular category)
        avg_category_movies_length (of most popular category but not divided by specified country)
        most_popular_movie (of specified  country)
        movie_orders_quantity (of most popular movie)
 */

create function getCountryDetails(country_varchar character varying)

-- return table with all output columns (number of columns needs to match wrapping query output - last bottom query)
    returns TABLE
            (
                country                    character varying,
                most_popular_category      character varying,
                category_orders_quantity   bigint,
                avg_category_movies_length numeric,
                most_popular_movie         character varying,
                movie_orders_quantity      bigint
            )
    language plpgsql
as
$$
-- leftover from different approach, just in case you want to check it out - it does not affect query rn
DECLARE
    var_category varchar;
BEGIN
    return query
        -- select country_varchar into var_category;  -- leftover for declare

-- query to define most popular category and quantity
        with x as (select zz.country, name, amount
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
                                 -- $1 is an input value
                            where cou.country = $1
                            group by cat.name, cou.country
                            order by 2, 4
                        ) zz
                   where zz.rank_num = 1
                   order by 1),

-- query to define most popular movie and quantity
             y as (select zz.country, title, amount
                   from (
                            select cou.country,
                                   f.title,
                                   count(*)                                                      amount,
                                   count(distinct r.rental_id)                                   amount1,
                                   RANK() OVER (partition by cou.country order by count(*) desc) rank_num
                            from rental r
                                     inner join customer cu
                                                on r.customer_id = cu.customer_id
                                     inner join inventory i
                                                on i.inventory_id = r.inventory_id
                                     inner join film f
                                                on f.film_id = i.film_id
                                     inner join address a
                                                on cu.address_id = a.address_id
                                     inner join city c
                                                on c.city_id = a.city_id
                                     inner join country cou
                                                on c.country_id = cou.country_id
                                 -- $1 is an input value
                            where cou.country = $1
                            group by cou.country, f.title
                            order by 1, 4
                        ) zz
                   where zz.rank_num = 1
                   order by 1),

-- leftover for different approach not used
             variable as (select name from x),

-- query to define avg movie length of most popular category
             z as (
                 select c.name, round(avg(f.length)) as avg_length
                 from film f
                          inner join film_category fc on f.film_id = fc.film_id
                          inner join category c on c.category_id = fc.category_id
-- select pick up most popular category to filter out data
                 where c.name = (select name from x)
                 group by c.name
             )

-- this query wraps everything together
        select x.country, x.name, x.amount, z.avg_length, y.title, y.amount
        from x
                 inner join y on y.country = x.country
                 inner join z on z.name = x.name;
end;
$$;

/*
 to run function enter valid country and run select
 */
--select * from getCountryDetails('China');