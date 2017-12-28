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
    $result = $mysqli->prepare("select id,name,estatus from campaign;");
    $result->execute();
	/* bind result variables */
	$result->bind_result(	 
	$id ,
    $name ,
    $estatus 
    );

    while ($result -> fetch()) {
		$reportData[] = array(
        	  'id'  => $id
            , 'name'  => $name
            , 'estatus'   => $estatus
	  );
	}
    echo json_encode($reportData);
	/* close statement */
	$result->close();
	/* close connection */
	$mysqli->close();

    
    

?>