-- РАЛ статистика записей
select name_type as Тип, name_status as Статус, count(*) as Количество
from ral.t_showcase
where id_type in (10,4,5) and id_status in (6,14,1,15,19)
group by name_type, name_status
order by name_type;

-- РЕНЕ статистика записей
select status, count(*)
from register.rene.t_search_accred_person
where id_status in (6,14,1,15,19, 2)
group by status;

--РАЛ статистика ОС
select name_status as Статус,  count(*) as Количество
from ral.t_showcase
where id_type in (8,7,9,16) and id_status in (6,14,1,15,19)
group by  name_status;

--РАЛ статистика ОИ
select name_status as Статус,  count(*) as Количество
from ral.t_showcase
where id_type in (18,12,15,14) and id_status in (6,14,1,15,19)
group by  name_status;
