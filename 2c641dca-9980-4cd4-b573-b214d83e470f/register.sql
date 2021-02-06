--Действующие эксперты
select status                                   as "Статус",
       t_showcase_expert.reg_number             as "Регистрационный номер",
       expert_fio                               as "ФИО эксперта",
       eo_full_name                             as "Наименование организации",
       expert_phone                             as "Номер телефона ЭА",
       expert_email                             as "Адрес электронной почты ЭА",
       string_agg(t_address.full_address, '; ') as "Адрес места жительства ЭА"
from reo_rea.t_showcase_expert
         left join reo_rea.t_expert on t_expert.id = t_showcase_expert.id
         left join reo_rea.t_address on t_expert.id = t_address.id_expert
where t_showcase_expert.id_status in ('6', '15', '19')
group by status, t_showcase_expert.reg_number, expert_fio, eo_full_name, expert_phone, expert_email
order by 1, 2;

--Действующие эксперты ФАУ
select status                                   as "Статус",
       t_showcase_expert.reg_number             as "Регистрационный номер",
       expert_fio                               as "ФИО эксперта",
       eo_full_name                             as "Наименование организации"
--        expert_phone                             as "Номер телефона ЭА",
--        expert_email                             as "Адрес электронной почты ЭА",
--        string_agg(t_address.full_address, '; ') as "Адрес места жительства ЭА"
from reo_rea.t_showcase_expert
         left join reo_rea.t_expert on t_expert.id = t_showcase_expert.id
         left join reo_rea.t_address on t_expert.id = t_address.id_expert
where t_showcase_expert.id_status in ('6')
and id_reo = '47'
group by status, t_showcase_expert.reg_number, expert_fio, eo_full_name, expert_phone, expert_email
order by 1, 2;

--Сотрудники ОС
select  distinct employee_id,
       al_cert as "Регистрационный номер ОС",
       fio as "ФИО сотрудника",
       snils as "СНИЛС сотрудника",
       t_alw_int_showcase.date_in as "Дата приема",
      t_alw_int_showcase.date_fire as "Дата увольнения",
       string_agg(name, ', ') as "Функция"
       --string_agg(accred_scope, '; ') as "Область специализации сотрудника"
from register.ap_rep.t_alw_int_showcase
         left join ap_rep.t_alw_experience on alw_id = employee_id
    left join ap_rep.t_alw_workplace on t_alw_workplace.alw_id = t_alw_int_showcase.employee_id
left join  ap_rep.t_alwp_function on t_alw_workplace.id = t_alwp_function.alwp_id
where employee_state_id = 1
  --and date_fire is null
  and al_type in ('9', '7', '16', '8')
group by employee_id, al_cert, fio, snils, t_alw_workplace.date_in, t_alw_workplace.date_fire
order by 1;

select distinct w.id,
                sh.al_cert                                                  as "Регистрационный номер ОС",
                w.second_name || ' ' || w.first_name || ' ' || w.patronimyc as "ФИО сотрудника",
                w.snils                                                     as "СНИЛС сотрудника",
                case when employee_state_id = 1 then 'Работает'
                    when employee_state_id= 2 then 'Не задействован'
                        when employee_state_id = 3 then 'Уволен'
                            when employee_state_id = 4 then 'Временно отсутствует' end as "Статус",
                wp.date_in                                                  as "Дата приема",
                wp.date_fire                                                as "Дата увольнения",
                string_agg(f.name, ', ')                                    as "Функция"

from ap_rep.t_al_worker w
         left join ap_rep.t_alw_workplace wp on w.id = wp.alw_id
         left join ap_rep.t_alwp_function f on wp.id = f.alwp_id
         left join ap_rep.t_alw_int_showcase sh on w.id = sh.employee_id
where w.al_type in ('9', '7', '16', '8')
and al_cert is not null
--and employee_state_id is not null
group by w.id, employee_state_id, w.second_name || ' ' || w.first_name || ' ' || w.patronimyc, w.snils, wp.date_in, wp.date_fire,
         sh.al_cert
order by 1;


--ГУ экспертов 2019-2020 год
select t_expert.id,
       concat(surname, ' ', first_name, ' ', patronimyc) as "ФИО эксперта",
       t_expert.reg_number                               as "№ Эксперта",
       t_expert_organization.full_name                   as "Эксп.орг",
       t_expert_organization.reg_number                  as "№ Эксп. орг",
       string_agg(distinct a.service_number, '; ')       as "ГУ за 2019",
       count(distinct a.service_number)                  as "Количество ГУ за 2019",
       t1."Завершенные ГУ",
       t1."Количество завершенных",
       t2."ГУ (отказ)",
       t2."Количество отказных"
from reo_rea.t_expert
         left join reo_rea.t_person on t_expert.id_person = t_person.id
         left join reo_rea.t_employee on t_expert.id = t_employee.id_expert
         left join reo_rea.t_expert_organization on t_employee.id_eo = t_expert_organization.id
         left join reo_rea.t_rea_jobs_accreditation a on t_employee.id = a.id_emploee ---ГУ аккредитация
         left join (select t_expert.id,
                           t_expert_organization.id e,
                           string_agg(distinct a.service_number, '; ') as "Завершенные ГУ",
                           count(distinct a.service_number)            as "Количество завершенных"
                    from reo_rea.t_expert
                             left join reo_rea.t_person on t_expert.id_person = t_person.id
                             left join reo_rea.t_employee on t_expert.id = t_employee.id_expert
                             left join reo_rea.t_expert_organization on t_employee.id_eo = t_expert_organization.id
                             left join reo_rea.t_rea_jobs_accreditation a on t_employee.id = a.id_emploee ---ГУ аккредитация
                    WHERE
                        --t_expert.id = 3 and
                        a.completion_date between '2020-10-01' and '2020-12-31'
                    group by t_expert.id, concat(surname, ' ', first_name, ' ', patronimyc), t_expert.reg_number,
                             t_expert_organization.full_name, t_expert_organization.reg_number, e
                    order by 1) t1 on t1.id = t_expert.id and  t1.e = t_expert_organization.id
         left join (select t_expert.id,
                           t_expert_organization.id e2,
                           string_agg(distinct a.service_number, '; ') as "ГУ (отказ)",
                           count(distinct a.service_number)            as "Количество отказных"
                    from reo_rea.t_expert
                             left join reo_rea.t_person on t_expert.id_person = t_person.id
                             left join reo_rea.t_employee on t_expert.id = t_employee.id_expert
                             left join reo_rea.t_expert_organization on t_employee.id_eo = t_expert_organization.id
                             left join reo_rea.t_rea_jobs_accreditation a on t_employee.id = a.id_emploee ---ГУ аккредитация
                    WHERE
                        --t_expert.id = 3 and
                        a.refusal_date between '2020-10-01' and '2020-12-31'
                    group by t_expert.id, concat(surname, ' ', first_name, ' ', patronimyc), t_expert.reg_number,
                             t_expert_organization.full_name, t_expert_organization.reg_number, e2
                    order by 1) t2 on t2.id = t_expert.id and  t2.e2 = t_expert_organization.id
WHERE
--t_expert.id = 14 and
a.begin_date between '2020-01-01' and '2020-12-31'
group by t_expert.id, concat(surname, ' ', first_name, ' ', patronimyc), t_expert.reg_number,
         t_expert_organization.full_name,
         t_expert_organization.reg_number, t1."Завершенные ГУ", t1."Количество завершенных",
         t2."ГУ (отказ)", t2."Количество отказных"
order by 1;

--попытка выгрузить проблемных ЭА по месту работу
select  distinct t_expert.id,
       concat(surname, ' ', first_name, ' ', patronimyc) as "ФИО эксперта",
       t_expert.reg_number                               as "№ Эксперта",
                status as "Статус",
       t_expert_organization.full_name                   as "Эксп.орг",
       t_expert_organization.reg_number                  as "№ Эксп. орг",
       t_employee.begin_date,
       end_date,
       case when is_fired is true then 'Да' else 'Нет' end as "Уволен"
from reo_rea.t_expert
         left join reo_rea.t_person on t_expert.id_person = t_person.id
         left join reo_rea.t_employee on t_expert.id = t_employee.id_expert
         left join reo_rea.t_expert_organization on t_employee.id_eo = t_expert_organization.id
    left join reo_rea.t_showcase_expert on t_expert.id = t_showcase_expert.id
        left join (select e2.id, em2.begin_date bd2
                   from reo_rea.t_expert e2
                            left join reo_rea.t_person p2 on e2.id_person = p2.id
                            left join reo_rea.t_employee em2 on e2.id = em2.id_expert
                            left join reo_rea.t_expert_organization o2 on em2.id_eo = o2.id
                   where em2.is_fired is false
            --and e3.id = 191
            ) t1 on t1.id=t_expert.id
left join (select e3.id, max(em3.begin_date) bd3
                   from reo_rea.t_expert e3
                            left join reo_rea.t_person p3 on e3.id_person = p3.id
                            left join reo_rea.t_employee em3 on e3.id = em3.id_expert
                            left join reo_rea.t_expert_organization o3 on em3.id_eo = o3.id
                   where em3.is_fired is true
            --and e3.id = 191
            group by e3.id) t2 on t2.id=t1.id
where
      --t_expert.id = 191 and
      t_expert_organization.reg_number is not null
and (bd2 < bd3)
order by id, begin_date desc;

--ГУ-ЭО-ЭА (Дунаев)
select t_expert.id,
       concat(surname, ' ', first_name, ' ', patronimyc) as "ФИО эксперта",
       t_expert.reg_number                               as "№ Эксперта",
       t_expert_organization.full_name                   as "Эксп.орг",
       t_expert_organization.reg_number                  as "№ Эксп. орг",
       a.service_number,
       a.service_date,
       to_char(a.completion_date, 'YYYY-mm-dd'),
       to_char(a.refusal_date,'YYYY-mm-dd')
--        string_agg(distinct a.service_number, '; ')       as "ГУ за 2019",
--        count(distinct a.service_number)                  as "Количество ГУ за 2019",
from reo_rea.t_expert
         left join reo_rea.t_person on t_expert.id_person = t_person.id
         left join reo_rea.t_employee on t_expert.id = t_employee.id_expert
         left join reo_rea.t_expert_organization on t_employee.id_eo = t_expert_organization.id
         left join reo_rea.t_rea_jobs_accreditation a on t_employee.id = a.id_emploee ---ГУ аккредитация
where
      --a.service_date between '2020-01-01' and '2020-12-31' or
      a.completion_date between '2020-06-01' and '2020-12-31'