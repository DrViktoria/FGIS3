select name_status as "Статус",
       reg_number  as "Регистрационный номер",
       full_name   as "Наименование АЛ",
       mail        as "Эл.адрес АЛ",
       app_mail    as "Эл.адрес заявителя"
from ral.t_showcase
where id_type = 10
  and id_status in (6, 15, 19)
order by 1

--РАЛ (Травкина)
select name_status    as "Статус",
       reg_number     as "Номер записи в РАЛ",
       name_type      as "Тип",
       full_name      as "Наименование АЛ",
       head_full_name as "ФИО руководителя аккредитованного лица",
       phone          as "Номер телефона аккредитованного лица",
       mail           as "Эл.адрес АЛ",
       address        as "Адрес места осуществления деятельности"
from ral.t_showcase
where id_status in (6, 15, 19)
order by 1

--email ИЛ (рассылка)
Select distinct t_ap_contact.value
from ral.t_accred_person
left join  ral.t_ap_contact on t_accred_person.id = t_ap_contact.id_ap
--     left join ral.t_applicant on t_accred_person.id_app = t_applicant.id
-- left join  ral.t_app_contact on t_applicant.id = t_app_contact.id_applicant
where id_status in (6,15, 19)
and t_accred_person.id_type = 10
and id_contact_type = 4

Select distinct t_app_contact.value
from ral.t_accred_person
--left join  ral.t_ap_contact on t_accred_person.id = t_ap_contact.id_ap
left join ral.t_applicant on t_accred_person.id_app = t_applicant.id
left join  ral.t_app_contact on t_applicant.id = t_app_contact.id_applicant
where id_status in (6,15, 19)
and t_accred_person.id_type = 10
and id_contact_type = 4

select count(*)
from register.rpi.t_protocol_view_sent
where to_char (sent_date, 'YYYY-mm-dd') =  '2021-01-26'
and id_status_data = 13
and id_status = 6

select count(*)
from register.rpi.t_protocol_view_last
where to_char (sent_date, 'YYYY-mm-dd') =  '2021-01-26'
and id_status = 6

select reg_number, oa_np_regulation
from ral.t_showcase
where insert_np is true

--email ИЛ (рассылка)
Select distinct t_ap_contact.value
from ral.t_accred_person
left join  ral.t_ap_contact on t_accred_person.id = t_ap_contact.id_ap
where id_status in (6,15, 19)
and id_contact_type = 4
union
Select distinct t_app_contact.value
from ral.t_accred_person
left join ral.t_applicant on t_accred_person.id_app = t_applicant.id
left join  ral.t_app_contact on t_applicant.id = t_app_contact.id_applicant
where id_status in (6,15, 19)
and id_contact_type = 4

