--Новые правила СРД
select distinct --sa1.id_declaration,
       t2.number                             as "Номер ДС",
       to_char(sa1.begin_date, 'YYYY-mm-dd') as "Дата создания черновика ДС",
       r1.org_inn                            as "ИНН создателя",
       --sa1.id_status,
       --t2.id_declaration,
       t2.d                                  as "Дата публикации ДС",
       t2.org_inn                            as "ИНН заявителя"
       --t2.id_status
from rds.t_revinfo r1
         left join rds.t_decl_change_status_aud sa1 on r1.rev = sa1.rev
         left join rds.t_search_declaration on sa1.id_declaration = t_search_declaration.id
         join
     (select sa2.id_declaration, number, to_char(sa2.begin_date, 'YYYY-mm-dd') d, r2.org_inn, sa2.id_status
      from rds.t_revinfo r2
               left join rds.t_decl_change_status_aud sa2 on r2.rev = sa2.rev
               left join rds.t_search_declaration on sa2.id_declaration = t_search_declaration.id
      where to_char(sa2.begin_date, 'YYYY-mm-dd') >= '2020-12-19'
        and r2.org_inn is not null
        and t_search_declaration.number like '%РА01%'
        and sa2.id_status = 6) t2 on t2.id_declaration = sa1.id_declaration
         left join rds.t_search_declaration dec on sa1.id_declaration = dec.id
where to_char(sa1.begin_date, 'YYYY-mm-dd') >= '2020-12-19'
  and
  --and number is not null
    r1.org_inn is not null
  and dec.number like '%РА01%'
  and sa1.id_status = 20
  and r1.org_inn != t2.org_inn;

--Количество ДС в СРД, РДС, общеее
select 'Всего' as name, decl_reg_date, count(*)
from rds.t_search_declaration c
where c.decl_reg_date in ('2020-02-04', '2021-02-04')
and id_status !=20
group by  decl_reg_date
union
select 'СРД' as name, decl_reg_date, count(*)
from rds.t_search_declaration c
where c.decl_reg_date in ('2020-02-04', '2021-02-04')
and number like '%РА01%'
and id_status !=20
group by  decl_reg_date
union
select 'РДС' as name, decl_reg_date, count(*)
from rds.t_search_declaration c
where c.decl_reg_date in ('2020-02-04', '2021-02-04')
  and number not like '%РА01%'
and id_status !=20
group by  decl_reg_date



select 'Всего' as name, c.decl_reg_date, count(*)
from rds.t_search_declaration c
where c.decl_reg_date between '2021-01-01' and '2021-01-27'
and id_status !=20
group by c.decl_reg_date


--and number like '%РА01%'
--group by  decl_reg_date


select 'Всего' as name,  count(*)
from rds.t_search_declaration c
where c.decl_reg_date between '2020-01-01' and '2020-01-27'
and id_status !=20

select distinct --sa1.id_declaration,
       t2.number                             as "Номер ДС",
       to_char(sa1.begin_date, 'YYYY-mm-dd') as "Дата создания черновика ДС",
       r1.org_inn                            as "ИНН создателя",
       --sa1.id_status,
       --t2.id_declaration,
       t2.d                                  as "Дата публикации ДС",
       t2.org_inn                            as "ИНН заявителя"
       --t2.id_status
from rds.t_revinfo r1
         left join rds.t_decl_change_status_aud sa1 on r1.rev = sa1.rev
         left join rds.t_search_declaration on sa1.id_declaration = t_search_declaration.id
         join
     (select sa2.id_declaration, number, to_char(sa2.begin_date, 'YYYY-mm-dd') d, r2.org_inn, sa2.id_status
      from rds.t_revinfo r2
               left join rds.t_decl_change_status_aud sa2 on r2.rev = sa2.rev
               left join rds.t_search_declaration on sa2.id_declaration = t_search_declaration.id
      where id_declaration = 14273178
        and r2.org_inn is not null
        and t_search_declaration.number like '%РА01%'
        and sa2.id_status = 6) t2 on t2.id_declaration = sa1.id_declaration
         left join rds.t_search_declaration dec on sa1.id_declaration = dec.id
where t2.id_declaration = 14273178
  and
  --and number is not null
    r1.org_inn is not null
  and dec.number like '%РА01%'
  and sa1.id_status = 20
  and r1.org_inn != t2.org_inn;

select sa2.id_declaration, number, to_char(sa2.begin_date, 'YYYY-mm-dd') d, r2.org_inn, sa2.id_status
      from rds.t_revinfo r2
               left join rds.t_decl_change_status_aud sa2 on r2.rev = sa2.rev
               left join rds.t_search_declaration on sa2.id_declaration = t_search_declaration.id
      where id_declaration = 14273178
        and r2.org_inn is not null
        and t_search_declaration.number like '%РА01%'
        and sa2.id_status = 6


select c.id,
       c.num as "Номер СС",
        case when id_status = 1 then 'Архивный'
            when id_status = 3 then 'Возобновлен'
                when id_status = 6 then 'Действует'
                    when id_status = 14 then 'Прекращен'
                        when id_status = 15 then 'Приостановлен'
                            when id_status = 16 then 'Продлен' end as "Статус",
       c.cert_reg_date as "Дата СС",
       string_agg(tech_reg.s_num, '; ') as "Технические регламенты",
       co.attestat_reg_number as "Номер ОС",
       co.full_name as "Наименование ОС",
       p.surname || ' ' || p.first_name || ' '|| p.patronymic as "Лицо, подписавшее СС"
from rss.t_certificate c
    left join rss.t_person p on c.id_signer = p.id
    left join rss.t_cert_owner cow on c.id = cow.id_certificate
left join rss.t_cert_organ co on cow.id_cert_organ = co.id
    left join rss.t_technical_reglament tr on c.id = tr.id_certificate
    left join rss.t_cert_expert ex on p.id = ex.id_person
    left join rss.t_search_certificate cs on c.id = cs.id
  left join (select *
              from public.dblink('host=10.250.74.20 user=postgres password=Manager1 dbname=postgres',
              $$
              select techreg_id, s_num, s_name
              from nsi.V_TECHREG;
              $$
              ) t(techreg_id int, s_num varchar, s_name varchar))tech_reg on tr.id_tech_reg = tech_reg.techreg_id
--where c.id = 2836492
where cs.id_status not in (20,1, 14)
group by c.id, c.num, c.cert_reg_date, co.attestat_reg_number, co.full_name, p.surname || ' ' || p.first_name || ' '|| p.patronymic, id_status;

select distinct  id_status
from rss.t_search_certificate