/*Основные сведения ДС с предписаниями*/
select
  d.id, public_date,  d.decl_reg_number, decl_status,  d.decl_type_name,  d.decl_reg_date,  d.decl_end_date, decl_obj_type, product_origin,
  pg_info, pt_name, product_descr, nd_name,  d.co_full_name, co_attestat_reg_number, protocol_descr, tl_basis, appl_declarant, appl_subject_type, applicant_ogrn, applicant_inn, ap_full_name,
  manufacturer_subject_type, manufacturer_ogrn, manufacturer_inn, manufacturer_name
from dossier.mv_rds_declaration d
where object_type_id in (2,3)
and d.id in
(select dcl.id
from rds.co_dc dcl
join rds.decl_change_status ch on ch.declaration_id = dcl.id and ch.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join (select *
      from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=rssrds',
      $$
      select id_dcs, doc_date,doc_name,doc_number,foiv_management_name,id_foiv,id_type,issue_date,lettet_comment,letter_date,
      letter_number,receipt_date,violation_end_date,id_subject
      from rds.t_prescription;
      $$)
      t(id_dcs integer, doc_date date,doc_name varchar(500),doc_number varchar(50),foiv_management_name varchar(500),id_foiv varchar(7),id_type integer,
      issue_date date,lettet_comment varchar(500),letter_date date,letter_number varchar(50),receipt_date date,violation_end_date date,id_subject uuid)
      )pres on pres.id_dcs = ch.id
left join nsi.dic_okogu o on o.id_dic = pres.id_foiv
left join nsi.dic_dc_prescript_type pr_type on pr_type.id_dic = pres.id_type
left join nsi.dic_cc_dc_change_reason rsn on rsn.id_master::integer = ch.basis_id
left join nsi.dic_fias_addrobj fao on fao.aoguid::text = pres.id_subject::text and fao.aolevel = 1
where pres.issue_date between '01.01.2021'::date and '31.01.2021'::date
and id_type = 2
and ch.status_id = 5)
order by public_date desc;

/*Протоколы ДС с предписаниями*/
select d.id, d.public_date, d.decl_reg_number, d.st_name, d.decl_type_name, d.decl_reg_date, reg_number, tl_name, tl_begin_date,
   is_accred_eec,
       country_name, decl_num, protocol_number, protocol_date, is_file_scan, standardt_names, c_org_name, c_org_reg_num
  from dossier.mv_rds_protocol d
where d.id in
(select dcl.id
from rds.co_dc dcl
join rds.decl_change_status ch on ch.declaration_id = dcl.id and ch.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join (select *
      from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=rssrds',
      $$
      select id_dcs, doc_date,doc_name,doc_number,foiv_management_name,id_foiv,id_type,issue_date,lettet_comment,letter_date,
      letter_number,receipt_date,violation_end_date,id_subject
      from rds.t_prescription;
      $$)
      t(id_dcs integer, doc_date date,doc_name varchar(500),doc_number varchar(50),foiv_management_name varchar(500),id_foiv varchar(7),id_type integer,
      issue_date date,lettet_comment varchar(500),letter_date date,letter_number varchar(50),receipt_date date,violation_end_date date,id_subject uuid)
      )pres on pres.id_dcs = ch.id
where pres.issue_date between '01.01.2021'::date and '31.01.2021'::date
and id_type = 2
and ch.status_id = 5)
order by public_date desc;

/*Продукция ДС с предписаниями*/
select d.id, public_date, d.decl_reg_number, d.st_name, d.decl_type_name,  d.decl_reg_date, is_russian, pg_name, pt_name, marking, usage_scope, storage_conditions,
       usage_conditions, batch_size, batch_id, name, type, trade_mark, model, article, sort, life_time, storage_time, amount, factory_number,
       production_date, expiry_date, gtin_code, doc_names, standart_names
from dossier.mv_rds_product d
where object_type_id in (2,3)
and d.id in
(select dcl.id
from rds.co_dc dcl
join rds.decl_change_status ch on ch.declaration_id = dcl.id and ch.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join (select *
      from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=rssrds',
      $$
      select id_dcs, doc_date,doc_name,doc_number,foiv_management_name,id_foiv,id_type,issue_date,lettet_comment,letter_date,
      letter_number,receipt_date,violation_end_date,id_subject
      from rds.t_prescription;
      $$)
      t(id_dcs integer, doc_date date,doc_name varchar(500),doc_number varchar(50),foiv_management_name varchar(500),id_foiv varchar(7),id_type integer,
      issue_date date,lettet_comment varchar(500),letter_date date,letter_number varchar(50),receipt_date date,violation_end_date date,id_subject uuid)
      )pres on pres.id_dcs = ch.id
left join nsi.dic_okogu o on o.id_dic = pres.id_foiv
left join nsi.dic_dc_prescript_type pr_type on pr_type.id_dic = pres.id_type
left join nsi.dic_cc_dc_change_reason rsn on rsn.id_master::integer = ch.basis_id
left join nsi.dic_fias_addrobj fao on fao.aoguid::text = pres.id_subject::text and fao.aolevel = 1
where pres.issue_date between '01.01.2021'::date and '31.01.2021'::date
and id_type = 2
and ch.status_id = 5)
order by public_date desc;

/*Предписания ДС с предписаниями*/
select dcl.id,
       dcl.public_date::date as public_date,
       trim(translate(decl_reg_number, chr(10) || chr(13) || '"', '')) as decl_reg_number,
       trim(translate(st_name, chr(10) || chr(13) || '"', '')) as st_name,
       trim(translate(decl_type_name, chr(10) || chr(13) || '"', '')) as decl_type_name,
       decl_reg_date,
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
from rds.co_dc dcl
join rds.decl_change_status ch on ch.declaration_id = dcl.id and ch.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join (select *
      from public.dblink('host=10.250.75.11 user=ibs_read password=aSJzMVWrh4RuwE dbname=rssrds',
      $$
      select id_dcs, doc_date,doc_name,doc_number,foiv_management_name,id_foiv,id_type,issue_date,lettet_comment,letter_date,
      letter_number,receipt_date,violation_end_date,id_subject
      from rds.t_prescription;
      $$)
      t(id_dcs integer, doc_date date,doc_name varchar(500),doc_number varchar(50),foiv_management_name varchar(500),id_foiv varchar(7),id_type integer,
      issue_date date,lettet_comment varchar(500),letter_date date,letter_number varchar(50),receipt_date date,violation_end_date date,id_subject uuid)
      )pres on pres.id_dcs = ch.id
left join nsi.dic_okogu o on o.id_dic = pres.id_foiv
left join nsi.dic_dc_prescript_type pr_type on pr_type.id_dic = pres.id_type
left join nsi.dic_cc_dc_change_reason rsn on rsn.id_master::integer = ch.basis_id
left join nsi.dic_fias_addrobj fao on fao.aoguid::text = pres.id_subject::text and fao.aolevel = 1
where pres.issue_date between '01.01.2021'::date and '31.01.2021'::date
and id_type = 2
and ch.status_id = 5
order by public_date desc;

--ОТКРЫТЫЕ ДАННЫЕ
--1.1.  РАЛ ИЛ
select
tt.id as npp,
      trim(translate(tt.full_name, chr(10)||chr(13)||'"', '')) as fullname,
      trim(translate(tt.reg_number, chr(10)||chr(13)||'"', '')) as att_nom,
      tt.regnum_begin_date as data_reg,
      tt.regnum_end_date as srok_okon_att,
      trim(translate(tt.full_address_ul, chr(10)||chr(13)||'"', '')) as u_adr,
      trim(translate(tt.full_address_ap, chr(10)||chr(13)||'"', '')) as f_adr,
      trim(translate(tt.fio, chr(10)||chr(13)||'"', '')) as fio_ruk,
      trim(translate(tt.tel_fax, chr(10)||chr(13)||'"', '')) as tel,
      trim(translate(tt.email, chr(10)||chr(13)||'"', '')) as email,
      trim(translate(tt.tr_doc_num_doc_name, chr(10)||chr(13)||'"', '')) as oblast,
      trim(translate(tt.code_tn_ved, chr(10)||chr(13)||'"', '')) as tn_ved_ts
from
(SELECT
    r.id,
    r.appl_id,
    abt.full_name AS status_full_name,
    r.full_name,
    r.reg_number,
    r.regnum_begin_date,
    r.regnum_end_date,
    np_inc.service_date,
    np_inc.decision_date AS decision_date_inc,
    string_agg(DISTINCT a.full_address::text, '| '::text) AS full_address_ul,
    string_agg(DISTINCT ap.full_address::text, '| '::text) AS full_address_ap,
    concat(pers.last_name, ' ', pers.first_name, ' ', pers.middle_name) AS fio,
    string_agg(DISTINCT tel_fax.value::text, '; '::text) AS tel_fax,
    string_agg(DISTINCT email.value::text, '; '::text) AS email,
    first_value(concat(nd.doc_num, ' ', nd.doc_name) ) over (partition by r.id order by np_inc.service_date desc) as tr_doc_num_doc_name,
    first_value(roa.code_tn_ved) over (partition by r.id order by np_inc.service_date desc) as code_tn_ved,
    row_number() over (partition by r.id order by np_inc.service_date desc) as rn,
    string_agg(DISTINCT
        CASE
            WHEN oa.is_right THEN '��'::text
            ELSE '���'::text
        END, '; '::text) AS is_right_str
   FROM ral.ral r
     JOIN nsi.dic_accreditation_body_type abt ON abt.id_dic = r.nsi_dabt_id::numeric
      AND abt.id_master in ('17','20','21')
     JOIN nsi.dic_registry_record_status rrs ON r.nsi_drrs_id::numeric = rrs.id_dic AND rrs.id_master in ('6', '15', '19')
    -- JOIN ral.basis_status bs ON bs.ral_id = r.id AND bs.d_end = '2999-01-01'::date AND bs.status_type::text = 'term'::text
     join ral.national_part np_inc ON np_inc.ral_id = r.id and np_inc.d_end = '2999-01-01'::date
     LEFT JOIN ral.national_part np_exc ON np_exc.type_part = 2 AND np_exc.ral_vers_id = r.vers_id AND np_exc.ral_id = r.id
     LEFT JOIN ral.address a ON r.appl_id = a.appl_id AND a.d_end = '2999-01-01'::date
     LEFT JOIN ral.address ap ON r.id = ap.ral_id AND ap.d_end = '2999-01-01'::date
     LEFT JOIN ral.person pers ON pers.id = r.head_person_id AND pers.d_end = '2999-01-01'::date
     LEFT JOIN ral.a_p_contacts tel_fax ON tel_fax.ral_id = r.id AND (tel_fax.id_contact_type = ANY (ARRAY[1, 3])) AND tel_fax.d_end = '2999-01-01'::date
     LEFT JOIN ral.a_p_contacts email ON email.ral_id = r.id AND email.id_contact_type = 4 AND email.d_end = '2999-01-01'::date
     LEFT JOIN ral.oa_unstruct oa ON np_inc.id = oa.np_id and oa.d_end = '2999-01-01'::date
     LEFT JOIN ral.oa_tr tr ON tr.oa_id = oa.id AND tr.oa_vers_id = oa.vers_id AND tr.tr_type = 3
     LEFT JOIN nsi.dic_norm_doc nd ON nd.id_dic = tr.tr_id::numeric
     LEFT JOIN ral.oa_unstruct roa ON np_inc.ral_id = roa.ral_id and roa.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
  WHERE r.d_end = '2999-01-01'::date
  GROUP BY abt.full_name, rrs.s_name, rrs.id_master, r.d_begin, r.full_name, r.reg_number, r.regnum_begin_date,
 r.regnum_end_date, np_inc.service_date, np_inc.decision_date, (concat(pers.last_name, ' ',
 pers.first_name, ' ', pers.middle_name)), r.id, r.appl_id,concat(nd.doc_num, ' ', nd.doc_name),roa.code_tn_ved) tt
where tt.rn = 1;

--1.2. РАЛ ОС
select
tt.id as npp,
      trim(translate(tt.full_name, chr(10)||chr(13)||'"', '')) as fullname,
      trim(translate(tt.reg_number, chr(10)||chr(13)||'"', '')) as att_nom,
      tt.regnum_begin_date as data_reg,
      tt.regnum_end_date as srok_okon_att,
      trim(translate(tt.full_address_ul, chr(10)||chr(13)||'"', '')) as u_adr,
      trim(translate(tt.full_address_ap, chr(10)||chr(13)||'"', '')) as f_adr,
      trim(translate(tt.fio, chr(10)||chr(13)||'"', '')) as fio_ruk,
      trim(translate(tt.tel_fax, chr(10)||chr(13)||'"', '')) as tel,
      trim(translate(tt.email, chr(10)||chr(13)||'"', '')) as email,
      trim(translate(tt.tr_doc_num_doc_name, chr(10)||chr(13)||'"', '')) as oblast,
      trim(translate(tt.code_tn_ved, chr(10)||chr(13)||'"', '')) as tn_ved_ts
from
(SELECT
    r.id,
    r.appl_id,
    abt.full_name AS status_full_name,
    r.full_name,
    r.reg_number,
    r.regnum_begin_date,
    r.regnum_end_date,
    np_inc.service_date,
    np_inc.decision_date AS decision_date_inc,
    string_agg(DISTINCT a.full_address::text, '| '::text) AS full_address_ul,
    string_agg(DISTINCT ap.full_address::text, '| '::text) AS full_address_ap,
    concat(pers.last_name, ' ', pers.first_name, ' ', pers.middle_name) AS fio,
    string_agg(DISTINCT tel_fax.value::text, '; '::text) AS tel_fax,
    string_agg(DISTINCT email.value::text, '; '::text) AS email,
    first_value(concat(nd.doc_num, ' ', nd.doc_name) ) over (partition by r.id order by np_inc.service_date desc) as tr_doc_num_doc_name,
    first_value(roa.code_tn_ved) over (partition by r.id order by np_inc.service_date desc) as code_tn_ved,
    row_number() over (partition by r.id order by np_inc.service_date desc) as rn,
    string_agg(DISTINCT
        CASE
            WHEN oa.is_right THEN '��'::text
            ELSE '���'::text
        END, '; '::text) AS is_right_str
   FROM ral.ral r
     JOIN nsi.dic_accreditation_body_type abt ON abt.id_dic = r.nsi_dabt_id::numeric
      AND abt.id_master in ('11','10','12','13','14')
     JOIN nsi.dic_registry_record_status rrs ON r.nsi_drrs_id::numeric = rrs.id_dic AND rrs.id_master in ('6','15', '19')
    -- JOIN ral.basis_status bs ON bs.ral_id = r.id AND bs.d_end = '2999-01-01'::date AND bs.status_type::text = 'term'::text
     join ral.national_part np_inc ON np_inc.ral_id = r.id and np_inc.d_end = '2999-01-01'::date
     LEFT JOIN ral.national_part np_exc ON np_exc.type_part = 2 AND np_exc.ral_vers_id = r.vers_id AND np_exc.ral_id = r.id
     LEFT JOIN ral.address a ON r.appl_id = a.appl_id AND a.d_end = '2999-01-01'::date
     LEFT JOIN ral.address ap ON r.id = ap.ral_id AND ap.d_end = '2999-01-01'::date
     LEFT JOIN ral.person pers ON pers.id = r.head_person_id AND pers.d_end = '2999-01-01'::date
     LEFT JOIN ral.a_p_contacts tel_fax ON tel_fax.ral_id = r.id AND (tel_fax.id_contact_type = ANY (ARRAY[1, 3])) AND tel_fax.d_end = '2999-01-01'::date
     LEFT JOIN ral.a_p_contacts email ON email.ral_id = r.id AND email.id_contact_type = 4 AND email.d_end = '2999-01-01'::date
     LEFT JOIN ral.oa_unstruct oa ON np_inc.id = oa.np_id and oa.d_end = '2999-01-01'::date
     LEFT JOIN ral.oa_tr tr ON tr.oa_id = oa.id AND tr.oa_vers_id = oa.vers_id AND tr.tr_type = 3
     LEFT JOIN nsi.dic_norm_doc nd ON nd.id_dic = tr.tr_id::numeric
     LEFT JOIN ral.oa_unstruct roa ON np_inc.ral_id = roa.ral_id and roa.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
  WHERE r.d_end = '2999-01-01'::date
  GROUP BY abt.full_name, rrs.s_name, rrs.id_master, r.d_begin, r.full_name, r.reg_number, r.regnum_begin_date,
 r.regnum_end_date, np_inc.service_date, np_inc.decision_date, (concat(pers.last_name, ' ',
 pers.first_name, ' ', pers.middle_name)), r.id, r.appl_id,concat(nd.doc_num, ' ', nd.doc_name),roa.code_tn_ved) tt
where tt.rn = 1;

--1.3. РДС
select d.id as ID_decl,
       d.decl_reg_number as reg_number,
       decl_status as Decl_status,
       decl_type_name as Decl_type,
       d.decl_reg_date as date_beginning,
       d.decl_end_date as date_finish,
       s.scheme_code as declaration_scheme,
       decl_obj_type as product_object_type_decl,
       product_origin as product_type,
       pg_info as  product_group,
       pt_name as product_name,
       product_descr asproduct_info,
      nd_name as product_tech_reg,
      co_full_name as organ_to_certification_name,
      co_attestat_reg_number as organ_to_certification_reg_number,
      protocol_descr as basis_for_decl,
      tl_basis as  old_basis_for_decl,
      appl_declarant as  applicant_type,
      appl_subject_type as person_applicant_type,
      applicant_ogrn as  applicant_ogrn,
      applicant_inn as applicant_inn,
      ap_full_name as applicant_name,
      manufacturer_subject_type as manufacturer_type,
      manufacturer_ogrn,
      manufacturer_inn,
      manufacturer_name
from dossier.mv_rds_declaration_mnf d
left join nsi.dic_validation_scheme s on s.id_dic = d.id_decl_scheme
where object_type_id in (2,3)
and decl_reg_date between '01.01.2021'::date and '31.01.2021'::date
order by d.decl_reg_date desc;


--1.4. РСС
select id as id_cert, status_name as cert_status, conformity_doc_kind_brief_name as cert_type, doc_number as reg_number, cert_reg_date as date_begining, cert_end_date as date_finish,
       scheme_code as product_scheme, obj_type_name as product_object_type_cert, orign as product_type, okpd_code as product_okpd2, tnved_code as product_tn_ved,
       nd_name as product_tech_reg, product_group as product_group, pt_name as product_name, product_group_info as product_info, apl_type as applicant_type, apl_act_type as person_applicant_type,
       apl_ogrn as applicant_ogrn, apl_inne as applicant_inn, apl_cn_tel as applicant_phone, apl_cn_fax as applicant_fax, apl_cn_email as applicant_email, apl_cn_www as applicant_website,
       apl_full_name as  applicant_name, apl_head_name as applicant_director_name, apl_adr_actual as applicant_address, apl_adr_active as applicant_address_actual, mnf_act_type as manufacturer_type,
       mnf_ogrn as manufacturer_ogrn, mnf_inn as manufacturer_inn, mnf_cn_tel as  manufacturer_phone, mnf_cn_fax as manufacturer_fax, mnf_cn_email as manufacturer_email,
       mnf_cn_www as manufacturer_website, mnf_full_name as  manufacturer_name, mnf_head_name as  manufacturer_director_name, mnf_adr_country as manufacturer_country, mnf_adr_actual as manufacturer_address,
       mnf_adr_active as manufacturer_address_actual, filial_code as manufacturer_address_filial, c_org_name as  organ_to_certification_name, c_org_reg_number as organ_to_certification_reg_number,
       c_org_head_name as organ_to_certification_head_name, tl_code as basis_for_certificate, tl_basis as old_basis_for_certificate, exp_code as fio_expert, signer_function as fio_signatory,
       pt_stnd as product_national_standart, act_analize as production_analysis_for_act, number_act_analize as production_analysis_for_act_number, date_act_analize as  production_analysis_for_act_date
from dossier.mv_rss_certificate_os
where first_begin_date  between '01.01.2020'::date and '31.01.2020'::date
order by first_begin_date desc;


--1.5. РНЭ
select acc.reg_number, acc.blank_number, st.s_name as status_name,
       exp.s_name as expertise, acc.date_of_entry,  acc.accred_begin_date,
       acc.accred_end_date, acc.accred_decision_number, acc.accred_decision_date, o.s_name as legal_form, acc.full_name,
       concat_ws(' ', pers.surname, pers.first_name, pers.patronymic) as head_person, acc.head_post,
       addr.full_address, cont.phone, cont.fax, cont.email, cont.web, acc.ogrn, acc.inn, acc.kpp, empl.wokers_base,-- empl_comb.wokers_comb, нет информации
       case when acc.status_id in (15,19) then susp.decision_number end as sus_decision_number, case when acc.status_id in (15,19) then susp.decision_date end as sus_decision_date,
       case when acc.status_id in (15,19) then susp.suspension_basis end as suspension_basis, case when acc.status_id in (15,19) then susp.date_finish end as sus_date_finish,
       resum.decision_number as res_decision_number, resum.decision_date as res_decision_date,
       case when acc.status_id in (2) then annul.decision_number end as ann_decision_number, case when acc.status_id in (2) then annul.decision_date end as ann_decision_date
from rene.accred_person acc
join nsi.dic_registry_record_status st on acc.status_id::text = st.id_master and id_master not in ('18', '20')
left join rene.ap_nongov_exam ex on ex.accred_person_id = acc.id and ex.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
left join nsi.dic_ns_expertise_type exp on exp.id_dic = coalesce(ex.nongov_exam_id, null/*acc.nongov_exam_id*/) and exp.is_actual = 1
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

left join (select emp.accred_person_id,
                  string_agg(concat_ws('; ',  concat_ws(' ', p.surname, p.first_name, p.patronymic), emp.attestate_number, emp.attestate_issue_date, emp.attestate_term_date), '-\\-') as wokers_base
           from rene.employee emp
           join rene.person p on p.id = emp.person_id and p.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
           join nsi.dic_employment_type tp on tp.id_dic = emp.employment_type_id --and tp.id_master = '1' пока нет информации о разделении основное место работы / по совместительству
           where emp.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
           group by emp.accred_person_id) empl on empl.accred_person_id = acc.id

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
where acc.d_end = '2999-01-01 00:00:00.000000' :: timestamp without time zone
order by acc.date_of_entry desc;


--1.6. РТЭ
select
       trim(translate(concat_ws(' ', pers.surname, pers.first_name, pers.patronymic), chr(10)||chr(13)||'"', '')) as fio,
       trim(translate(pc.phones, chr(10)||chr(13)||'"', '')) as phonex,
       trim(translate(pc_e.e_mail, chr(10)||chr(13)||'"', '')) as  email,
       trim(translate(nsi_st.s_name, chr(10)||chr(13)||'"', '')) as status,
       trim(translate(sp_ea.reg_spec, chr(10)||chr(13)||'"', '')) as obl_spets,
       trim(translate(reg_in.decision_number, chr(10)||chr(13)||'"', '')) as akkred_order_num,
       reg_in.decision_date as akkred_order_dat,
       trim(translate(reg_out.decision_number, chr(10)||chr(13)||'"', '')) as off_order_num,
       reg_out.decision_date as off_order_dat
  from rte.expert exp
join rte.person pers on exp.id_person = pers.id and pers.d_end = '2999-01-01 00:00:00.000000'::timestamp without time zone
join nsi.dic_registry_record_status nsi_st on nsi_st.id_dic = exp.id_status and not nsi_st.id_master in ('18','20')
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


--1.7. РЭА
select trim(translate(concat_ws(' ', pers.surname, pers.first_name, pers.patronimyc), chr(10)||chr(13)||'"', '')) as fio,
       trim(translate(ak_ter.ter_name, chr(10)||chr(13)||'"', '')) as ter_name,
       trim(translate(att_sc.attest_scope_type, chr(10)||chr(13)||'"', '')) as type_attest_scope,
       trim(translate(coalesce(att_sc.scope,r_att.scope), chr(10)||chr(13)||'"', '')) as scope,
       trim(translate(att_sc.tech_reg, chr(10)||chr(13)||'"', '')) as tech_reg,
       trim(translate(nsi_st.s_name, chr(10)||chr(13)||'"', '')) as status_expert,
       exp.reg_number,
       to_char(exp.register_date, 'dd.mm.yyyy') as register_date,
       trim(translate(r_att.decision_number, chr(10)||chr(13)||'"', '')) as att_decision_number,
       to_char(r_att.decision_date, 'dd.mm.yyyy') as att_decision_date,
       trim(translate(r_sus.decision_number, chr(10)||chr(13)||'"', '')) as sus_decision_number,
       r_sus.decision_date as sus_decision_date,
       trim(translate(term.decision_number, chr(10)||chr(13)||'"', '')) as term_decision_number,
       term.decision_date as term_decision_date,
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
                  string_agg(distinct (coalesce(ae_p.area_code||' '||ae_p.full_name, ae.area_code||' '||ae.full_name)), '; ') as attest_scope_type,
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
                  max(at_d.scope) as scope
           from (select a.exp_id,
                        first_value(a.decision_number) over (partition by a.exp_id order by  a.decision_date desc) as decision_number,
                        first_value(coalesce(a.decision_date,a.d_begin)) over (partition by a.exp_id order by  a.decision_date desc) as decision_date,
                        ae.s_name as scope
                 from reo_rea.rea_attestation a
                 left join reo_rea.rea_attest_scope s on a.id = s.att_id
                 left join nsi.dic_accreditation_expert_area ae on ae.id_dic = s.id_scope
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

--1.8. РЭО
select exp_org.id, trim(translate(coalesce(dk.s_name, exp_org.name_legal_form), chr(10)||chr(13)||'"', '')) as legal_form,
       trim(translate(exp_org.full_name, chr(10)||chr(13)||'"', '')) as full_name,
       trim(translate(exp_org.short_name, chr(10)||chr(13)||'"', '')) as short_name,
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
       excl.decision_date as decision_date_excl
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

--РАЛ
DROP FUNCTION ral.act_ral_open_data_unload();
CREATE OR REPLACE FUNCTION ral.act_ral_open_data_unload()
  RETURNS TABLE("Status" character varying(200), "Type_AL" character varying(200), "Reg_number" character varying(100), "On_reg_dat" date,
   "Akkred_order_num" character varying(100), "Akkred_order_dat" date, "Full name_AL" character varying(1100),
   "Short name_AL" character varying(1100), "FIO_ruk_AL" text, "Address_AL" text, "Phone_AL" text, "Email_AL" text,
   "Website_AL" text, "Obl_akk_AL" text, "Obl_akk_AL_TR" text, "Obl_akk_AL_TNVED" text, "Obl_akk_AL_OKPD2" text,
   "Obl_akk_AL_OKVED2" text, "Akkred_exp" text, "Izm_att_akk" text, "TS" text, "GK" text, "Type_AP" character varying(100),
   "OPF_AP" character varying(200), "Full_name_AP" character varying(1000), "Short name_AP" character varying(1000),
   "FIO_ruk_AP" text, "Address_AP" text, "Phone_AP" text, "Email_AP" text, "OGRN/OGRNIP_AP" character varying(20),
   "INN_AP" character varying(13)
) AS
$BODY$

   select rrs.s_name as "Status"--Статус
   ,abt.full_name AS "Type_AL" --Тип аккредитованного лица
   ,r.reg_number as "Reg_number"--Номер аттестата аккредитации
   ,r.reg_date as "On_reg_dat"--Дата включения аккредитованного лица в реестр
   --,r.regnum_begin_date as "On_reg_dat"--Дата включения аккредитованного лица в реестр
   ,coalesce(acr.decision_number, acr_b_fz.decision_number) as "Akkred_order_num" --Номер приказа об аккредитации
   ,coalesce(acr.decision_date, acr_b_fz.decision_date) as "Akkred_order_dat"--Дата приказа об аккредитаци
   ,r.full_name as "Full name_AL"--Полное наименование аккредитованного лица
   ,r.short_name as "Short name_AL"--Сокращенное наименование аккредитованного лица
   ,hp.last_name || ' ' || hp.first_name || ' ' || hp.middle_name as "FIO_ruk_AL"--ФИО руководителя аккредитованного лица
   ,substring(string_agg(DISTINCT anah.full_address, '; '::text) from  1 for 32767) AS "Address_AL"--Адрес места нахождения аккредитованного лица
   ,substring(string_agg(DISTINCT tel_fax.value::text, '; '::text) from  1 for 32767) AS "Phone_AL"
   ,substring(string_agg(DISTINCT email.value::text, '; '::text) from  1 for 32767) AS "Email_AL"
   ,substring(string_agg(DISTINCT web.value::text, '; '::text) from  1 for 32767) AS "Website_AL"
   ,substring(string_agg(DISTINCT roa.oa_desc, '; '::text) from  1 for 32767) as "Obl_akk_AL"--Область аккредитации (текстовое описание)
   ,substring(string_agg(DISTINCT concat(nd.doc_num, ' ', nd.doc_name), '; '::text) from  1 for 32767) AS "Obl_akk_AL_TR"--Область аккредитации (технические регламенты)
   ,substring(string_agg(roa.code_tn_ved, '; '::text) from  1 for 32767) as "Obl_akk_AL_TNVED"--Область аккредитации (ТН ВЭД)
   ,substring(string_agg(roa.code_okpd2, '; '::text) from  1 for 32767) as "Obl_akk_AL_OKPD2"--Область аккредитации (ОКПД2)
   ,substring(string_agg(roa.code_okved2, '; '::text) from  1 for 32767) as "Obl_akk_AL_OKVED2"--Область аккредитации (ОКВЭД2)
   ,substring(string_agg(ea_list.ea_list, '; '::text) from  1 for 32767) as "Akkred_exp"
   ,substring(string_agg(status_list.stat_list, '; '::text) from  1 for 32767) as "Izm_att_akk"
   ,substring(string_agg(np.np, '; '::text) from  1 for 32767) as "TS"--Национальная часть Единого реестра ЕАЭС
   ,substring(string_agg(gc.gos_contr, '; '::text) from  1 for 32767) "GK"
   ,pa.full_name as "Type_AP"--Тип заявителя
   ,okopf.s_name as "OPF_AP"--Организационно-правовая форма заявителя
   ,appl.full_name as "Full_name_AP"--Полное наименование/ФИО заявителя
   ,appl.short_name as "Short name_AP"--Сокращенное наименование заявителя
   ,appl_per.last_name || ' ' || appl_per.first_name || ' ' || appl_per.middle_name as "FIO_ruk_AP"--ФИО руководителя заявителя
   ,substring(string_agg(DISTINCT appl_addr.full_address::text, '; '::text) from  1 for 32767) AS "Address_AP"--Адрес заявителя
   ,substring(string_agg(DISTINCT appl_tel_fax.value::text, '; '::text) from  1 for 32767) AS "Phone_AP"--Номер телефона заявителя
   ,substring(string_agg(DISTINCT appl_email.value::text, '; '::text) from  1 for 32767) AS "Email_AP"--Адрес электронной почты заявителя
   ,appl.ogrn as "OGRN/OGRNIP_AP"--ОГРН/ОГРНИП заявителя
   ,appl.inn as "INN_AP"--ИНН заявителя
   --bs.*
      FROM ral.ral r
        JOIN nsi.dic_accreditation_body_type abt ON abt.id_dic = r.nsi_dabt_id::numeric
        JOIN nsi.dic_registry_record_status rrs ON r.nsi_drrs_id::numeric = rrs.id_dic AND (rrs.id_master::text not in ('1', '20'))--Исключить Архивный, Черновик
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
   --,r.regnum_begin_date
   ,r.reg_date
   ,r.regnum_end_date
   ,coalesce(acr.decision_number, acr_b_fz.decision_number)
   ,coalesce(acr.decision_date, acr_b_fz.decision_date)
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
   ,appl.inn--ИНН заявителя
   ORDER BY r.reg_date
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION ral.act_ral_open_data_unload() OWNER TO datamart;
select * from ral.act_ral_open_data_unload();



