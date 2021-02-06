select inn, ogrn, ea.*
from nsi.dic_egrul e
left join  nsi.dic_egrul_ul_address eua on eua.ul_id=e.id_dic
left join nsi.dic_egrul_addresses ea on  ea.id_dic=eua.address_id
where ogrn = '1044205009221'
