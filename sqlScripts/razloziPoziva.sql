SELECT 
	call_entry.id as call_entry_id
	,callerid as telefonskiBroj
    ,agent.name as agentName
    ,agent.number as agentNumber
	,answer as ocjena
    ,duration as trajanje
    ,call_entry.datetime_end as pozivTS
    ,date(call_entry.datetime_end) as pozivDatum
    ,HOUR(call_entry.datetime_end) as pozivSAT
	,podrucije
	,JMBG
	,imeIprezime
	,kontaktTelefon
	,ishodRazgovora
	,vrstaUpita
	,detaljiUpita
    ,id_campaign
FROM call_center_pro.call_entry
inner JOIN call_center_pro.agent ON agent.id=call_entry.id_agent
inner join (
select
	dynamic_form_data_recolected_entry.id_call_entry
    ,max(case when dynamic_form_node.name='Osnovni podaci' and dynamic_form_node_field.description='Podrucje' then dynamic_form_data_recolected_entry.value end) as podrucije
    ,max(case when dynamic_form_node.name='Osnovni podaci' and dynamic_form_node_field.description='JMBG' then dynamic_form_data_recolected_entry.value end) as JMBG
    ,max(case when dynamic_form_node.name='Osnovni podaci' and dynamic_form_node_field.description='Ime i prezime' then dynamic_form_data_recolected_entry.value end) as imeIprezime
    ,max(case when dynamic_form_node.name='Osnovni podaci' and dynamic_form_node_field.description='Kontakt telefon' then dynamic_form_data_recolected_entry.value end) as kontaktTelefon
    ,max(case when dynamic_form_node.name='Osnovni podaci' and dynamic_form_node_field.description='Ishod razgovora' then dynamic_form_data_recolected_entry.value end) as ishodRazgovora
    ,max(case when dynamic_form_node_field.description='Vrsta upita' then dynamic_form_data_recolected_entry.value end) as vrstaUpita
    ,max(case when dynamic_form_node_field.description='Detalji upita' then dynamic_form_data_recolected_entry.value end) as detaljiUpita
from dynamic_form_node
inner join dynamic_form_node_field on dynamic_form_node.id=dynamic_form_node_field.id_dynamic_form_node
inner join dynamic_form_data_recolected_entry on dynamic_form_data_recolected_entry.id_dynamic_form_node_field = dynamic_form_node_field.id

group by dynamic_form_data_recolected_entry.id_call_entry
) as callData on call_entry.id=callData.id_call_entry
left outer join asteriskcdrdb.survey on call_entry.uniqueid=uid
