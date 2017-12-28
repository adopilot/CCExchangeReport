<?php
/**
 * data short summary.
 *
 * data description.
 *
 * @version 1.0
 * @author adopi
 */
    #Include the connect.php file
	include('connect.php');
	#Connect to the database
	$mysqli = new mysqli("$hostname", "$username", "$password", $database);
	/* check connection */
	if (mysqli_connect_errno()) {
		printf("Nijesam uspio ostvariti konekciju sa MySqlOm: %s\n", mysqli_connect_error());
		exit();
	}
    $kampanje ="0";

    

    if (isset($_GET['kampanje']))
	{
        $kampanje = $_GET['kampanje'];
    }
   
       
    $sql = "select 
    calls.id
   ,calls.phone
   ,calls.retries
   ,calls.status
   ,calls.group_status
   ,calls.date_init
   ,calls.time_init
   ,calls.date_end
   ,calls.time_end
   ,case calls.scheduled 
		when 1 then 'DA'
        else 'NE ' 
        end as scheduled
   ,campaign.name as kamapanja
   from call_center_pro.calls 
   left outer join call_center_pro.campaign on calls.id_campaign=campaign.id
   where id_campaign in ( " . $kampanje  . ") and  group_status IS NULL  and status IS NULL; ";
   
   $result = $mysqli->prepare($sql); 
   
    $result->execute();
	/* bind result variables */
	$result->bind_result(	
        $id,
        $phone ,
        $retries ,
        $status ,
        $group_status  ,
        $date_init  ,
        $time_init  ,
        $date_end  ,
        $time_end  ,
        $scheduled  ,
        $kamapanja 
    );

    while ($result -> fetch()) {
		$reportData[] = array(
			  'id' => $id
        	, 'phone'  => $phone
            , 'retries'  => $retries
            , 'status'   => $status
            , 'group_status'   => $group_status
            , 'date_init'   => $date_init
            , 'time_init'   => $time_init
            , 'date_end'   => $date_end
            , 'time_end'   => $time_end
            , 'scheduled'   => $scheduled
            , 'kamapanja'   => $kamapanja
           
	  );
	}
    echo json_encode($reportData);
	/* close statement */
	$result->close();
	/* close connection */
	$mysqli->close();


?>