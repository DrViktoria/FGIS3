/*Основные сведения ДС*/
select
mnf_adr_applicant_id,id, public_date, decl_reg_number, decl_status, decl_type_name, decl_reg_date, decl_end_date, decl_obj_type,
product_origin,  pg_info, pt_name, product_descr, nd_name, co_full_name, co_attestat_reg_number, protocol_descr,
appl_declarant, appl_subject_type, applicant_ogrn, applicant_inn, ap_full_name,  manufacturer_subject_type, manufacturer_ogrn, manufacturer_inn, manufacturer_name,
mnf_adr_actual,mnf_adr_active,mnf_adr_country,filial_code
from dossier.mv_rds_declaration_mnf
where  public_date between '24.01.2021' and '30.01.2021'
and object_type_id in (2,3)
order by public_date desc;

/*Протоколы ДС*/
Select
id, public_date, decl_reg_number, st_name, decl_type_name, decl_reg_date, reg_number, tl_name, tl_begin_date,
is_accred_eec,   country_name, decl_num, protocol_number, protocol_date, is_file_scan, standardt_names, c_org_name, c_org_reg_num
from dossier.mv_rds_protocol
where  public_date between '24.01.2021' and '30.01.2021'
order by public_date desc;

/*Продукция ДС*/
select
id, public_date, decl_reg_number, st_name, decl_type_name,  decl_reg_date, is_russian, pg_name, pt_name, marking, usage_scope,
storage_conditions,  usage_conditions, batch_size, batch_id, name, type, trade_mark, model, article, sort, life_time, storage_time,
amount, factory_number, production_date, expiry_date, gtin_code, doc_names, standart_names
from dossier.mv_rds_product
where  public_date between '24.01.2021' and '30.01.2021'
and object_type_id in (2,3)
order by public_date desc;

/*Предписания ДС*/
select
dcl.id, dcl.public_date::date as public_date,
 trim(translate(dcl.decl_reg_number, chr(10) || chr(13) || '"', '')) as decl_reg_number,
 trim(translate(dcl.st_name, chr(10) || chr(13) || '"', '')) as st_name,
 trim(translate(dcl.decl_type_name, chr(10) || chr(13) || '"', '')) as decl_type_name,
 dcl.decl_reg_date,
 trim(translate(o.s_full_name, chr(10) || chr(13) || '"', '')) as name_gos_control,
 trim(translate(pres.foiv_management_name, chr(10) || chr(13) || '"', '')) as name_upr_gos_control,
 trim(translate(fao.offname, chr(10) || chr(13) || '"', '')) as subject,
 trim(translate(pr_type.short_name, chr(10) || chr(13) || '"', '')) as  type_prescr,
 pres.issue_date,
 trim(translate(ch.comment, chr(10) || chr(13) || '"', '')) as comment,
  ch.begin_date::date,
  trim(translate(rsn.s_name, chr(10) || chr(13) || '"', '')) as reason_set_status,
  trim(translate(pres.doc_name, chr(10) || chr(13) || '"', '')) as doc_name,
  trim(translate(pres.doc_number, chr(10) || chr(13) || '"', '')) as doc_number,
   pres.doc_date
from rds.prescription pres
join rds.decl_change_status ch on pres.dcs_id = ch.id and ch.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and ch.status_id = 5
join rds.co_dc dcl on ch.declaration_id = dcl.id
left join nsi.dic_okogu o on o.id_dic = pres.foiv_id
left join nsi.dic_dc_prescript_type pr_type on pr_type.id_dic = pres.type_id
left join nsi.dic_cc_dc_change_reason rsn on rsn.id_master::integer = ch.basis_id
left join nsi.dic_fias_addrobj fao on fao.aoguid::text = pres.subject_id::text and fao.aolevel = 1
where dcl.public_date between '24.01.2021'::date and '30.01.2021'::date
and pres.type_id = 2 and pres.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
order by public_date desc;

/*2.1.  Основные сведения СС*/
select
 id, appl_number,app_date,app_submission_date,status_name,conformity_doc_kind_brief_name,doc_number,blank_number,first_begin_date,public_date,cert_reg_date,cert_end_date,
      end_date_is_null,cert_issue_decision_date,deadline_violation,batch_inspection,stop_begin_date,stop_end_date,stop_doc_code,stop_doc_date,stop_rsn_name, stop_st_comment,
      res_begin_date,res_doc_code,res_doc_date,res_rsn_name,res_st_comment,term_begin_date,term_doc_code,term_doc_date,term_rsn_name,term_st_comment,scheme_code,obj_type_name,
      no_sanction,orign,annex,okpd_code,tnved_code,nd_name,product_group,pt_name,product_group_info,apl_type,apl_act_type,apl_ogrn,apl_inne,apl_kpp,addl_reg_info,apl_is_eec_register,
      apl_cn_tel,apl_cn_fax,apl_cn_email,apl_cn_www,apl_full_name,apl_short_name,apl_head_name,apl_head_post,apl_adr_actual,apl_adr_active,mnf_act_type,mnf_ogrn,mnf_inn,mnf_kpp,
      mnf_reg_date,mnf_is_eec_register,mnf_cn_tel,mnf_cn_fax,mnf_cn_email,mnf_cn_www,mnf_full_name,mnf_short_name,mnf_head_name,mnf_head_post,mnf_adr_country,mnf_adr_actual,
      mnf_adr_active,filial_code, c_org_name,c_org_reg_number,c_org_reg_date,c_org_head_name,c_org_snils,c_org_adr_adr_active,c_org_adr_adr_actual, tl_code, tl_basis,
      exp_code,signer_function,pt_stnd,act_analize,number_act_analize,date_act_analize
from dossier.mv_rss_certificate_os
where public_date between '24.01.2021' and '30.01.2021'
order by public_date;

/*2.3.  Протоколы СС*/
select
id, doc_number, status_name, public_date, cert_reg_date,  conformity_doc_kind_brief_name, reg_number, full_name,
tl_begin_date, is_accred_eec, country_name, decl_num, protocol_number, protocol_date, is_file_scan, standart_names, c_org_name, c_org_reg_num
from dossier.mv_rss_protocol_os
where public_date between '24.01.2021' and '30.01.2021'
order by public_date;

/*2.2.  Продукция СС*/
select
id,doc_number,status_name,conformity_doc_kind_brief_name,public_date,cert_reg_date,is_russian,  nd_name,pg_name,pt_name,marking,usage_scope,storage_condition,usage_conditions,batch_size,batch_id,       name,type,trade_mark,model,article,sort,life_time,storage_time,amount,factory_number,production_date,  expiry_date,gtin_code,doc_names,standart_names
from dossier.mv_rss_product_os
where public_date between '24.01.2021' and '30.01.2021'
order by public_date;

/*2.5.  Контроль СС*/
select
id,reg_num,cert_status,conformity_doc_kind_brief_name,public_date,
cert_reg_date, plan_date,fact_date,next_plan_date,act_number, act_date,decision_number,decision_date,
doc_number,doc_date, analysis_begin_date,analysis_end_date, smk_result,result,is_result,  correct_action,  is_defect_resolved, reason_control
from dossier.mv_rss_control_os
where public_date between '24.01.2021' and '30.01.2021'
order by public_date;

/*2.4.  Документы СС*/

select
id,doc_number,status_name,public_date,cert_reg_date,crt_type,document_type, doc_category,num,doc_name,begin_date,
end_date, contract_subject, app_responsibility, man_responsibility, sample_name, sample_type, sample_mark, sample_model, sample_article, sample_sort, smk_apply_description, is_annex
from dossier.mv_rss_document_os
where public_date between '24.01.2021' and '30.01.2021'
order by public_date;

/*РАБОТНИКИ*/
select  wr.id,
        trim(translate(wr_type.full_name, chr(10)||chr(13)||'"', '')) as wr_type,
        trim(translate(coalesce(rl.full_name, parma.full_name, ral_rn.full_name), chr(10)||chr(13)||'"', '')) as rl_name,
        trim(translate(rl.reg_number, chr(10)||chr(13)||'"', '')) as reg_number,
        trim(translate(dic_st_al.s_name, chr(10)||chr(13)||'"', '')) as status_al,
        parma.reg_date,  parma.attestat_expire_date::date as attestat_expire_date, trim(translate(bs_stop.s_name, chr(10)||chr(13)||'"', '')) as base_stop_attestat,
        trim(translate(concat_ws(' ', wr.second_name, wr.first_name, wr.patronimyc), chr(10)||chr(13)||'"', '')) as wr_name,
        trim(translate(wr.snils, chr(10)||chr(13)||'"', '')) as snils,
        case when coalesce(wpl.date_fire, '01.01.2999') <= now() then 'Уволен'
        else case when coalesce(abs_rsn.worker_id, 0) > 0 and abs_rsn.date_to>=now() then 'Временно отсутствует' else 'Работает' end
        end as wr_status,
        trim(translate(fnc.func_worker, chr(10)||chr(13)||'"', '')) as wpl_func,
        trim(translate(emp_type.s_name, chr(10)||chr(13)||'"', '')) as emp_type,
        trim(translate(cn_type.s_name, chr(10)||chr(13)||'"', '')) as cn_type, wpl.date_in::date as date_in, wpl.date_fire::date as date_fire,
        trim(translate(adl.access_form, chr(10)||chr(13)||'"', '')) as access_form,
        abs_rsn.absence_reasons,
        case when wr.involved then 'да' else 'нет' end as involved,
        trim(translate(exper.experience, chr(10)||chr(13)||'"', '')) as experience,
        to_char(wr.birth_date, 'dd.mm.yyyy') as birth_date,
        trim(translate(wr.birth_place, chr(10)||chr(13)||'"', '')) as birth_place,
        case when (count(rl.id) over(partition by wr.snils))>1 and coalesce(wpl.date_fire,'01.01.2999') > now() then 'да' else 'нет' end as is_mlt_work,
        case when dif_al.mlt>0 then 'Да' else  'Нет' end as is_mlt_al,
        wr.send_date,
        to_char(greatest(wpl.send_date, wr.send_date, fnc.send_date, abs_rsn.send_date,
                         adl.send_date, abs_rsn.send_date, fnc.send_date, exper.send_date), 'YYYY-MM-DD HH24:MI:SS') as max_send_date,
        case when status_rec.ral_status = 1
             then 'Ожидает подтверждения сотрудником росаккредитации'
             when status_rec.ral_status = 2
             then 'Заявка на внесение сотрудника в РАЛ отклонена'
             when status_rec.ral_status = 3
             then 'Заявка на внесение сотрудника в РАЛ одобрена'
             when status_rec.ral_status = 4
             then 'у сотрудника из заявки дублируется СНИЛС'
             else null
         end as ral_status,
       dic_st.s_name as wr_status--,
       --apl.inn разовый запрос ИНН заявителя
  from ap_rep.workplace wpl
  join ap_rep.worker wr on wpl.worker_id = wr.id and wr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and wr.is_once_sent
  left join (select *
              from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=register',
              $$
              select id, coalesce(ral_status::int,0) as ral_status
              from ap_rep.t_al_worker;
              $$
              ) t(id int, ral_status int))status_rec on status_rec.id = wr.id
  join nsi.dic_registry_record_status dic_st on wr.dst_id = dic_st.id_dic and dic_st.id_master = '13'
  left join ral.ral rl on rl.id::text = wr.al_id::text and rl.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
  left join (select r.reg_number, max(r.full_name) as full_name, max(appl_id) as appl_id
             from ral.ral r
             join nsi.dic_registry_record_status r_st on r.nsi_drrs_id = r_st.id_dic and r_st.id_master <> '1'
             where not r.full_name is null
             group by r.reg_number) ral_rn on ral_rn.reg_number = rl.reg_number
  left join nsi.dic_registry_record_status dic_st_al on rl.nsi_drrs_id = dic_st_al.id_dic
  join nsi.dic_registry_record_status reg_rl on reg_rl.id_master = rl.nsi_drrs_id::varchar and reg_rl.id_master not in ('1','18','20')
  left join (select st.s_name, st.ral_id
             from (select wb.s_name, bs.ral_id,
                          row_number() over (partition by bs.ral_id order by bs.id desc) as rn
                   from ral.basis_status bs
                   join nsi.dic_ac_withdrawal_basis wb on bs.id_basis = wb.id_dic
                   where bs.status_id = 2
                   and bs.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone)st
            where st.rn = 1) bs_stop on bs_stop.ral_id = rl.id
  left join (select t.full_name, t.id_al, t.reg_date, t.attestat_expire_date, t.appl_id
              from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=ral',
              $$
                select  max(coalesce(rl_name,rl_name_rn)) as rl_name, rl_id, max(rl_reg_date) as rl_reg_date, max(rl_attestat_expire_date) as rl_attestat_expire_date,
                        max(appl_id) as appl_id
                  from (select rl.id as rl_id,
                               first_value(rl.full_name) over (partition by g.reg_number order by rl.full_name desc nulls last) as rl_name_rn,
                               first_value(rl.full_name) over (partition by rl.id order by rl.rev desc nulls last) as rl_name,
                               first_value(rl.reg_date) over (partition by rl.id order by rl.rev desc) as rl_reg_date,
                               first_value(rl.attestat_expire_date) over (partition by rl.id order by rl.rev desc) as rl_attestat_expire_date,
                               first_value(rl.id_app) over (partition by rl.id order by rl.rev desc) as  appl_id
                        from ral.t_accred_person_aud rl
                        join ral.t_reg_number_aud g on rl.id = g.id_ap) src1
                group by rl_id;
              $$
              ) as t (full_name varchar, id_al integer, reg_date date, attestat_expire_date timestamp, appl_id integer)) parma on parma.id_al = wr.al_id::integer
 --разовый запрос ИНН заявителя
    -- left join ral.applicant apl on apl.id =  coalesce(rl.appl_id, parma.appl_id, ral_rn.appl_id)
  left join (select worker_id,
                    string_agg(l.s_name, '; ') as access_form,
                    max(send_date) as send_date
            from ap_rep.addl_info a
            join nsi.dic_state_secret_perm_lvl l on a.access_form::integer = l.id_dic
            where d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
              and a.dst_id = 13
              and access_form is not null
            group by worker_id) adl on adl.worker_id = wr.id
  left join (select f.workplace_id,
                    string_agg(f.name, '; ') as func_worker,
                    max(f.send_date) as send_date
              from ap_rep.workplace_function f
              where f.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                and f.dst_id = 13
              group by f.workplace_id) fnc on fnc.workplace_id = wpl.id
  left join (select abs.worker_id,
                    string_agg(rsn.s_name||' с '||abs.date_from::date||' по '||
                               coalesce(abs.date_to::date, '2999-01-01'), '; ')  as absence_reasons,
                    abs.worker_vers_id,
                    max(coalesce(abs.date_to,'2999-01-01 00:00:00.000000'::timestamp without time zone)) as date_to,
                    max(abs.send_date) as send_date
              from ap_rep.absence abs
              join nsi.dic_employee_absence_reason rsn on abs.reason_id = rsn.id_dic
              where abs.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                and coalesce(abs.date_to, '2999-01-01 00:00:00.000000'::timestamp without time zone) >= now()
                and abs.dst_id = 13
                and abs.is_once_sent
              group by abs.worker_id, abs.worker_vers_id) abs_rsn on abs_rsn.worker_id = wpl.worker_id and wpl.worker_vers_id = abs_rsn.worker_vers_id
  left join (select exp.worker_id,
                    string_agg(exp.accred_scope||' - '||exp.years||'лет', '; ') as experience,
                    max(exp.send_date) as send_date
              from  ap_rep.experience exp
              where exp.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                and exp.dst_id = 13
              group by exp.worker_id) exper on exper.worker_id = wpl.worker_id
  left join (select count(distinct t.al_id) as cnt, sum(t.mlt) as mlt, t.worker_id
             from (select wr.id as worker_id,wpl.date_in, wpl.date_fire, wpl.al_id,
                         case when (lag(coalesce(wpl.date_fire, '2999-01-01')) over (partition by wr.id order by wpl.date_in desc) between wpl.date_in and coalesce(wpl.date_fire, '2999-01-01')
                                   or lag(wpl.date_in) over (partition by wr.id order by wpl.d_begin desc) between wpl.date_in and coalesce(wpl.date_fire, '2999-01-01'))
                                   and lag(wpl.al_id, - 1, wpl.al_id) over (partition by wr.id order by wpl.d_begin desc)  <> wpl.al_id
                                   and wpl.ctp_id = 1--по основному месту
                                  then 1
                                  else 0
                             end as mlt
                   from ap_rep.workplace wpl
                   join ap_rep.worker wr on wpl.worker_id = wr.id and wr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and wr.is_once_sent
                   where wpl.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                   and wpl.is_once_sent
                   and wpl.dst_id = 13 ) t
             group by t.worker_id) dif_al on dif_al.worker_id = wpl.worker_id
  left join nsi.dic_accreditation_body_type wr_type on wr.al_type::numeric = wr_type.id_dic
  left join nsi.dic_employment_type emp_type on wpl.ctp_id = emp_type.id_dic
  left join nsi.dic_employment_contract_type cn_type on wpl.invb_id = cn_type.id_dic
  where wpl.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
  and wpl.is_once_sent
  and wr.is_once_sent
  order by coalesce(rl.full_name, parma.full_name), concat_ws(' ', wr.second_name, wr.first_name, wr.patronimyc), wpl.date_in desc
  ;

/*ТО*/
SELECT hwi.id as id_hwi,
       trim(translate(ac_type.full_name, chr(10)||chr(13)||'"', '')) as type_ral,
       trim(translate(coalesce(rl.full_name,ral_rn.full_name), chr(10)||chr(13)||'"', '')) as name_ral, rl.reg_number, reg_rl.s_name as status_al,
       parma.reg_date, parma.attestat_expire_date::date attestat_expire_date, bs_stop.s_name as base_stop_at,
       trim(translate(eq_type.s_name, chr(10)||chr(13)||'"', '')) as type_equip,
       trim(translate(hwi.name, chr(10)||chr(13)||'"', '')) as name_equip, trim(translate(adr_rl.full_address, chr(10)||chr(13)||'"', '')) as full_addres,
       trim(translate(eq_st.s_name, chr(10)||chr(13)||'"', ''))  as status,
       trim(translate(hwi.eq_type, chr(10)||chr(13)||'"', '')) as eq_type, trim(translate(hwi.factory_number, chr(10)||chr(13)||'"', '')) as factory_number,
       hwi.date_in::date as date_in, trim(translate(eq_attest.s_name, chr(10)||chr(13)||'"', '')) as type_doc_attest,
       trim(translate(doc_hwi.doc_number, chr(10)||chr(13)||'"', '')) as doc_number, doc_hwi.doc_date::date as doc_date, doc_hwi.doc_end_date::date as doc_end_date,
       trim(translate(doc_hwi.cert_period_info, chr(10)||chr(13)||'"', '')) as cert_period_info,
       hwi.date_out::date as date_out, trim(translate(hwi.exp_end_reason, chr(10)||chr(13)||'"', '')) as exp_end_reason,
       min(hwi.send_date) over(PARTITION BY hwi.id)::date as send_date,
       greatest(hwi.send_date, doc_hwi.send_date)::date as last_send_date,
       trim(translate(eq_cntr.s_short_name, chr(10)||chr(13)||'"', '')) as manuf_country,
       trim(translate(hwi.manufacturer_name, chr(10)||chr(13)||'"', '')), hwi.production_date,
       trim(translate(hwi.ownership_right, chr(10)||chr(13)||'"', '')) as ownership_right,
       trim(translate(hwi.install_place, chr(10)||chr(13)||'"', '')) as install_place,
       trim(translate(hwi.purpose, chr(10)||chr(13)||'"', '')) as purpose,
       trim(translate(sample_type.name, chr(10)||chr(13)||'"', '')) as eq_sample_type,
       trim(translate(hwi.sample_number, chr(10)||chr(13)||'"', '')) as sample_number, trim(translate(std_type.full_name, chr(10)||chr(13)||'"', '')) as standart_type,
       hwi.date_issue::date as date_issue, hwi.shelf_life::date as shelf_life, trim(translate(hwi.norm_doc, chr(10)||chr(13)||'"', '')) as norm_doc,
       trim(translate(hwi.gos_reg_number, chr(10)||chr(13)||'"', '')) as gos_reg_number, hwi.exclude_date::date as exclude_date,
       trim(translate(hwi.exclude_num, chr(10)||chr(13)||'"', '')) as exclude_num,
       trim(translate(hwi.exclude_reason, chr(10)||chr(13)||'"', '')) as exclude_reason,
       trim(translate(prod_prm.prod_param, chr(10)||chr(13)||'"', '')) as prod_param,
       trim(translate(msr.measure, chr(10)||chr(13)||'"', '')) as measure,  trim(translate(m_gr.group_measure, chr(10)||chr(13)||'"', '')) as group_measure,
       trim(translate(obj_gr.object_group, chr(10)||chr(13)||'"', '')) as object_group,
       trim(translate(base_gr.base_param, chr(10)||chr(13)||'"', '')) as base_param,
       trim(translate(met_ch.met_characteristics, chr(10)||chr(13)||'"', '')) as met_characteristics
--select count(*)
from ap_rep.hardware_info hwi
join ral.ral rl on rl.id::varchar  = hwi.al_id
 and rl.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join nsi.dic_registry_record_status reg on reg.id_dic = hwi.dst_id and reg.id_dic = 13
join nsi.dic_registry_record_status reg_rl on reg_rl.id_master = rl.nsi_drrs_id::varchar and not reg_rl.id_master in ('1','18','20')
left join (select st.s_name, st.ral_id from
              (select wb.s_name, bs.ral_id,
                      row_number() over (partition by bs.ral_id order by bs.id desc) as rn
                   from ral.basis_status bs
                   join nsi.dic_ac_withdrawal_basis wb on bs.id_basis = wb.id_dic
                  where bs.status_id = 2
                    and bs.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone)st
          where st.rn = 1) bs_stop on bs_stop.ral_id = rl.id
left join (select r.reg_number, max(r.full_name) as full_name
             from ral.ral r
            where not r.full_name is null
            group by r.reg_number) ral_rn on ral_rn.reg_number = rl.reg_number
left join (select *
            from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=ral',
            $$
            select full_name, id, reg_date, attestat_expire_date
            from ral.t_accred_person;
            $$
            ) t(full_name varchar, id_al INTEGER, reg_date date, attestat_expire_date timestamp)) parma on parma.id_al = hwi.al_id::integer
left join (select adr.ral_id,
                  string_agg(adr.full_address, '; ') as full_address
            from ral.address adr
           where adr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
          group by adr.ral_id) adr_rl
  on adr_rl.ral_id = rl.id
left join (select hwi_id, doc_number, doc_date, doc_end_date, cert_period_info, doc_type, send_date
           from(select doc.hwi_id,
                        doc.doc_number, doc.doc_date, doc.doc_end_date, doc.cert_period_info, doc.doc_type, doc.send_date,
                        row_number() over(partition by doc.hwi_id order by doc.doc_date desc) as rn
                  from ap_rep.hwi_doc doc
                  where doc.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                    and doc.doc_end_date >= now()
                    and doc.doc_date <= now()
                    and doc.is_once_sent
                    and doc.dst_id = 13) doc_h
            where doc_h.rn = 1) doc_hwi on doc_hwi.hwi_id = hwi.id
left join (select prm.hwi_id,
                  string_agg(prm.caption, '; ') as prod_param
          from ap_rep.hwi_product_param prm
          where prm.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
            and prm.is_once_sent
            and prm.dst_id = 13
          group by  prm.hwi_id) prod_prm on prod_prm.hwi_id = hwi.id
left join (select m.hwi_id,
                  string_agg(m.caption, '; ') as measure
          from ap_rep.hwi_measure m
          where m.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
            and m.is_once_sent
            and m.dst_id = 13
          group by  m.hwi_id) msr on msr.hwi_id = hwi.id
left join (select gr.hwi_id,
                  string_agg(gr.caption, '; ') as group_measure
          from ap_rep.hwi_group gr
          where gr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
            and gr.is_once_sent
            and gr.dst_id = 13
          group by  gr.hwi_id) m_gr on m_gr.hwi_id = hwi.id
left join (select ogr.hwi_id,
                  string_agg(ogr.caption, '; ') as object_group
          from ap_rep.hwi_object_group  ogr
          where ogr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
            and ogr.is_once_sent
            and ogr.dst_id = 13
          group by  ogr.hwi_id) obj_gr on obj_gr.hwi_id = hwi.id
left join (select b_prm.hwi_id,
                 string_agg(b_prm.caption, '; ') as base_param
         from ap_rep.hwi_base_params  b_prm
          where b_prm.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
            and b_prm.is_once_sent
            and b_prm.dst_id = 13
          group by  b_prm.hwi_id) base_gr on base_gr.hwi_id = hwi.id
left join (select ch.hwi_id,
                 string_agg(concat_ws(ch.caption, 'Диапазон: ', ch.measure_range, 'КТ (Погрешность): ', ch.accuracy), '; ') as met_characteristics
          from ap_rep.hwi_met_characteristics  ch
         where ch.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           and ch.is_once_sent
           and ch.dst_id = 13
         group by  ch.hwi_id) met_ch on met_ch.hwi_id = hwi.id
left join nsi.dic_accreditation_body_type ac_type on ac_type.id_dic = hwi.al_type::numeric
left join nsi.dic_equipment_type eq_type on eq_type.id_dic = hwi.hwt_id
left join nsi.dic_equipment_status eq_st on eq_st.id_dic = hwi.status
left join nsi.dic_equipment_attestation_type eq_attest on eq_attest.id_dic::varchar = doc_hwi.doc_type
left join nsi.dic_oksm eq_cntr on eq_cntr.id_dic = hwi.manufacturer_oksm_id
left join nsi.dic_equipment_sample_type sample_type on sample_type.id::varchar = hwi.sample_type
left join nsi.dic_standard_sample_type std_type on std_type.id_dic = hwi.sc_id
where hwi.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
and hwi.is_once_sent
and hwi.dst_id ='13';

/*ТО аттестат*/
select hwi.id, trim(translate(ac_type.full_name, chr(10)||chr(13)||'"', '')) as type_ral,
       trim(translate(rl.full_name, chr(10)||chr(13)||'"', '')) as name_ral, trim(translate(rl.reg_number, chr(10)||chr(13)||'"', '')) as reg_number,
       trim(translate(eq_type.s_name, chr(10)||chr(13)||'"', '')) as type_equip,trim(translate( hwi.attest_doc_num, chr(10)||chr(13)||'"', '')) as attest_doc_num,
       to_char(hwi.attest_doc_date,'dd.mm.yyyy') as attest_doc_date, trim(translate(eq_attest.s_name, chr(10)||chr(13)||'"', '')) as attest_doc_type,
       trim(translate(doc.doc_number, chr(10)||chr(13)||'"', '')) as doc_number, to_char(doc.doc_end_date,'dd.mm.yyyy') as doc_end_date, doc.cert_period_info
from ap_rep.hwi_doc doc
join ap_rep.hardware_info hwi on doc.hwi_id = hwi.id and hwi.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join ral.ral rl on rl.id::varchar = hwi.al_id and rl.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join nsi.dic_registry_record_status reg on reg.id_dic = hwi.dst_id
left join nsi.dic_accreditation_body_type ac_type on ac_type.id_dic::varchar = hwi.al_type
left join nsi.dic_equipment_type eq_type on eq_type.id_dic = hwi.hwt_id
left join nsi.dic_equipment_attestation_type eq_attest on eq_attest.id_dic::varchar = doc.doc_type
where doc.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
and reg.id_master = '13'
and hwi.is_once_sent
order by rl.full_name, hwi.name, hwi.attest_doc_date desc;

/*РАЛ действующие и прекращенные*/
select ral_id,--Идентификатор (технический)
   s_name,--Статус--2
  abt_full_name, --Тип аккредитованного лица--3
  trim(translate(reg_number, chr(10)||chr(13)||'"',' ')) as reg_number,--Номер аттестата аккредитации--4
  trim(translate(full_name, chr(10)||chr(13)||'"',' ')) as full_name,--Полное наименование аккредитованного лица--5
  trim(translate(short_name, chr(10)||chr(13)||'"',' ')) as short_name,--Сокращенное наименование аккредитованного лица--6
  --r.regnum_begin_date,
  regnum_begin_date,--Дата включения аккредитованного лица в реестр--7
  regnum_end_date, --Срок действия аттестата аккредитации--8
  trim(translate(acr_decision_number, chr(10)||chr(13)||'"',' ')) as acr_decision_number, --Номер приказа об аккредитации--9
  acr_decision_date,--Дата приказа об аккредитаци--10
    acr_decision_number_fz412,--Номер приказа об аккредитации до 412-ФЗ--11
  acr_decision_date_fz412, --Дата приказа об аккредитации до 412-ФЗ--12
  trim(translate(head_fio, chr(10)||chr(13)||'"',' ')) as head_fio,--ФИО руководителя аккредитованного лица--13
  trim(translate(anah_full_address, chr(10)||chr(13)||'"',' ')) as anah_full_address,--Адрес места нахождения аккредитованного лица--14
  trim(translate(tel_fax, chr(10)||chr(13)||'"',' ')) as tel_fax,--15
  trim(translate(email, chr(10)||chr(13)||'"',' ')) as email,--16
  trim(translate(web, chr(10)||chr(13)||'"',' ')) as web,--17
  appl_type_full_name,--Тип заявителя--18
  okopf_name,--Организационно-правовая форма заявителя--19
  trim(translate(app_full_name, chr(10)||chr(13)||'"',' ')) as app_full_name,--Полное наименование/ФИО заявителя--20
  trim(translate(app_short_name, chr(10)||chr(13)||'"',' ')) as app_short_name,--Сокращенное наименование заявителя--21
  trim(translate(appl_per_fio, chr(10)||chr(13)||'"',' ')) as appl_per_fio,--ФИО руководителя заявителя--22
  trim(translate(head_post, chr(10)||chr(13)||'"',' ')) as head_post,--Должность руководителя заявителя--23
  trim(translate(appl_full_address, chr(10)||chr(13)||'"',' ')) as appl_full_address,--Адрес заявителя--24
 -- trim(translate(appl_d_full_address, chr(10)||chr(13)||'"',' ')) as appl_d_full_address,--Адреса мест осуществления деятельности в области аккредитации--25
  trim(translate(appl_tel_fax, chr(10)||chr(13)||'"',' ')) as appl_tel_fax,--Номер телефона заявителя--25
  trim(translate(appl_email, chr(10)||chr(13)||'"',' ')) as appl_email,--Адрес электронной почты заявителя--26
  trim(translate(appl_ogrn, chr(10)||chr(13)||'"',' ')) as appl_ogrn,--ОГРН/ОГРНИП заявителя--27
  trim(translate(appl_inn, chr(10)||chr(13)||'"',' ')) as appl_inn,--ИНН заявителя--28
    null as testing_lab,--Лаборатории, с которыми заключены договора на проведение испытаний для целей сертификации--29
    null as is_testing_base,--Наличие собственной испытательной базы--30
   null as expert_info,--Сведения об экспертах--31
  trim(translate(workers_fio, chr(10)||chr(13)||'"',' ')) as workers_fio,--ФИО работника--32
  trim(translate(oa_desc, chr(10)||chr(13)||'"',' ')) as oa_desc,--Область аккредитации (текстовое описание)--33
  trim(translate(tr_doc_num_doc_name, chr(10)||chr(13)||'"',' ')) as tr_doc_num_doc_name,--Область аккредитации (технические регламенты)--34
  trim(translate(code_tn_ved, chr(10)||chr(13)||'"',' ')) as code_tn_ved,--Область аккредитации (ТН ВЭД)--35
  trim(translate(code_okpd2, chr(10)||chr(13)||'"',' ')) as code_okpd2,--Область аккредитации (ОКПД2)--36
  trim(translate(code_okved2, chr(10)||chr(13)||'"',' ')) as code_okved2,--Область аккредитации (ОКВЭД2)--37
  trim(translate(code_okp, chr(10)||chr(13)||'"',' ')) as code_okp,--Область аккредитации (ОКП)--38
  trim(translate(code_okpd, chr(10)||chr(13)||'"',' ')) as code_okpd,--Область аккредитации (ОКПД)--39
  trim(translate(code_okun, chr(10)||chr(13)||'"',' ')) as code_okun,--Область аккредитации (ОКУН)--40
  trim(translate(expert_list, chr(10)||chr(13)||'"',' ')) as expert_list,--Сведения об экспертных организациях и экспертах, привлекаемых к работам--41
  trim(translate(status_list, chr(10)||chr(13)||'"',' ')) as status_list, --Изменение статуса аккредитованного лица--42
  trim(translate(np_np, chr(10)||chr(13)||'"',' ')) as np_np,--Национальная часть Единого реестра ЕАЭС--43
  trim(translate(gos_contr, chr(10)||chr(13)||'"',' ')) as gos_contr--Государственный контроль--44

from ( select row_number() OVER (ORDER BY r.reg_date) rn--№ п/п
  ,r.id ral_id
  ,rrs.id_master status_id
  ,rrs.s_name--Статус
  ,abt.full_name AS abt_full_name --Тип аккредитованного лица
  ,r.reg_number--Номер аттестата аккредитации
  ,r.full_name--Полное наименование аккредитованного лица
  ,r.short_name--Сокращенное наименование аккредитованного лица
  --r.regnum_begin_date,
  ,r.reg_date as regnum_begin_date--Дата включения аккредитованного лица в реестр
  ,r.regnum_end_date --Срок действия аттестата аккредитации
  ,--coalesce(acr.decision_number, acr_b_fz.decision_number)
  acr.decision_number as acr_decision_number --Номер приказа об аккредитации--9
  ,--coalesce(acr.decision_date, acr_b_fz.decision_date)
  acr.decision_date as acr_decision_date--Дата приказа об аккредитаци --10
   ,acr_b_fz.decision_number as acr_decision_number_fz412 --Номер приказа об аккредитации--11
   ,acr_b_fz.decision_date as acr_decision_date_fz412--Дата приказа об аккредитаци --12
  ,hp.last_name || ' ' || hp.first_name || ' ' || hp.middle_name head_fio--ФИО руководителя аккредитованного лица
  ,substring(string_agg(DISTINCT anah.full_address, '; '::text) from  1 for 32767) as anah_full_address--Адрес места нахождения аккредитованного лица
  ,substring(string_agg(DISTINCT tel_fax.value::text, '; '::text) from  1 for 32767) AS tel_fax
  ,substring(string_agg(DISTINCT email.value::text, '; '::text) from  1 for 32767) AS email
  ,substring(string_agg(DISTINCT web.value::text, '; '::text) from  1 for 32767) AS web
  ,pa.full_name appl_type_full_name--Тип заявителя
  ,okopf.s_name okopf_name--Организационно-правовая форма заявителя
  ,appl.full_name as app_full_name--Полное наименование/ФИО заявителя
  ,appl.short_name as app_short_name--Сокращенное наименование заявителя
  ,appl_per.last_name || ' ' || appl_per.first_name || ' ' || appl_per.middle_name appl_per_fio--ФИО руководителя заявителя
  ,appl.head_post--Должность руководителя заявителя
  ,substring(string_agg(DISTINCT appl_addr.full_address::text, '; '::text) from  1 for 32767) as appl_full_address--Адрес заявителя
  ,substring(string_agg(DISTINCT appl_d_addr.full_address::text, '; '::text) from  1 for 32767) as appl_d_full_address--Адреса мест осуществления деятельности в области аккредитации
  ,substring(string_agg(DISTINCT appl_tel_fax.value::text, '; '::text) from  1 for 32767) AS appl_tel_fax--Номер телефона заявителя
  ,substring(string_agg(DISTINCT appl_email.value::text, '; '::text) from  1 for 32767) AS appl_email--Адрес электронной почты заявителя
  ,appl.ogrn as appl_ogrn--ОГРН/ОГРНИП заявителя
  ,appl.inn as appl_inn--ИНН заявителя
  ,substring(string_agg(DISTINCT worker_fio, '; '::text) from  1 for 32767) as workers_fio--ФИО работника
  ,substring(string_agg(DISTINCT roa.oa_desc, '; '::text) from  1 for 32767) as oa_desc--Область аккредитации (текстовое описание)
  ,substring(string_agg(DISTINCT concat(nd.doc_num, ' ', nd.doc_name), '; '::text) from  1 for 32767) AS tr_doc_num_doc_name--Область аккредитации (технические регламенты)
  ,substring(string_agg(roa.code_tn_ved, '; '::text) from  1 for 32767) as code_tn_ved--Область аккредитации (ТН ВЭД)
  ,substring(string_agg(roa.code_okpd2, '; '::text) from  1 for 32767) as code_okpd2--Область аккредитации (ОКПД2)
  ,substring(string_agg(roa.code_okved2, '; '::text) from  1 for 32767) as code_okved2--Область аккредитации (ОКВЭД2)
  ,substring(string_agg(roa.code_okp, '; '::text) from  1 for 32767) as code_okp--Область аккредитации (ОКП)
  ,substring(string_agg(roa.code_okpd, '; '::text) from  1 for 32767) as code_okpd--Область аккредитации (ОКПД)
  ,substring(string_agg(roa.code_okun, '; '::text) from  1 for 32767) as code_okun--Область аккредитации (ОКУН)
  ,substring(string_agg(ea_list.ea_list, '; '::text) from  1 for 32767) as expert_list--Сведения об экспертных организациях и экспертах, привлекаемых к работам
  ,substring(string_agg(DISTINCT status_list.stat_list, '; '::text) from  1 for 32767) as status_list --Изменение статуса аккредитованного лица
  ,substring(string_agg(np.np, '; '::text) from  1 for 32767) np_np--Национальная часть Единого реестра ЕАЭС
  ,substring(string_agg(DISTINCT gc.gos_contr, '; '::text) from  1 for 32767) gos_contr
 --bs.*
    FROM ral.ral r
      JOIN nsi.dic_accreditation_body_type abt ON abt.id_dic = r.nsi_dabt_id::numeric
    ------------------------------------------------------------------------------------------------------------ПАРАМЕТР - СТАТУСЫ--------------------------
      JOIN nsi.dic_registry_record_status rrs ON r.nsi_drrs_id::numeric = rrs.id_dic AND (rrs.id_master::text = ANY(string_to_array('6,14,15,19', ',')))
                                                                -- (rrs.id_master::text = ANY(string_to_array('1', ',')))
      --JOIN ral.basis_status bs ON bs.ral_id = r.id AND bs.ral_vers_id = r.vers_id
      LEFT JOIN ral.accreditation acr ON acr.ral_id = r.id AND acr.d_end = '2999-01-01'
      LEFT JOIN ral.accreditation_before_fz_412 acr_b_fz ON acr_b_fz.ral_id = r.id AND acr_b_fz.d_end = '2999-01-01'
      LEFT JOIN ral.person hp ON hp.id = r.head_person_id AND hp.d_end = '2999-01-01'::date
      LEFT JOIN ral.address anah ON  anah.ral_id = r.id AND anah.d_end = '2999-01-01'::date and anah.id_addr_type=3 --and anah.id_addr_type=1
      LEFT JOIN ral.a_p_contacts tel_fax ON tel_fax.ral_id = r.id AND (tel_fax.id_contact_type = ANY (ARRAY[1, 3])) AND tel_fax.d_end = '2999-01-01'::date --tel_fax.ral_id = r.id AND tel_fax.ral_vers_id = r.vers_id AND (tel_fax.id_contact_type = ANY (ARRAY[1, 3]))
      LEFT JOIN ral.a_p_contacts email ON email.ral_id = r.id AND email.id_contact_type = 4 AND email.d_end = '2999-01-01'::date
      LEFT JOIN ral.a_p_contacts web ON web.ral_id = r.id AND web.id_contact_type = 5 AND web.d_end = '2999-01-01'::date
      LEFT JOIN ral.applicant appl ON r.appl_id = appl.id AND appl.d_end = '2999-01-01'::date
      LEFT JOIN nsi.DIC_PROCESS_ACTOR_TYPE pa on pa.id_dic = appl.id_type
      LEFT JOIN nsi.DIC_OKOPF okopf ON okopf.id_dic = appl.id_legal_form or okopf.id_dic = appl.id_kopf
      LEFT JOIN (select al_id, string_agg(DISTINCT trim(w.second_name || ' ' || w.first_name || ' ' || w.patronimyc || ' ' || '('||w.snils||')'), '; '::text) worker_fio
  from ap_rep.worker w where w.al_id is not null
  and w.d_end = '2999-01-01'
  group by al_id) wor on wor.al_id::text = r.id::text
      LEFT JOIN ral.person appl_per ON appl_per.id = appl.id_person AND appl_per.d_end = '2999-01-01'::date
      LEFT JOIN ral.address appl_addr ON appl_addr.appl_id = r.appl_id AND appl_addr.d_end = '2999-01-01'::date and appl_addr.id_addr_type=1
      LEFT JOIN ral.address appl_d_addr ON appl_d_addr.appl_id = r.appl_id AND appl_d_addr.d_end = '2999-01-01'::date and appl_d_addr.id_addr_type=3
      LEFT JOIN ral.appl_contacts appl_tel_fax ON appl_tel_fax.appl_id = appl.id AND (appl_tel_fax.id_contact_type = ANY (ARRAY[1, 3])) AND appl_tel_fax.d_end = '2999-01-01'::date
      LEFT JOIN ral.appl_contacts appl_email ON appl_email.appl_id = appl.id AND appl_email.id_contact_type = 4 AND appl_email.d_end = '2999-01-01'::date
      LEFT JOIN ral.oa_unstruct roa on roa.ral_id = r.id AND roa.d_end = '2999-01-01'::date
      LEFT JOIN (select ral_id,
  string_agg(coalesce(eg.eo_name, 'нет') || '; ' || coalesce(eg.expert_fio, 'нет') || ' (' || coalesce(eg.expert_reg_number, 'нет')|| ')', '; '::text) as ea_list from
  (select  ral_id, eg_id from ral.accreditation
   where d_end = date '2999-01-01'
   and eg_id is not null
   union all
   select  b412.ral_id, er.eg_id from ral.accreditation_before_fz_412 b412
   inner join ral.accr412eg er on b412.id = er.id_accrbfz412
   where b412.d_end = date '2999-01-01' and er.d_end = date '2999-01-01'
   and er.eg_id is not null and b412.ral_id is not null
   union all
   select  ral_id, eg_id from ral.confirm_competence
   where d_end = date '2999-01-01'
   and eg_id is not null
   union all
   select ral_id, eg_id from ral.change_address
   where d_end = date '2999-01-01'
   and eg_id is not null) as ce
  INNER JOIN ral.expert_group eg on ce.eg_id = eg.id and eg.d_end = date '2999-01-01'
  group by ral_id) as ea_list ON ea_list.ral_id = r.id
      LEFT JOIN (select ral_id, string_agg('Тип изменения: ' || case when status_type = 'accbf' then 'Аккредитация до 412-ФЗ'
  when status_type = 'acc' then 'Аккредитация'
  when status_type = 'compt' then 'Подтверждение компетенции'
  when status_type = 'sus' and is_partial = true then 'Частичное приостановление действия аккредитации'
  when status_type = 'sus' and is_partial = false then 'Приостановление действия аккредитации'
  when status_type = 'rscp' then 'Сокращение области аккредитации'
  when status_type = 'escp' then 'Расширение области аккредитации'
  end
  || '; Номер решения: ' || coalesce(decision_number, 'нет')
  || '; Дата решения: ' || coalesce(to_char(decision_date, 'dd.mm.yyyy'), 'нет')
  || '; Номер ГУ: ' || coalesce(service_number, 'нет')
  || '; Дата ГУ:  ' || coalesce(to_char(service_date, 'dd.mm.yyyy'), 'нет'), '; '::text) stat_list from
  (select * from ral.basis_status s where status_type in ('accbf', 'acc', 'compt', 'sus', 'rscp', 'escp') and d_end = date '2999-01-01'
   order by decision_date, service_date ) as stat_list
  group by ral_id) as status_list ON status_list.ral_id = r.id
      LEFT JOIN ral.oa_tr tr ON tr.oa_id = roa.id AND tr.d_end = '2999-01-01'::date  AND tr.tr_type in (1, 2)
      LEFT JOIN nsi.dic_norm_doc nd ON nd.id_dic = tr.tr_id::numeric
      LEFT join (select np_inc.ral_id, trim(coalesce('Номер решения: ' || coalesce(np_inc.decision_number, 'Номер ГУ ' || np_inc.service_number), '') || ' ' ||
     coalesce(coalesce(to_char(np_inc.decision_date, 'dd.mm.yyyy'), 'Дата ГУ ' || to_char(np_inc.service_date, 'dd.mm.yyyy')), '') || ' ' || 'Технический регламент ЕАЭС (ТС): ' ||
     string_agg(DISTINCT concat(nd.doc_num, ' ', nd.doc_name), '; '::text)) AS np from ral.national_part np_inc
   LEFT JOIN ral.oa_unstruct oa ON np_inc.id = oa.np_id and oa.d_end = '2999-01-01'::date
   LEFT JOIN ral.oa_tr tr ON tr.oa_id = oa.id AND tr.oa_vers_id = oa.vers_id AND tr.tr_type = 3
   LEFT JOIN nsi.dic_norm_doc nd ON nd.id_dic = tr.tr_id::numeric
  where
  np_inc.type_part = 1 and np_inc.d_end = '2999-01-01'::date
  group by np_inc.ral_id, np_inc.decision_number, np_inc.service_number, np_inc.decision_date,np_inc.service_number,np_inc.service_date
     ) np ON np.ral_id = r.id
     LEFT join (select ral_id, string_agg('Основание: ' || coalesce(vb.short_name, 'нет') || '; Тип: ' || coalesce(vt.s_name, 'нет') || ' Номер решения о проведении: ' || coalesce(rc.act_number, 'нет') ||
   '; Дата решения о проведении: ' || coalesce(to_char(rc.decision_date, 'dd.mm.yyyy'), 'нет') ||
   '; Дата проведения: ' || coalesce(to_char(rc.date_begin, 'dd.mm.yyyy'), 'нет'), '; '::text) as gos_contr from ral.control rc
      LEFT join nsi.dic_verification_basis vb on vb.id_dic = rc.nsi_dverbas_id
      LEFT join nsi.DIC_VERIFICATION_TYPE vt on vt.id_dic = rc.nsi_dvert_id
      where rc.d_end = '2999-01-01'::date
      group by ral_id) gc
  ON gc.ral_id = r.id
     WHERE r.d_end = '2999-01-01'::date
 group by rrs.id_master
 ,rrs.s_name
 ,r.id
 ,abt.full_name
 ,r.reg_number
 ,r.full_name
 ,r.short_name
 ,r.reg_date
 ,r.regnum_end_date
 ,acr.decision_number, acr_b_fz.decision_number--coalesce(acr.decision_number, acr_b_fz.decision_number)
 ,acr.decision_date, acr_b_fz.decision_date --coalesce(acr.decision_date, acr_b_fz.decision_date)
 ,hp.last_name
 ,hp.first_name
 ,hp.middle_name
 ,pa.full_name--Тип заявителя
 ,okopf.s_name
 ,appl.full_name--Полное наименование/ФИО заявителя
 ,appl.short_name--Сокращенное наименование заявителя
 ,appl_per.last_name
 ,appl_per.first_name
 ,appl_per.middle_name
 ,appl.head_post--Должность руководителя заявителя
 ,appl.ogrn--ОГРН/ОГРНИП заявителя
 ,appl.inn) t;

/*РАЛ архивные*/
select ral_id,--Идентификатор (технический)
   s_name,--Статус--2
  abt_full_name, --Тип аккредитованного лица--3
  trim(translate(reg_number, chr(10)||chr(13)||'"',' ')) as reg_number,--Номер аттестата аккредитации--4
  trim(translate(full_name, chr(10)||chr(13)||'"',' ')) as full_name,--Полное наименование аккредитованного лица--5
  trim(translate(short_name, chr(10)||chr(13)||'"',' ')) as short_name,--Сокращенное наименование аккредитованного лица--6
  --r.regnum_begin_date,
  regnum_begin_date,--Дата включения аккредитованного лица в реестр--7
  regnum_end_date, --Срок действия аттестата аккредитации--8
  trim(translate(acr_decision_number, chr(10)||chr(13)||'"',' ')) as acr_decision_number, --Номер приказа об аккредитации--9
  acr_decision_date,--Дата приказа об аккредитаци--10
    acr_decision_number_fz412,--Номер приказа об аккредитации до 412-ФЗ--11
  acr_decision_date_fz412, --Дата приказа об аккредитации до 412-ФЗ--12
  trim(translate(head_fio, chr(10)||chr(13)||'"',' ')) as head_fio,--ФИО руководителя аккредитованного лица--13
  trim(translate(anah_full_address, chr(10)||chr(13)||'"',' ')) as anah_full_address,--Адрес места нахождения аккредитованного лица--14
  trim(translate(tel_fax, chr(10)||chr(13)||'"',' ')) as tel_fax,--15
  trim(translate(email, chr(10)||chr(13)||'"',' ')) as email,--16
  trim(translate(web, chr(10)||chr(13)||'"',' ')) as web,--17
  appl_type_full_name,--Тип заявителя--18
  okopf_name,--Организационно-правовая форма заявителя--19
  trim(translate(app_full_name, chr(10)||chr(13)||'"',' ')) as app_full_name,--Полное наименование/ФИО заявителя--20
  trim(translate(app_short_name, chr(10)||chr(13)||'"',' ')) as app_short_name,--Сокращенное наименование заявителя--21
  trim(translate(appl_per_fio, chr(10)||chr(13)||'"',' ')) as appl_per_fio,--ФИО руководителя заявителя--22
  trim(translate(head_post, chr(10)||chr(13)||'"',' ')) as head_post,--Должность руководителя заявителя--23
  trim(translate(appl_full_address, chr(10)||chr(13)||'"',' ')) as appl_full_address,--Адрес заявителя--24
 -- trim(translate(appl_d_full_address, chr(10)||chr(13)||'"',' ')) as appl_d_full_address,--Адреса мест осуществления деятельности в области аккредитации--25
  trim(translate(appl_tel_fax, chr(10)||chr(13)||'"',' ')) as appl_tel_fax,--Номер телефона заявителя--25
  trim(translate(appl_email, chr(10)||chr(13)||'"',' ')) as appl_email,--Адрес электронной почты заявителя--26
  trim(translate(appl_ogrn, chr(10)||chr(13)||'"',' ')) as appl_ogrn,--ОГРН/ОГРНИП заявителя--27
  trim(translate(appl_inn, chr(10)||chr(13)||'"',' ')) as appl_inn,--ИНН заявителя--28
    null as testing_lab,--Лаборатории, с которыми заключены договора на проведение испытаний для целей сертификации--29
    null as is_testing_base,--Наличие собственной испытательной базы--30
   null as expert_info,--Сведения об экспертах--31
  trim(translate(workers_fio, chr(10)||chr(13)||'"',' ')) as workers_fio,--ФИО работника--32
  trim(translate(oa_desc, chr(10)||chr(13)||'"',' ')) as oa_desc,--Область аккредитации (текстовое описание)--33
  trim(translate(tr_doc_num_doc_name, chr(10)||chr(13)||'"',' ')) as tr_doc_num_doc_name,--Область аккредитации (технические регламенты)--34
  trim(translate(code_tn_ved, chr(10)||chr(13)||'"',' ')) as code_tn_ved,--Область аккредитации (ТН ВЭД)--35
  trim(translate(code_okpd2, chr(10)||chr(13)||'"',' ')) as code_okpd2,--Область аккредитации (ОКПД2)--36
  trim(translate(code_okved2, chr(10)||chr(13)||'"',' ')) as code_okved2,--Область аккредитации (ОКВЭД2)--37
  trim(translate(code_okp, chr(10)||chr(13)||'"',' ')) as code_okp,--Область аккредитации (ОКП)--38
  trim(translate(code_okpd, chr(10)||chr(13)||'"',' ')) as code_okpd,--Область аккредитации (ОКПД)--39
  trim(translate(code_okun, chr(10)||chr(13)||'"',' ')) as code_okun,--Область аккредитации (ОКУН)--40
  trim(translate(expert_list, chr(10)||chr(13)||'"',' ')) as expert_list,--Сведения об экспертных организациях и экспертах, привлекаемых к работам--41
  trim(translate(status_list, chr(10)||chr(13)||'"',' ')) as status_list, --Изменение статуса аккредитованного лица--42
  trim(translate(np_np, chr(10)||chr(13)||'"',' ')) as np_np,--Национальная часть Единого реестра ЕАЭС--43
  trim(translate(gos_contr, chr(10)||chr(13)||'"',' ')) as gos_contr--Государственный контроль--44

from ( select row_number() OVER (ORDER BY r.reg_date) rn--№ п/п
  ,r.id ral_id
  ,rrs.id_master status_id
  ,rrs.s_name--Статус
  ,abt.full_name AS abt_full_name --Тип аккредитованного лица
  ,r.reg_number--Номер аттестата аккредитации
  ,r.full_name--Полное наименование аккредитованного лица
  ,r.short_name--Сокращенное наименование аккредитованного лица
  --r.regnum_begin_date,
  ,r.reg_date as regnum_begin_date--Дата включения аккредитованного лица в реестр
  ,r.regnum_end_date --Срок действия аттестата аккредитации
  ,--coalesce(acr.decision_number, acr_b_fz.decision_number)
  acr.decision_number as acr_decision_number --Номер приказа об аккредитации--9
  ,--coalesce(acr.decision_date, acr_b_fz.decision_date)
  acr.decision_date as acr_decision_date--Дата приказа об аккредитаци --10
   ,acr_b_fz.decision_number as acr_decision_number_fz412 --Номер приказа об аккредитации--11
   ,acr_b_fz.decision_date as acr_decision_date_fz412--Дата приказа об аккредитаци --12
  ,hp.last_name || ' ' || hp.first_name || ' ' || hp.middle_name head_fio--ФИО руководителя аккредитованного лица
  ,substring(string_agg(DISTINCT anah.full_address, '; '::text) from  1 for 32767) as anah_full_address--Адрес места нахождения аккредитованного лица
  ,substring(string_agg(DISTINCT tel_fax.value::text, '; '::text) from  1 for 32767) AS tel_fax
  ,substring(string_agg(DISTINCT email.value::text, '; '::text) from  1 for 32767) AS email
  ,substring(string_agg(DISTINCT web.value::text, '; '::text) from  1 for 32767) AS web
  ,pa.full_name appl_type_full_name--Тип заявителя
  ,okopf.s_name okopf_name--Организационно-правовая форма заявителя
  ,appl.full_name as app_full_name--Полное наименование/ФИО заявителя
  ,appl.short_name as app_short_name--Сокращенное наименование заявителя
  ,appl_per.last_name || ' ' || appl_per.first_name || ' ' || appl_per.middle_name appl_per_fio--ФИО руководителя заявителя
  ,appl.head_post--Должность руководителя заявителя
  ,substring(string_agg(DISTINCT appl_addr.full_address::text, '; '::text) from  1 for 32767) as appl_full_address--Адрес заявителя
  ,substring(string_agg(DISTINCT appl_d_addr.full_address::text, '; '::text) from  1 for 32767) as appl_d_full_address--Адреса мест осуществления деятельности в области аккредитации
  ,substring(string_agg(DISTINCT appl_tel_fax.value::text, '; '::text) from  1 for 32767) AS appl_tel_fax--Номер телефона заявителя
  ,substring(string_agg(DISTINCT appl_email.value::text, '; '::text) from  1 for 32767) AS appl_email--Адрес электронной почты заявителя
  ,appl.ogrn as appl_ogrn--ОГРН/ОГРНИП заявителя
  ,appl.inn as appl_inn--ИНН заявителя
  ,substring(string_agg(DISTINCT worker_fio, '; '::text) from  1 for 32767) as workers_fio--ФИО работника
  ,substring(string_agg(DISTINCT roa.oa_desc, '; '::text) from  1 for 32767) as oa_desc--Область аккредитации (текстовое описание)
  ,substring(string_agg(DISTINCT concat(nd.doc_num, ' ', nd.doc_name), '; '::text) from  1 for 32767) AS tr_doc_num_doc_name--Область аккредитации (технические регламенты)
  ,substring(string_agg(roa.code_tn_ved, '; '::text) from  1 for 32767) as code_tn_ved--Область аккредитации (ТН ВЭД)
  ,substring(string_agg(roa.code_okpd2, '; '::text) from  1 for 32767) as code_okpd2--Область аккредитации (ОКПД2)
  ,substring(string_agg(roa.code_okved2, '; '::text) from  1 for 32767) as code_okved2--Область аккредитации (ОКВЭД2)
  ,substring(string_agg(roa.code_okp, '; '::text) from  1 for 32767) as code_okp--Область аккредитации (ОКП)
  ,substring(string_agg(roa.code_okpd, '; '::text) from  1 for 32767) as code_okpd--Область аккредитации (ОКПД)
  ,substring(string_agg(roa.code_okun, '; '::text) from  1 for 32767) as code_okun--Область аккредитации (ОКУН)
  ,substring(string_agg(ea_list.ea_list, '; '::text) from  1 for 32767) as expert_list--Сведения об экспертных организациях и экспертах, привлекаемых к работам
  ,substring(string_agg(DISTINCT status_list.stat_list, '; '::text) from  1 for 32767) as status_list --Изменение статуса аккредитованного лица
  ,substring(string_agg(np.np, '; '::text) from  1 for 32767) np_np--Национальная часть Единого реестра ЕАЭС
  ,substring(string_agg(DISTINCT gc.gos_contr, '; '::text) from  1 for 32767) gos_contr
 --bs.*
    FROM ral.ral r
      JOIN nsi.dic_accreditation_body_type abt ON abt.id_dic = r.nsi_dabt_id::numeric
    ------------------------------------------------------------------------------------------------------------ПАРАМЕТР - СТАТУСЫ--------------------------
      JOIN nsi.dic_registry_record_status rrs ON r.nsi_drrs_id::numeric = rrs.id_dic AND-- (rrs.id_master::text = ANY(string_to_array('6,14,15,19', ',')))
                                                                 (rrs.id_master::text = ANY(string_to_array('1', ',')))
      --JOIN ral.basis_status bs ON bs.ral_id = r.id AND bs.ral_vers_id = r.vers_id
      LEFT JOIN ral.accreditation acr ON acr.ral_id = r.id AND acr.d_end = '2999-01-01'
      LEFT JOIN ral.accreditation_before_fz_412 acr_b_fz ON acr_b_fz.ral_id = r.id AND acr_b_fz.d_end = '2999-01-01'
      LEFT JOIN ral.person hp ON hp.id = r.head_person_id AND hp.d_end = '2999-01-01'::date
      LEFT JOIN ral.address anah ON  anah.ral_id = r.id AND anah.d_end = '2999-01-01'::date and anah.id_addr_type=3 --and anah.id_addr_type=1
      LEFT JOIN ral.a_p_contacts tel_fax ON tel_fax.ral_id = r.id AND (tel_fax.id_contact_type = ANY (ARRAY[1, 3])) AND tel_fax.d_end = '2999-01-01'::date --tel_fax.ral_id = r.id AND tel_fax.ral_vers_id = r.vers_id AND (tel_fax.id_contact_type = ANY (ARRAY[1, 3]))
      LEFT JOIN ral.a_p_contacts email ON email.ral_id = r.id AND email.id_contact_type = 4 AND email.d_end = '2999-01-01'::date
      LEFT JOIN ral.a_p_contacts web ON web.ral_id = r.id AND web.id_contact_type = 5 AND web.d_end = '2999-01-01'::date
      LEFT JOIN ral.applicant appl ON r.appl_id = appl.id AND appl.d_end = '2999-01-01'::date
      LEFT JOIN nsi.DIC_PROCESS_ACTOR_TYPE pa on pa.id_dic = appl.id_type
      LEFT JOIN nsi.DIC_OKOPF okopf ON okopf.id_dic = appl.id_legal_form or okopf.id_dic = appl.id_kopf
      LEFT JOIN (select al_id, string_agg(DISTINCT trim(w.second_name || ' ' || w.first_name || ' ' || w.patronimyc || ' ' || '('||w.snils||')'), '; '::text) worker_fio
  from ap_rep.worker w where w.al_id is not null
  and w.d_end = '2999-01-01'
  group by al_id) wor on wor.al_id::text = r.id::text
      LEFT JOIN ral.person appl_per ON appl_per.id = appl.id_person AND appl_per.d_end = '2999-01-01'::date
      LEFT JOIN ral.address appl_addr ON appl_addr.appl_id = r.appl_id AND appl_addr.d_end = '2999-01-01'::date and appl_addr.id_addr_type=1
      LEFT JOIN ral.address appl_d_addr ON appl_d_addr.appl_id = r.appl_id AND appl_d_addr.d_end = '2999-01-01'::date and appl_d_addr.id_addr_type=3
      LEFT JOIN ral.appl_contacts appl_tel_fax ON appl_tel_fax.appl_id = appl.id AND (appl_tel_fax.id_contact_type = ANY (ARRAY[1, 3])) AND appl_tel_fax.d_end = '2999-01-01'::date
      LEFT JOIN ral.appl_contacts appl_email ON appl_email.appl_id = appl.id AND appl_email.id_contact_type = 4 AND appl_email.d_end = '2999-01-01'::date
      LEFT JOIN ral.oa_unstruct roa on roa.ral_id = r.id AND roa.d_end = '2999-01-01'::date
      LEFT JOIN (select ral_id,
  string_agg(coalesce(eg.eo_name, 'нет') || '; ' || coalesce(eg.expert_fio, 'нет') || ' (' || coalesce(eg.expert_reg_number, 'нет')|| ')', '; '::text) as ea_list from
  (select  ral_id, eg_id from ral.accreditation
   where d_end = date '2999-01-01'
   and eg_id is not null
   union all
   select  b412.ral_id, er.eg_id from ral.accreditation_before_fz_412 b412
   inner join ral.accr412eg er on b412.id = er.id_accrbfz412
   where b412.d_end = date '2999-01-01' and er.d_end = date '2999-01-01'
   and er.eg_id is not null and b412.ral_id is not null
   union all
   select  ral_id, eg_id from ral.confirm_competence
   where d_end = date '2999-01-01'
   and eg_id is not null
   union all
   select ral_id, eg_id from ral.change_address
   where d_end = date '2999-01-01'
   and eg_id is not null) as ce
  INNER JOIN ral.expert_group eg on ce.eg_id = eg.id and eg.d_end = date '2999-01-01'
  group by ral_id) as ea_list ON ea_list.ral_id = r.id
      LEFT JOIN (select ral_id, string_agg('Тип изменения: ' || case when status_type = 'accbf' then 'Аккредитация до 412-ФЗ'
  when status_type = 'acc' then 'Аккредитация'
  when status_type = 'compt' then 'Подтверждение компетенции'
  when status_type = 'sus' and is_partial = true then 'Частичное приостановление действия аккредитации'
  when status_type = 'sus' and is_partial = false then 'Приостановление действия аккредитации'
  when status_type = 'rscp' then 'Сокращение области аккредитации'
  when status_type = 'escp' then 'Расширение области аккредитации'
  end
  || '; Номер решения: ' || coalesce(decision_number, 'нет')
  || '; Дата решения: ' || coalesce(to_char(decision_date, 'dd.mm.yyyy'), 'нет')
  || '; Номер ГУ: ' || coalesce(service_number, 'нет')
  || '; Дата ГУ:  ' || coalesce(to_char(service_date, 'dd.mm.yyyy'), 'нет'), '; '::text) stat_list from
  (select * from ral.basis_status s where status_type in ('accbf', 'acc', 'compt', 'sus', 'rscp', 'escp') and d_end = date '2999-01-01'
   order by decision_date, service_date ) as stat_list
  group by ral_id) as status_list ON status_list.ral_id = r.id
      LEFT JOIN ral.oa_tr tr ON tr.oa_id = roa.id AND tr.d_end = '2999-01-01'::date  AND tr.tr_type in (1, 2)
      LEFT JOIN nsi.dic_norm_doc nd ON nd.id_dic = tr.tr_id::numeric
      LEFT join (select np_inc.ral_id, trim(coalesce('Номер решения: ' || coalesce(np_inc.decision_number, 'Номер ГУ ' || np_inc.service_number), '') || ' ' ||
     coalesce(coalesce(to_char(np_inc.decision_date, 'dd.mm.yyyy'), 'Дата ГУ ' || to_char(np_inc.service_date, 'dd.mm.yyyy')), '') || ' ' || 'Технический регламент ЕАЭС (ТС): ' ||
     string_agg(DISTINCT concat(nd.doc_num, ' ', nd.doc_name), '; '::text)) AS np from ral.national_part np_inc
   LEFT JOIN ral.oa_unstruct oa ON np_inc.id = oa.np_id and oa.d_end = '2999-01-01'::date
   LEFT JOIN ral.oa_tr tr ON tr.oa_id = oa.id AND tr.oa_vers_id = oa.vers_id AND tr.tr_type = 3
   LEFT JOIN nsi.dic_norm_doc nd ON nd.id_dic = tr.tr_id::numeric
  where
  np_inc.type_part = 1 and np_inc.d_end = '2999-01-01'::date
  group by np_inc.ral_id, np_inc.decision_number, np_inc.service_number, np_inc.decision_date,np_inc.service_number,np_inc.service_date
     ) np ON np.ral_id = r.id
     LEFT join (select ral_id, string_agg('Основание: ' || coalesce(vb.short_name, 'нет') || '; Тип: ' || coalesce(vt.s_name, 'нет') || ' Номер решения о проведении: ' || coalesce(rc.act_number, 'нет') ||
   '; Дата решения о проведении: ' || coalesce(to_char(rc.decision_date, 'dd.mm.yyyy'), 'нет') ||
   '; Дата проведения: ' || coalesce(to_char(rc.date_begin, 'dd.mm.yyyy'), 'нет'), '; '::text) as gos_contr from ral.control rc
      LEFT join nsi.dic_verification_basis vb on vb.id_dic = rc.nsi_dverbas_id
      LEFT join nsi.DIC_VERIFICATION_TYPE vt on vt.id_dic = rc.nsi_dvert_id
      where rc.d_end = '2999-01-01'::date
      group by ral_id) gc
  ON gc.ral_id = r.id
     WHERE r.d_end = '2999-01-01'::date
 group by rrs.id_master
 ,rrs.s_name
 ,r.id
 ,abt.full_name
 ,r.reg_number
 ,r.full_name
 ,r.short_name
 ,r.reg_date
 ,r.regnum_end_date
 ,acr.decision_number, acr_b_fz.decision_number--coalesce(acr.decision_number, acr_b_fz.decision_number)
 ,acr.decision_date, acr_b_fz.decision_date --coalesce(acr.decision_date, acr_b_fz.decision_date)
 ,hp.last_name
 ,hp.first_name
 ,hp.middle_name
 ,pa.full_name--Тип заявителя
 ,okopf.s_name
 ,appl.full_name--Полное наименование/ФИО заявителя
 ,appl.short_name--Сокращенное наименование заявителя
 ,appl_per.last_name
 ,appl_per.first_name
 ,appl_per.middle_name
 ,appl.head_post--Должность руководителя заявителя
 ,appl.ogrn--ОГРН/ОГРНИП заявителя
 ,appl.inn) t;


/*Аккредитованные лица нац.часть*/
select id,
trim(translate(status_full_name, chr(10)||chr(13)||'"',' ')) as status_full_name, trim(translate(s_name, chr(10)||chr(13)||'"',' '))  as s_name,
status_date, trim(translate(full_name, chr(10)||chr(13)||'"',' '))  as full_name, trim(translate(reg_number, chr(10)||chr(13)||'"',' '))  as reg_number,
       regnum_begin_date, regnum_end_date, service_date,
 decision_date_inc,  trim(translate(full_address_ul, chr(10)||chr(13)||'"',' '))  as full_address_ul, trim(translate(full_address_ap, chr(10)||chr(13)||'"',' '))  as full_address_ap,
trim(translate(fio, chr(10)||chr(13)||'"',' ')) as fio, trim(translate(tel_fax, chr(10)||chr(13)||'"',' ')) as tel_fax,
trim(translate(email, chr(10)||chr(13)||'"',' ')) as email, trim(translate(doc_num_doc_name, chr(10)||chr(13)||'"',' ')) as doc_num_doc_name,
trim(translate(tr_tnved_code, chr(10)||chr(13)||'"',' ')) as tr_tnved_code, trim(translate(is_right_str, chr(10)||chr(13)||'"',' ')) as is_right_str
from (select * from ral.ral_unload_exp ('2021-01-24'::date, '2021-01-30'::date)) t;

/*РНЭ*/
select acc.reg_number, acc.blank_number, st.s_name as status_name,
       exp.s_name as expertise, acc.date_of_entry,  acc.accred_begin_date,
       acc.accred_end_date, acc.accred_decision_number, acc.accred_decision_date, o.s_name as legal_form, acc.full_name,
       concat_ws(' ', pers.surname, pers.first_name, pers.patronymic) as head_person, pers.snils as head_person_snils, acc.head_post,
       addr.full_address, cont.phone, cont.fax, cont.email, cont.web, acc.ogrn, acc.inn, acc.kpp, empl.wokers_base,-- empl_comb.wokers_comb,
       case when acc.status_id in (15,19) then susp.decision_number end as sus_decision_number, case when acc.status_id in (15,19) then susp.decision_date end as sus_decision_date,
       case when acc.status_id in (15,19) then susp.suspension_basis end as suspension_basis, case when acc.status_id in (15,19) then susp.date_finish end as sus_date_finish,
       resum.decision_number as res_decision_number, resum.decision_date as res_decision_date,
       case when acc.status_id in (2) then annul.decision_number end as ann_decision_number, case when acc.status_id in (2) then annul.decision_date end as ann_decision_date
from rene.accred_person acc
join nsi.dic_registry_record_status st on acc.status_id::text = st.id_master and id_master not in ('18', '20')
left join rene.ap_nongov_exam ex on ex.accred_person_id = acc.id and ex.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join nsi.dic_ns_expertise_type exp on exp.id_dic = coalesce(ex.nongov_exam_id, /*acc.nongov_exam_id*/ null) and exp.is_actual = 1
left join nsi.dic_okopf o on o.id_dic = acc.legal_form_id
left join rene.person pers on pers.id = acc.head_person_id and pers.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join rene.address addr on addr.accred_person_id = acc.id and addr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join (select accred_person_id,
                  string_agg(case when contact_type_id = 1 then value end, '; ') as phone,
                  string_agg(case when contact_type_id = 3 then value end, '; ') as fax,
                  string_agg(case when contact_type_id = 4 then value end, '; ') as email,
                  string_agg(case when contact_type_id = 5 then value end, '; ') as web
           from rene.ap_contact
           where d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           group by accred_person_id) cont on cont.accred_person_id = acc.id
--left join rene.ap_contact cont_f on cont_f.accred_person_id = acc.id and cont_f.contact_type_id = 3 and cont_f.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join (select emp.accred_person_id,
                  string_agg(concat_ws('; ',  concat_ws(' ', p.surname, p.first_name, p.patronymic), emp.attestate_number, emp.attestate_issue_date, emp.attestate_term_date), '-\\-') as wokers_base
           from rene.employee emp
           join rene.person p on p.id = emp.person_id and p.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
           left join nsi.dic_employment_type tp on tp.id_dic = emp.employment_type_id --and tp.id_master = '1'
           where emp.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
           group by emp.accred_person_id) empl on empl.accred_person_id = acc.id
left join (select emp.accred_person_id,
                  string_agg(concat_ws('; ',  concat_ws(' ', p.surname, p.first_name, p.patronymic), emp.attestate_number, emp.attestate_issue_date, emp.attestate_term_date), '-\\-') as wokers_comb
           from rene.employee emp
           join rene.person p on p.id = emp.person_id and p.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
           join nsi.dic_employment_type tp on tp.id_dic = emp.employment_type_id and tp.id_master in ('2','3')
           where emp.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
           group by emp.accred_person_id) empl_comb on empl_comb.accred_person_id = acc.id
left join (select sus.accred_person_id,
                  sus.decision_date, sus.decision_number, sb.s_name as suspension_basis, sus.date_finish,
                  row_number() over (partition by accred_person_id order by decision_date desc) as rn
           from rene.cert_suspension sus
           left join nsi.dic_ac_nse_suspension_basis sb on sb.id_dic = sus.basis_id
           where sus.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone) susp on susp.accred_person_id = acc.id and susp.rn = 1
left join (select res.accred_person_id,
                  res.decision_date, res.decision_number,
                  row_number() over (partition by accred_person_id order by decision_date desc) as rn
           from rene.cert_resumption res
           where res.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone) resum on resum.accred_person_id = acc.id and resum.rn = 1
left join (select ann.accred_person_id,
                  ann.decision_date, ann.decision_number,
                  row_number() over (partition by accred_person_id order by decision_date desc) as rn
           from rene.cert_annulment ann
           where ann.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone) annul on annul.accred_person_id = acc.id and annul.rn = 1
where acc.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone;

/*РЭО*/
select exp_org.id, trim(translate(coalesce(dk.s_name, exp_org.name_legal_form), chr(10)||chr(13)||'"', '')) as legal_form,
       trim(translate(exp_org.full_name, chr(10)||chr(13)||'"', '')) as full_name, trim(translate(exp_org.short_name, chr(10)||chr(13)||'"', '')) as short_name,
       trim(translate(adres.ard_name, chr(10)||chr(13)||'"', '')) as ard_name,
       trim(translate(cnt_ph.phone, chr(10)||chr(13)||'"', '')) as phones,
       trim(translate(cnt_e.mail, chr(10)||chr(13)||'"', '')) as mail,
       trim(translate(cnt_w.site, chr(10)||chr(13)||'"', '')) as w_site,
       trim(translate(exp_org.inn, chr(10)||chr(13)||'"', '')) as inn,
       trim(translate(exp_org.ogrn, chr(10)||chr(13)||'"', '')) as ogrn,
       trim(translate(nsi_st.s_name, chr(10)||chr(13)||'"', '')) as status,
       trim(translate(exp_org_base.fio, chr(10)||chr(13)||'"', '')) as wokers_base,
       trim(translate(exp_org_comb.fio, chr(10)||chr(13)||'"', '')) as wokers_comb,
       trim(translate(incl.decision_number, chr(10)||chr(13)||'"', '')) as decision_number_incl,
       incl.decision_date decision_date_incl,
       trim(translate(excl.decision_number, chr(10)||chr(13)||'"', '')) as decision_number_excl,
       excl.decision_date as decision_date_excl,
       trim(translate(excl.base_excl, chr(10)||chr(13)||'"', '')) as base_excl
--select *
from reo_rea.expert_organization exp_org
left join nsi.dic_okopf dk on dk.id_dic = exp_org.id_legal_form
join nsi.dic_registry_record_status nsi_st on nsi_st.id_dic = exp_org.id_status and not nsi_st.id_master in ('18','20')
left join (select adr.exp_org_id,
                string_agg(adr.full_address, '; ') as ard_name
           from reo_rea.address adr
           where adr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and adr.id_addr_type = 1
           group by adr.exp_org_id) adres on adres.exp_org_id = exp_org.id
left join (select c.exp_org_id,
                string_agg(c.value, '; ') as phone
           from reo_rea.reo_contact c
           where c.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and c.type_id = 1
           group by c.exp_org_id) cnt_ph on cnt_ph.exp_org_id = exp_org.id
left join (select cc.exp_org_id,
                string_agg(cc.value, '; ') as mail
           from reo_rea.reo_contact cc
           where cc.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and cc.type_id = 4
           group by cc.exp_org_id) cnt_e on cnt_e.exp_org_id = exp_org.id
left join (select cnt.exp_org_id,
                  string_agg(cnt.value, '; ') as site
           from reo_rea.reo_contact cnt
           where cnt.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone and cnt.type_id = 5
           group by cnt.exp_org_id) cnt_w on cnt_w.exp_org_id = exp_org.id
left join (select ii.exp_org_id,
                  ii.decision_number,
                  ii.decision_date
           from
              (select i.exp_org_id,
                    i.decision_number,
                    i.decision_date,
                    row_number() over (partition by i.exp_org_id order by i.decision_date desc) as rn
              from reo_rea.reo_inclusion i
              where i.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone)ii
         where ii.rn = 1)incl on incl.exp_org_id = exp_org.id
left join (select ee.exp_org_id,
                  ee.decision_number,
                  ee.decision_date,
                  ee.base_excl
           from
                (select e.exp_org_id,
                      e.decision_number,
                      e.decision_date,
                      base_excl.s_name as base_excl,
                      row_number() over (partition by e.exp_org_id order by e.decision_date desc) as rn
                from reo_rea.reo_exclusion e
                left join nsi.dic_eo_exclusion_basis base_excl on e.basis_id = base_excl.id_dic
                where e.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone)ee
           where ee.rn = 1)excl on excl.exp_org_id = exp_org.id
left join (select emp.exp_org_id,
                  string_agg(concat_ws(' ', pp.surname, pp.first_name, pp.patronimyc||'('|| lpad(ee.reg_number::text, 5, '0')||')'), '; ')  as fio
          from reo_rea.person pp
          join reo_rea.expert ee on ee.person_id = pp.id
          join reo_rea.employee emp on emp.exp_id = ee.id and emp.id_employment_type = 1
          where pp.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
          and ee.d_end =  '2999-01-01 00:00:00.000000'::timestamp without time zone
          and emp.d_end  =  '2999-01-01 00:00:00.000000'::timestamp without time zone
          group by emp.exp_org_id) exp_org_base on exp_org_base.exp_org_id = exp_org.id
left join (select empl.exp_org_id,
                  string_agg(concat_ws(' ', prs.surname, prs.first_name, prs.patronimyc ||'('|| lpad(expr.reg_number::text, 5, '0')||')'), '; ') as fio
           from reo_rea.person prs
           join reo_rea.expert expr on expr.person_id = prs.id
           join reo_rea.employee empl on empl.exp_id = expr.id and empl.id_employment_type in (2,3)
           where prs.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           and expr.d_end =  '2999-01-01 00:00:00.000000'::timestamp without time zone
           and empl.d_end  =  '2999-01-01 00:00:00.000000'::timestamp without time zone
           group by empl.exp_org_id) exp_org_comb on exp_org_comb.exp_org_id = exp_org.id
where exp_org.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
order by exp_org.id;

/*РЭА*/
select exp.reg_number,
       trim(translate(concat_ws(' ', pers.surname, pers.first_name, pers.patronimyc), chr(10)||chr(13)||'"', '')) as fio,
       trim(translate(pers.snils, chr(10)||chr(13)||'"', '')) as snils, trim(translate(pers.inn, chr(10)||chr(13)||'"', '')) as inn,
       trim(translate(ak_ter.ter_name, chr(10)||chr(13)||'"', '')) as ter_name,
       trim(translate(coalesce(att_sc.attest_scope_type, r_att.type_attest_scope), chr(10)||chr(13)||'"', '')) as type_attest_scope,
       trim(translate(coalesce(att_sc.scope,r_att.scope), chr(10)||chr(13)||'"', '')) as scope,
       trim(translate(att_sc.tech_reg, chr(10)||chr(13)||'"', '')) as tech_reg,
       trim(translate(st_sec.s_name, chr(10)||chr(13)||'"', '')) as access_state_secret,
       trim(translate(nsi_st.s_name, chr(10)||chr(13)||'"', '')) as status_expert,
       to_char(exp.register_date, 'dd.mm.yyyy') as register_date,
       trim(translate(r_att.decision_number, chr(10)||chr(13)||'"', '')) as att_decision_number,
       to_char(r_att.decision_date, 'dd.mm.yyyy') as att_decision_date,
       trim(translate(r_sus.decision_number, chr(10)||chr(13)||'"', '')) as sus_decision_number,
       r_sus.decision_date as sus_decision_date, r_sus.end_date,
       trim(translate(term.decision_number, chr(10)||chr(13)||'"', '')) as term_decision_number, term.decision_date as term_decision_date,
       trim(translate(term.base_stop_att, chr(10)||chr(13)||'"', '')) as base_stop_att,
       trim(translate(exp_org.name_org_base, chr(10)||chr(13)||'"', '')) as name_org_base,
       trim(translate(exp_org_comb.name_org_comb, chr(10)||chr(13)||'"', '')) as name_org_comb
from reo_rea.expert exp
join reo_rea.person pers on exp.person_id = pers.id and pers.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join (select tr.exp_id,
                  string_agg(a.offname, '; ') as ter_name
           from reo_rea.rea_territory tr
            join nsi.dic_fias_addrobj a on tr.id_territory::uuid = a.aoguid::uuid
           where tr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           group by tr.exp_id) ak_ter on ak_ter.exp_id = exp.id
left join (select sc.exp_id,
                  string_agg(distinct (coalesce(ae_p.area_code||' '||ae_p.full_name,ae.area_code||' '||ae.full_name)), '; ') as attest_scope_type,
                  string_agg(distinct (ae.area_code||' '||ae.full_name), '; ') as scope,
                  string_agg(distinct (tr.s_num||' '||tr.s_name), '; ') as tech_reg
           from reo_rea.rea_attestation_scope sc
           left join nsi.dic_accreditation_expert_area ae on ae.id_dic = sc.id_scope
           left join nsi.dic_accreditation_expert_area ae_p on ae_p.id_master = ae.parent_id::varchar(100)
           left join nsi.dic_ea_scope_2_tr_product sc_tr on sc_tr.ea_scope_id = sc.id_scope
           left join nsi.v_techreg tr on tr.techreg_id = sc_tr.techreg_id
           where sc.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           group by sc.exp_id) att_sc on att_sc.exp_id = exp.id
left join reo_rea.gov_access g_acc on g_acc.expert_id = exp.id and g_acc.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join nsi.dic_state_secret_perm_lvl st_sec on st_sec.id_dic = g_acc.form_id
join nsi.dic_registry_record_status nsi_st on nsi_st.id_dic = exp.status_id and not nsi_st.id_master in ('18','20')
left join (select at_d.exp_id, max(at_d.decision_number) as decision_number, max(at_d.decision_date) as decision_date,
                  max(at_d.scope) as scope, max(type_attest_scope) as type_attest_scope
           from (select a.exp_id,
                        first_value(a.decision_number) over (partition by a.exp_id order by  a.decision_date desc) as decision_number,
                        first_value(coalesce(a.decision_date,a.d_begin)) over (partition by a.exp_id order by  a.decision_date desc) as decision_date,
                        ae.s_name as scope,
                        coalesce(ae_p.area_code||' '||ae_p.full_name,ae.area_code||' '||ae.full_name) as type_attest_scope
                 from reo_rea.rea_attestation a
                 left join reo_rea.rea_attest_scope s on a.id = s.att_id
                 left join nsi.dic_accreditation_expert_area ae on ae.id_dic = s.id_scope
                 left join nsi.dic_accreditation_expert_area ae_p on ae_p.id_master = ae.parent_id::varchar(100)
                 where a.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone) at_d
           group by at_d.exp_id) r_att on r_att.exp_id = exp.id
left join (select sus.expert_id, sus.decision_date, sus.end_date, sus.decision_number from
                (select ee.id as expert_id,
                        s.decision_date,
                        s.end_date,
                        s.decision_number,
                        row_number() over (partition by s.expert_id order by s.decision_date desc) as rn
                        from reo_rea.rea_suspension s
                join reo_rea.expert ee on ee.id = s.expert_id  and ee.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                join nsi.dic_registry_record_status r on r.id_dic = ee.status_id and r.id_master = '15'
                where s.d_end ='2999-01-01 00:00:00.000000'::timestamp without time zone)sus
            where sus.rn = 1
            )r_sus on r_sus.expert_id = exp.id
left join (select e.id as expert_id,
                  t.decision_date,
                  t.decision_number,
                  w.s_name as base_stop_att
             from reo_rea.rea_termination t
             join reo_rea.expert e on e.id = t.expert_id  and e.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
             join nsi.dic_registry_record_status r on r.id_dic = e.status_id and r.id_master = '14'
             left join nsi.dic_ac_ea_withdrawal_basis w on w.id_dic = t.basis_id
          where t.d_end ='2999-01-01 00:00:00.000000'::timestamp without time zone) term on term.expert_id = exp.id
left join (select emp_p.exp_id,
                  string_agg(emp_p.full_name, '; ') as name_org_base
           from
              (select emp.exp_id, e.full_name,
                      row_number() over (partition by e.id, emp.exp_id order by e.rev desc) as rn
               from reo_rea.expert_organization e
               join reo_rea.employee emp on emp.exp_org_id = e.id and emp.id_employment_type = 1
               where e.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
               and emp.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
               and e.full_name is not null) emp_p
           where emp_p.rn = 1
           group by emp_p.exp_id) exp_org on exp_org.exp_id = exp.id
left join (select emp_pp.exp_id,
                  string_agg(emp_pp.full_name, '; ') as name_org_comb
           from
               (select emp1.exp_id, e1.full_name,
                       row_number() over (partition by e1.id, emp1.exp_id order by e1.rev desc) as rn
                from reo_rea.expert_organization e1
                join reo_rea.employee emp1 on emp1.exp_org_id = e1.id and emp1.id_employment_type in (2, 3)
                where e1.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                and emp1.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                and e1.full_name is not null) emp_pp
           where emp_pp.rn = 1
           group by emp_pp.exp_id) exp_org_comb on exp_org_comb.exp_id = exp.id
where exp.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
and pers.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
order by pers.surname, pers.first_name, pers.patronimyc;

/*РТЭ*/
select exp.id,  trim(translate(concat_ws(' ', pers.surname, pers.first_name, pers.patronymic), chr(10)||chr(13)||'"', '')) as fio,
       trim(translate(pers.snils, chr(10)||chr(13)||'"', '')) as snils, trim(translate(pers.inn, chr(10)||chr(13)||'"', '')) as inn,
       trim(translate(pc.phones, chr(10)||chr(13)||'"', '')) as phone,
       trim(translate(pc_e.e_mail, chr(10)||chr(13)||'"', '')) as  mail,
       trim(translate(nsi_st.s_name, chr(10)||chr(13)||'"', '')) as status_expert,
       trim(translate(st_sec.s_name, chr(10)||chr(13)||'"', '')) as secret_frm,
       trim(translate(sp_ea.reg_spec, chr(10)||chr(13)||'"', '')) as reg_spec,
       trim(translate(reg_in.decision_number, chr(10)||chr(13)||'"', '')) as decision_number_in,
       reg_in.decision_date as decision_date_in,
       trim(translate(reg_out.decision_number, chr(10)||chr(13)||'"', '')) as decision_number_out,
       reg_out.decision_date as decision_date_out,
       trim(translate(reg_out.base_out, chr(10)||chr(13)||'"', '')) as base_out
from rte.expert exp
join rte.person pers on exp.id_person = pers.id and pers.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join nsi.dic_registry_record_status nsi_st on nsi_st.id_dic = exp.id_status and  nsi_st.id_master not in ('18','20')
left join rte.secret scr on scr.expert_id = exp.id and scr.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join nsi.dic_state_secret_perm_lvl st_sec on st_sec.id_dic = scr.secret_form_id
left join (select p.id_person,
                  string_agg(p.value, '; ') as phones
             from rte.person_contact p
             join nsi.dic_contact_info_type cnt on cnt.id_dic = p.id_contact_type and cnt.id_master in ('1','2','7','9')
            where p.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           group by p.id_person) pc on pc.id_person = pers.id
left join (select pp.id_person,
                  string_agg(pp.value, '; ') as e_mail
             from rte.person_contact pp
             join nsi.dic_contact_info_type cnt_e on cnt_e.id_dic = pp.id_contact_type and cnt_e.id_master in ('4','6')
            where pp.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
           group by pp.id_person) pc_e on pc_e.id_person = pers.id
left join (select reg.id_expert,
                  string_agg(ea.s_name, '; ') as reg_spec
             from rte.regin_specialization e
             join rte.register_in_out reg on reg.id = e.id_regin and reg.register_type = 1
             join nsi.dic_technical_expert_area ea on e.id_spec = ea.id_dic
           where reg.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
             and e.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
          group by reg.id_expert)sp_ea on sp_ea.id_expert = exp.id
left join (select rr.decision_date,
                  rr.decision_number,
                  rr.id_expert
            from
               (select r_in.decision_date,
                      decision_number,
                      r_in.id_expert,
                      row_number() over (partition by r_in.id_expert order by r_in.decision_date desc ) as rn
                 from rte.register_in_out r_in
                where r_in.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                  and r_in.register_type = 1) rr
             where rr.rn = 1)
          reg_in on reg_in.id_expert = exp.id
left join (select rr1.decision_date,
                  rr1.decision_number,
                  rr1.id_expert,
                  rr1.base_out
            from
               (select r_out.decision_date,
                      decision_number,
                      r_out.id_expert,
                      bs.s_name as base_out,
                      row_number() over (partition by r_out.id_expert order by r_out.decision_date desc ) as rn
                 from rte.register_in_out r_out
                    left join nsi.dic_te_exclusion_basis  bs on bs.id_dic = r_out.id_basis
                where r_out.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
                  and r_out.register_type = 2) rr1
             where rr1.rn = 1) reg_out on reg_out.id_expert = exp.id and nsi_st.id_master = '7'
where exp.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
order by pers.surname, pers.first_name, pers.patronymic;


