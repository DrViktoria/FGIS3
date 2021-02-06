with cte as (
    select ID,
           "Приказ о приостановке (7этап)",
           case when "Приказ о приостановке (7этап)" is null then 0 else 1 end as step7,
           "Приказ о приостановке (9этап)",
           case when "Приказ о приостановке (9этап)" is null then 0 else 1 end as step9,
           "ДатаРегУведомлОбУстрНаруш",
           case when "ДатаРегУведомлОбУстрНаруш" is null then 0 else 1 end     as datereg
    from FSA_META.task_11481
)
select DISTINCT cs.ID,
                "Тип ГУ",
                "Номер ГУ",
                to_char("Дата регистрации ГУ", 'dd.mm.YYYY'),
                "Аттестат аккредитации",
                TRANSLATE(obj.value, 'x' || CHR(10) || CHR(13), 'x ')               as "Наименование заявителя",
                ИНН,
                ОГРН,
                "Ответственный исполнитель УА",
                "Текущий этап ГУ",
                step7 + step9 + datereg                                             as "Количество приостановок",
                "Отказов экспертов",
                "КолАдрМОД",
                case when "РасшОблаАккр" is null then 'Нет' else "РасшОблаАккр" end as "ПК с расширением",
                case when iae.value = 3 then 'Да' else 'Нет' end                    as "ПК5"
from FSA_META.task_11481 cs
         left join fsa_pkgu_dw.dat_object_raw16 r on cs.id = r.id_object and
                                                     r.id_attribute = hextoraw('0A60BC32F5874F3498362ABE1CF18CD2') -- card_service.request
         left join fsa_pkgu_dw.DAT_OBJECT_NUMBER iae on iae.id_object = r.value and
                                                        iae.id_attribute = hextoraw('5412A4C1D8704CFDA96E17CFBE0AB448') -- cc_procedure_base
         left join FSA_PKGU_DW.DAT_CARD_SERVICE csf on csf.ID_OBJECT = cs.ID
         left join FSA_PKGU_DW.DAT_OBJECT_CHAR obj on csf.ID_APPLICANT = obj.ID_OBJECT and
                                                      obj.ID_ATTRIBUTE = hextoraw('2375672601A04723897DE361D3352D74')
         left join cte on cs.ID = cte.ID
order by 2, 3;