SELECT  cert_reg_date,count(*)
 FROM dossier.mv_co_crt WHERE cert_reg_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  public_date,count(*)
 FROM dossier.mv_rss_certificate_os WHERE public_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  public_date,count(*)
 FROM dossier.mv_rss_protocol_os WHERE public_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  public_date,count(*)
 FROM dossier.mv_rss_document_os WHERE public_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  decl_reg_date,count(*)
 FROM dossier.mv_co_dc WHERE decl_reg_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  public_date,count(*)
 FROM dossier.mv_rds_declaration_mnf WHERE public_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  public_date,count(*)
 FROM dossier.mv_rds_protocol WHERE public_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

SELECT  public_date,count(*)
 FROM dossier.mv_rds_product WHERE public_date <= now()  GROUP BY 1 ORDER BY 1 DESC LIMIT 14;

--Уникальные пользователи
select distinct *
from (
         select applicant_inn,
                public_date,
                ap_full_name,
                row_number() over (partition by applicant_inn order by public_date desc) as stages
         from dossier.mv_rds_declaration_mnf as tabl
         where decl_reg_number not like '%РА01%'
           and public_date between '2020-12-01' and '2021-01-31'
           and ap_full_name is not null
    and applicant_inn is not null
     )
         as temp
where temp.stages = 1
and applicant_inn is not null
and length(applicant_inn) =10
limit 4000;