---крок 2---
select *
from cohort_users_raw
limit 10

---крок 3---
select *
from cohort_events_raw
limit 10

---крок 4---
----очищаємо signup_datetime
with rts as (
----прибираємо зайві пробіли, хвилини та секунди, замінюємо деліметри '/', '.' на '-'
    select *,
           replace(replace(trim(split_part(signup_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date
    from cohort_users_raw
),
case_tb AS (
    select
        *,
        case
            --змінюємо формат, щоб дата була дд-мм-рррр
            when length(split_part(new_date, '-', 3)) = 4 then to_char(to_date(new_date, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date, '-', 3)) = 2 then to_char(to_date(new_date, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date,
        case
	        --перетворюємо дату на таймстемп
            when length(split_part(new_date, '-', 3)) = 4 then to_date(new_date, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date, '-', 3)) = 2 then to_date(new_date, 'DD-MM-YY')::timestamp
            else NULL
        end as signup_time
    from rts
)
select *
from case_tb;

---крок 5---
----очищаємо event_datetime
with rts2 as (
----прибираємо зайві пробіли, хвилини та секунди, замінюємо деліметри '/', '.' на '-'
    select *,
           replace(replace(trim(split_part(event_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date2
    from cohort_events_raw
),
case_tb2 AS (
    select
        *,
        case
            --змінюємо формат, щоб дата була дд-мм-рррр
            when length(split_part(new_date2, '-', 3)) = 4 then to_char(to_date(new_date2, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date2, '-', 3)) = 2 then to_char(to_date(new_date2, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date2,
        case
	        --перетворюємо дату на таймстемп
            when length(split_part(new_date2, '-', 3)) = 4 then to_date(new_date2, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date2, '-', 3)) = 2 then to_date(new_date2, 'DD-MM-YY')::timestamp
            else NULL
        end as event_timestamp
    from rts2
)
select *
from case_tb2;

---крок 6---
----з'єднуємо 2 попередні СТЕ
with rts as (
    select *,
           replace(replace(trim(split_part(signup_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date
    from cohort_users_raw u
),
case_tb AS (
    select
        *,
        case
            when length(split_part(new_date, '-', 3)) = 4 then to_char(to_date(new_date, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date, '-', 3)) = 2 then to_char(to_date(new_date, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date,
        case
            when length(split_part(new_date, '-', 3)) = 4 then to_date(new_date, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date, '-', 3)) = 2 then to_date(new_date, 'DD-MM-YY')::timestamp
            else NULL
        end as signup_time
    from rts
),
rts2 as (
    select *,
           replace(replace(trim(split_part(event_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date2
    from cohort_events_raw
),
case_tb2 AS (
    select
        *,
        case
            when length(split_part(new_date2, '-', 3)) = 4 then to_char(to_date(new_date2, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date2, '-', 3)) = 2 then to_char(to_date(new_date2, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date2,
        case
            when length(split_part(new_date2, '-', 3)) = 4 then to_date(new_date2, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date2, '-', 3)) = 2 then to_date(new_date2, 'DD-MM-YY')::timestamp
            else NULL
        end as event_timestamp
    from rts2
)
select *
from case_tb u
left join case_tb2 e
on u.user_id = e.user_id

---крок 6---додаємо умови
with rts as (
    select *,
           replace(replace(trim(split_part(signup_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date
    from cohort_users_raw u
),
case_tb AS (
    select
        *,
        case
            when length(split_part(new_date, '-', 3)) = 4 then to_char(to_date(new_date, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date, '-', 3)) = 2 then to_char(to_date(new_date, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date,
        case
            when length(split_part(new_date, '-', 3)) = 4 then to_date(new_date, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date, '-', 3)) = 2 then to_date(new_date, 'DD-MM-YY')::timestamp
            else NULL
        end as signup_time
    from rts
),
rts2 as (
    select *,
           replace(replace(trim(split_part(event_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date2
    from cohort_events_raw
),
case_tb2 AS (
    select
        *,
        case
            when length(split_part(new_date2, '-', 3)) = 4 then to_char(to_date(new_date2, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date2, '-', 3)) = 2 then to_char(to_date(new_date2, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date2,
        case
            when length(split_part(new_date2, '-', 3)) = 4 then to_date(new_date2, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date2, '-', 3)) = 2 then to_date(new_date2, 'DD-MM-YY')::timestamp
            else NULL
        end as event_timestamp
    from rts2
)
select u.user_id,
----перетворюємо дати подій та дати реєстрацій у формат рік-місяць
	   to_char(u.signup_time, 'YYYY-MM') as cohort_month,
	   to_char(e.event_timestamp, 'YYYY-MM') as event_month,
	   e.event_type,
----округлюємо дати до місяця, рахуємо роки в місяцях, шукаємо різницю між місяцями подій і реєстрацією
	   extract(year from age(date_trunc('month', e.event_timestamp),
                          date_trunc('month', u.signup_time))) * 12
    +
       extract(month from age(date_trunc('month', e.event_timestamp),
                           date_trunc('month', u.signup_time))) as month_offset
from case_tb u
left join case_tb2 e
on u.user_id = e.user_id
where u.signup_time is not null
      and e.event_timestamp is not null
      AND e.event_type is not null
      AND e.event_type <> 'test_event';


---крок 7---змінюємо фінальний селект і додаємо умову по періоду активності
with rts as (
    select *,
           replace(replace(trim(split_part(signup_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date
    from cohort_users_raw u
),
case_tb AS (
    select
        *,
        case
            when length(split_part(new_date, '-', 3)) = 4 then to_char(to_date(new_date, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date, '-', 3)) = 2 then to_char(to_date(new_date, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date,
        case
            when length(split_part(new_date, '-', 3)) = 4 then to_date(new_date, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date, '-', 3)) = 2 then to_date(new_date, 'DD-MM-YY')::timestamp
            else NULL
        end as signup_time
    from rts
),
rts2 as (
    select *,
           replace(replace(trim(split_part(event_datetime, ' ', 1)), '/', '-'), '.', '-') as new_date2
    from cohort_events_raw
),
case_tb2 AS (
    select
        *,
        case
            when length(split_part(new_date2, '-', 3)) = 4 then to_char(to_date(new_date2, 'DD-MM-YYYY'), 'DD-MM-YYYY')
            when length(split_part(new_date2, '-', 3)) = 2 then to_char(to_date(new_date2, 'DD-MM-YY'), 'DD-MM-YYYY')
            else NULL
        end as clean_date2,
        case
            when length(split_part(new_date2, '-', 3)) = 4 then to_date(new_date2, 'DD-MM-YYYY')::timestamp
            when length(split_part(new_date2, '-', 3)) = 2 then to_date(new_date2, 'DD-MM-YY')::timestamp
            else NULL
        end as event_timestamp
    from rts2
)
select u.promo_signup_flag, 
	   date_trunc('month', u.signup_time)::date as cohort_month,
	   extract(year from age(date_trunc('month', e.event_timestamp),
                         date_trunc('month', u.signup_time))) * 12
    +
       extract(month from age(date_trunc('month', e.event_timestamp),
                          date_trunc('month', u.signup_time))) as month_offset,
       count(distinct u.user_id) as users_total
from case_tb u
left join case_tb2 e
on u.user_id = e.user_id
where u.signup_time is not null
      and e.event_timestamp is not null
      and e.event_type is not null
      and e.event_type <> 'test_event'
----округлюємо дати до першого числа місяця і залишаємо активність з січня по червень
	  and date_trunc('month', e.event_timestamp) between date '2025-01-01' and date '2025-06-01'
group by u.promo_signup_flag,
         cohort_month,
         month_offset
order by u.promo_signup_flag,
         cohort_month,
         month_offset;

