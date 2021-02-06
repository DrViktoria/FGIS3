select 'РCС' as  name, count(*)
from rss.t_search_certificate
where id_status in (3,6,15,16)
union
select 'РДС' as  name, count(*)
from rds.t_search_declaration
where id_status in (3,6,15)

select 'РАЛ' as  name, count(*)
from ral.ral.t_showcase
where id_status in (6,15,19)

select 'РПИ' as  name, count(*)
from register.rpi.t_protocol_view_sent
where id_status = 6
union
select 'ТО' as  name, count(*)
from register.ap_rep.t_hwi_int_showcase;



