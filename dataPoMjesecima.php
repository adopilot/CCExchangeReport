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
   

    $result = $mysqli->prepare("call call_center_pro.total_cals_per_month");


    $result->execute();
	/* bind result variables */
	$result->bind_result(	
    $period,
	$godina,
	$mjesec,
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
		     'period' => $period
	        ,'godina' => $godina
	        ,'mjesec' => $mjesec
        	, 'tic'  => $tic
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


?>