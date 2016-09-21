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

    $result = $mysqli->prepare("call call_center_pro.total_calls_for_period(?,?)");
    $result->bind_param('ss', $odDatuma, $doDatuma);

    $result->execute();
	/* bind result variables */
	$result->bind_result(	 
	$tic ,
    $ivo ,
    $cttq  ,
    $aac  ,
    $aiq  ,
    $toc  ,
    $tocc  ,
    $attfoc  ,
    $awupfoc  ,
    $ahtfoc  ,
    $attic  ,
    $awutic  ,
    $ahtfic  ,
    $sl85 ,
    $sl83  ,
    $ar ,
    $tocDir,
    $tocDirConCall,
    $tocDirConCallAvgDur,
    $adw
    );

    while ($result -> fetch()) {
		$reportData[] = array(
        	  'tic'  => $tic
            , 'ivo'  => $ivo
            , 'cttq'   => $cttq
            , 'aac'   => $aac
            , 'aiq'   => $aiq
            , 'toc'   => $toc
            , 'tocc'   => $tocc
            , 'attfoc'   => $attfoc
            , 'awupfoc'   => $awupfoc
            , 'ahtfoc'   => $ahtfoc
            , 'attic'   => $attic
            , 'awutic'   => $awutic
            , 'ahtfic'   => $ahtfic
            , 'sl85'   => $sl85
            , 'sl83'   => $sl83
            , 'ar'   => $ar
            , 'tocDir'   => $tocDir
            , 'tocDirConCall'   => $tocDirConCall
            , 'tocDirConCallAvgDur'   => $tocDirConCallAvgDur
            , 'adw' => $adw
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