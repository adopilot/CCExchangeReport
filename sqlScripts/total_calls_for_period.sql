-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`ado`@`%` PROCEDURE `total_calls_for_period`(IN odDatuma date,IN doDatuma date)
BEGIN
select 
	COALESCE(datum.ivo,0) + COALESCE(cttq,0)  + COALESCE(aiqLT3sec,0) as tic ,/*--total incoming calls*/
    COALESCE(datum.ivo,0) + COALESCE(aiqLT3sec,0) as ivo ,/*-- IVR only is calss whit  dcontext as in clu casr + (add) calls transfert to the que and abandonada in 3 sec  --*/
    COALESCE(cttq,0) as cttq  , /*--Calls transfered to Queue--*/
    COALESCE(aac,0) as aac /*Agent Answered Calls*/  ,
    COALESCE(aiq,0) as aiq  ,/*Abandoned in Queue-*/
    COALESCE(cpl.toc,0) as toc  , /*--total out gouin  calls--*/
	COALESCE(cpl.tocc,0) as tocc  , /*--total out goin conetcted calls--*/
    cast(COALESCE(cpl.attfoc,0) as SIGNED ) attfoc  ,/*--Average Talk Time for Out Calls (sec)--*/
    /**wrap up --*/
	case 
			when COALESCE(cpl.tocc,0)=0 then CAST(0 as SIGNED) /*--ako nemamo poziva onda je wrap up time 0--*/
			/*when date(datum.datum)<cast('2016-04-01 00:00:00' as date) then  CAST(20 as SIGNED)  --ovo je FIXN jer je ova funkcionalonst implenmetnirana tek od 1.4.2016-*/
			else COALESCE(totalWrapUpForOutgoingCalls,0)/COALESCE(cpl.tocc,1) /*--imamo ukupno skenudi a ovo je samo koliko nam treba ovoga--*/
					end  as awupfoc  ,

	cast(COALESCE(cpl.attfoc,0) as SIGNED ) +  /*--Average Talk Time for Out Calls (sec)--*/
			case 
					when COALESCE(cpl.tocc,0)=0 then CAST(0 as SIGNED) /*--ako nemamo poziva onda je wrap up time 0--*/

					else COALESCE(totalWrapUpForOutgoingCalls,0)/COALESCE(cpl.tocc,1) /*--imamo ukupno skenudi a ovo je samo koliko nam treba ovoga--*/
			end as ahtfoc  ,/*Average handling time for OUT Calls*/
	cast(COALESCE(svi_pozivi_u_call_pro.attic,0) as SIGNED ) as attic  , /*-- Average Talk time Incoming Calls (sec)--*/		
	case when COALESCE(aac,0)=0 then 0 /*--ako agent nije answer call onda neamoamo ni wratp up time -*/
		 else COALESCE(totalWrapUpForIncomingCalls,0)/ COALESCE(aac,0) /*--za sve ostalo dijelimo ukupno wrapup vijeme sa brojem dolaznih poziva--*/
			end as awutic  , /*--Average Wrap up time IN Calls (sec)-*/
	cast(COALESCE(svi_pozivi_u_call_pro.attic,0) as SIGNED )+ 
			case when COALESCE(aac,0)=0 then 0 /*--ako agent nije answer call onda neamoamo ni wratp up time -*/
			else COALESCE(totalWrapUpForIncomingCalls,0)/ COALESCE(aac,0) /*--za sve ostalo dijelimo ukupno wrapup vijeme sa brojem dolaznih poziva--*/
		end as ahtfic  , /*--Average handling time for IN Calls (sec)--*/
    COALESCE(COALESCE(icaw15sec,0)/COALESCE(aac,0),0)*100 as sl85  , /*--Service Level 80/15-*/
    COALESCE(COALESCE(icaw30sec,0)/COALESCE(aac,0),0)*100 as sl83  ,/*Service Level 80/30--*/
    (COALESCE(aiq,0) / COALESCE(cttq,0))*100    as ar, /*Abandon Rate-*/
	tocDir, /*--total outging callaqs whitout campainga or direct calls from extensions--*/
	tocDirConCall, /*--total outgiung direct calls connected --*/
	tocDirConCallAvgDur, /* --average call durataion for direct calls from extensions*/
	adw /*Avg Duration Wait*/
    from (
    select 
		1 as datum,
        suM(
			case dcontext
				/*-- IVR only --*/
				when 'app-announcement-10' then 1
				when  'app-announcement-12' then 1
				when 'app-announcement-14' then 1
				when 'app-announcement-2' then 1
				when 'app-announcement-4' then 1
				when 'app-announcement-5' then 1
				when 'app-announcement-6' then 1
				when 'app-announcement-7' then 1
				when 'app-announcement-7' then 1
				when 'ivr-4' then 1
				else 0 
			end	
			) as ivo
	,suM(
			case 
				/*-- IVR only more then duration of 3 sec --*/
				when dcontext ='app-announcement-10' AND duration>3 then 1
				when dcontext = 'app-announcement-12' AND duration>3  then 1
				when dcontext ='app-announcement-14' AND duration>3  then 1
				when dcontext ='app-announcement-2' AND duration>3  then 1
				when dcontext ='app-announcement-4' AND duration>3  then 1
				when dcontext ='app-announcement-5' AND duration>3  then 1
				when dcontext ='app-announcement-6' AND duration>3  then 1
				when dcontext ='app-announcement-7' AND duration>3  then 1
				when dcontext = 'ivr-4' AND duration>3 then 1
				else 0 
			end	
			) as ivoMT /* inbound calls abandoned by the client (hang-ups) before answer by the operator (excluding calls abandoned within the first 3 seconds of connection)-*/
	,sum(case when left(dstchannel,15) = 'SIP/TO_LOGOSOFT' AND left(channel,5) = 'SIP/5' then 1 else 0 end) as tocDir /*--total outging callaqs whitout campainga or direct calls from extensions--*/
	,sum(case when left(dstchannel,15) = 'SIP/TO_LOGOSOFT' AND left(channel,5) = 'SIP/5' and billsec>0 then 1 else 0 end)  as tocDirConCall /*--total outgiung direct calls connected --*/
	,avg(case when left(dstchannel,15) = 'SIP/TO_LOGOSOFT' AND left(channel,5) = 'SIP/5' and billsec>0 then billsec else null end)   AS tocDirConCallAvgDur /*--average call durataion for direct calls from extensions*/
    from asteriskcdrdb.cdr c
	where date(c.calldate) between date( odDatuma )  and date( doDatuma )	
    ) as datum
  left outer join (
		select 
				 1 as datum
				,sum(case  when e.status = 'abandonada'  and duration_wait<=3  then 0 else 1 end  ) as cttq /*--Calls transfered to Queue  exclude calls abandonada in 3 sec becouse they are in IVR-onli set  --*/
				,sum( case  when e.status = 'abandonada'  and duration_wait<=3  then 1 else 0 end ) as aiqLT3sec  /*Abandoned in Queue in less then 3 sec then this is IVR only call-*/
				,sum( case  when e.status = 'abandonada'  and duration_wait>3  then 1 else 0 end ) as aiq  /*Abandoned in Queue-*/
				,sum( case e.status
						when 'terminada' then 1 else 0 end ) as aac /*Agent Answered Calls*/
				,avg( case e.status
						when 'terminada' then duration_wait   end ) as adw /*Avg Duration Wait*/		
				,avg(duration) as attic /*Average Talk time Incoming Calls (sec)*/
                ,SUM(case when e.status='terminada' and COALESCE(duration_wait,0) < 30 then 1 else 0 end)  icaw30sec  /*-inbound calls answered within 30 sec since the connection with the bank*/
                ,SUM(case when e.status='terminada' and COALESCE(duration_wait,0) < 15 then 1 else 0 end)  icaw15sec  /*-inbound calls answered within 30 sec since the connection with the bank*/
				from call_center_pro.call_entry e
				where date(e.datetime_end) between date( odDatuma )  and date( doDatuma )
) as svi_pozivi_u_call_pro on datum.datum=svi_pozivi_u_call_pro.datum  
LEFT OUTER JOIN (
select 
	1 AS datum
	,sum(case new_status
				when 'Dialing' then 1
			else 0 end) as toc /*--total outgoing calls--*/     
	,sum(case new_status
				when 'Success' then 1
		else 0 end) as tocc /*--Total Out Connects calls --*/     
	,avg(case new_status 
		when 'Hangup' then duration end) as attfoc /*Average Talk Time for Out Calls (sec)*/       
from call_center_pro.call_progress_log
where id_call_outgoing is not null 
and date(datetime_entry) between date( odDatuma )  and date( doDatuma )	

)    AS cpl ON datum.datum=cpl.datum

left outer join (
select 
 1 as datum
,case when id_call_outgoing is not null then sum(second(audit.duration)) end as totalWrapUpForOutgoingCalls
,case when id_call_incoming is not null then sum(second(audit.duration)) end as totalWrapUpForIncomingCalls

from audit
left outer join  call_progress_log on audit.id_agent=call_progress_log.id_agent and audit.datetime_init=call_progress_log.datetime_entry
where id_break=9 
and call_progress_log.duration is not null
and date(datetime_entry) between date( odDatuma )  and date( doDatuma )	
) as wrapUpTimes on datum.datum=wrapUpTimes.datum;

END