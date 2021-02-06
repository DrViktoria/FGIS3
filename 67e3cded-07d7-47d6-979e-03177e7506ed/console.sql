select sa2.id_declaration, number, to_char(sa2.begin_date, 'YYYY-mm-dd') d, r2.org_inn, r2.org_ogrn,  sa2.id_status
      from rds.t_revinfo r2
               left join rds.t_decl_change_status_aud sa2 on r2.rev = sa2.rev
               left join rds.t_search_declaration on sa2.id_declaration = t_search_declaration.id
      where id_declaration = 14273178
        and r2.org_inn is not null
        and t_search_declaration.number like '%РА01%'
        and sa2.id_status = 6;


select t_expert.id,
       concat(surname, ' ', first_name, ' ', patronimyc) as "ФИО эксперта",
       t_expert.reg_number                               as "№ Эксперта",
       t_expert_organization.full_name                   as "Эксп.орг",
       t_expert_organization.reg_number                  as "№ Эксп. орг",
       begin_date,
       end_date,
       case when is_fired is true then 'Да' else 'Нет' end as "Уволен"
from reo_rea.t_expert
         left join reo_rea.t_person on t_expert.id_person = t_person.id
         left join reo_rea.t_employee on t_expert.id = t_employee.id_expert
         left join reo_rea.t_expert_organization on t_employee.id_eo = t_expert_organization.id
        left join (select e2.id, max(em2.id) bd2
                   from reo_rea.t_expert e2
                            left join reo_rea.t_person p2 on e2.id_person = p2.id
                            left join reo_rea.t_employee em2 on e2.id = em2.id_expert
                            left join reo_rea.t_expert_organization o2 on em2.id_eo = o2.id
                   where em2.is_fired is false
                   and id_eo is not null
            --and e2.id = 675
            group by e2.id
            ) t1 on t1.id=t_expert.id
left join (select e3.id, max(em3.id) bd3
                   from reo_rea.t_expert e3
                            left join reo_rea.t_person p3 on e3.id_person = p3.id
                            left join reo_rea.t_employee em3 on e3.id = em3.id_expert
                            left join reo_rea.t_expert_organization o3 on em3.id_eo = o3.id
                   where em3.is_fired is true
                   and id_eo is not null
            --and e3.id = 675
            group by e3.id) t2 on t2.id=t1.id
where
      --t_expert.id = 191 and
      t_expert_organization.reg_number is not null
and (bd2 < bd3)
order by id, begin_date desc