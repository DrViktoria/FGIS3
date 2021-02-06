-- СЗ
select CERTIFICATENUM as "Регистрационный номер АЛ",
       PROTOCOLNUMBER as "Номер протокола",
       PROTOCOLDATE  as "Дата протокола"
FROM FSA_RPI.info
LEFT JOIN FSA_RPI.labinfo ON fsa_rpi.info.reportid = fsa_rpi.labinfo.reportid
where CERTIFICATEID = '73549476802A426383B4573BCAB993E9'
and (PROTOCOLDATE in ('30.05.2017', '31.05.2017', '13.06.2017',
                     '19.06.2017','20.06.2017','21.06.2017','22.06.2017','23.06.2017',
                    '28.06.2017', '29.06.2017', '18.07.2017','19.07.2017',
                    '26.07.2017','27.07.2017',
                    '04.08.2017', '05.08.2017', '06.08.2017','07.08.2017','08.08.2017', '27.09.2017')
or PROTOCOLDATE between '21.08.2017' and '24.08.2017'
or PROTOCOLDATE between '11.09.2017' and '19.09.2017'
or PROTOCOLDATE between  '16.10.2017' and '08.08.2019')
order by PROTOCOLDATE;

select to_char(to_date('01.01.1970 00:00:00','dd.mm.yyyy hh24:mi:ss') + 1/24/60/60 * CREATEDATE, 'dd.mm.yyyy') as "Дата отправки",
       count(*)
FROM FSA_RPI.info
where to_char(to_date('01.01.1970 00:00:00','dd.mm.yyyy hh24:mi:ss') + 1/24/60/60 * CREATEDATE, 'dd.mm.yyyy')  between '01.01.2021' and '27.01.2021'
group by to_char(to_date('01.01.1970 00:00:00','dd.mm.yyyy hh24:mi:ss') + 1/24/60/60 * CREATEDATE, 'dd.mm.yyyy')

select CERTIFICATENUM as "Регистрационный номер АЛ",
       PROTOCOLNUMBER as "Номер протокола",
       PROTOCOLDATE  as "Дата протокола",
       to_char(to_date('01.01.1970 00:00:00','dd.mm.yyyy hh24:mi:ss') + 1/24/60/60 * CREATEDATE, 'dd.mm.yyyy') as "Дата отправки",
      CREATEDATE
FROM FSA_RPI.info
LEFT JOIN FSA_RPI.labinfo ON fsa_rpi.info.reportid = fsa_rpi.labinfo.reportid
where CERTIFICATEID = '9ABF77732A3447AAAD90195C58FA5B58'
and PROTOCOLNUMBER like '36.10001%'
order by PROTOCOLDATE;