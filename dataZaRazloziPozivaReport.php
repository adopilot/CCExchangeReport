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
		printf("Nisam uspio ostvariti konekciju sa MySqlOm: %s\n", mysqli_connect_error());
		exit();
	}
    $odDatuma =date("Y-m-d");

    $doDatuma = date("Y-m-d");

    if (isset($_GET['odDatuma']))
	{
        $odDatuma = $_GET['odDatuma'];
    }
    if (isset($_GET['odDatuma']))
	{
        $doDatuma = $_GET['doDatuma'];
    }

    if (isset( $_GET['prviPut']) &&  $_GET['prviPut'] !== 'true'){
        
    

    $result = $mysqli->prepare("call call_center_pro.report_razlozi_poziva(?,?)");
    $result->bind_param('ss', $odDatuma, $doDatuma);

    $result->execute();
	/* bind result variables */
	$result->bind_result(	 
	$call_entry_id ,
    $telefonskiBroj ,
    $agentName  ,
    $agentNumber  ,
    $ocjena  ,
    $trajanje  ,
    $pozivTS  ,
    $pozivDatum  ,
    $pozivSAT  ,
    $podrucije  ,
    $JMBG  ,
    $imeIprezime  ,
    $kontaktTelefon  ,
    $ishodRazgovora ,
    $vrstaUpita  ,
    $detaljiUpita ,
    $komentarUpita
    );

    while ($result -> fetch()) {
		$reportData[] = array(
	'call_entry_id'=>  $call_entry_id ,
    'telefonskiBroj'=>$telefonskiBroj ,
    'agentName'=>$agentName  ,
    'agentNumber'=>$agentNumber  ,
    'ocjena'=>$ocjena  ,
    'trajanje'=>$trajanje  ,
    'pozivTS'=>$pozivTS  ,
    'pozivDatum'=>$pozivDatum  ,
    'pozivSAT'=> $pozivSAT  ,
    'podrucije'=> $podrucije  ,
    'JMBG'=> $JMBG  ,
    'imeIprezime'=> $imeIprezime  ,
    'kontaktTelefon'=> $kontaktTelefon  ,
    'ishodRazgovora'=> $ishodRazgovora ,
    'vrstaUpita'=> $vrstaUpita  ,
    'detaljiUpita'=> $detaljiUpita,
    'komentarUpita' => $komentarUpita


   
	  );
	}
    
    echo json_encode($reportData);
	/* close statement */
	$result->close();
	/* close connection */
	$mysqli->close();
    }
    else {
        echo 'Priv put mi je pa ne vracam nista';
    }
     
    

?>