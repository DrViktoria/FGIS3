WITH np AS (
    SELECT npi.id_ap,
           npi.decision_date,
           'Да'::text AS type,
           npi.service_number,
           npi.decision_number,
           npi.service_date,
           npi.id_oa_list
    FROM ral.t_national_part_include npi
             LEFT JOIN ral.t_oa_unstruct oau ON oau.id_oa_list = npi.id_oa_list
    UNION ALL
    SELECT npe.id_ap,
           npe.decision_date,
           'Нет'::text             AS type,
           NULL::character varying AS service_number,
           npe.decision_number,
           NULL::date              AS service_date,
           NULL::integer           AS npi_oa_list
    FROM ral.t_national_part_exclude npe
),
     np1 AS (
         SELECT np.id_ap,
                np.decision_date,
                np.type,
                np.service_number,
                np.decision_number,
                np.service_date,
                np.id_oa_list,
                row_number() OVER (PARTITION BY np.id_ap ORDER BY np.decision_date DESC NULLS LAST) AS rn
         FROM np

     )
SELECT np1.id_ap,
       sh.reg_number,
       sh.name_status,
       np1.decision_date,
       np1.type,
       np1.service_number,
       np1.decision_number,
       np1.service_date,
       np1.id_oa_list,
       np1.rn
FROM np1
left join ral.t_showcase sh on id_ap=id
where id_ap in (9756,12123,13650,14308,15059,18298,20295,20461,22084,22405,23718,27314,
32373,32830,32859,32983,33184,33507);


select current_date,
       reg_number as "Регистрационный номер",
       insert_np_name as "НЧ ЕР",
       name_status as "Статус"
from ral.t_showcase
where id in (9756,12123,13650,14308,15059,18298,20295,20461,22084,22405,23718,27314,
32373,32830,32859,32983,33184,33507);

