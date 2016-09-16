<?php
if ( isset($_POST["format"],$_POST["content"]))
{
    if ($_POST["format"] == 'xls')
    {
        header("Content-Type:   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; charset=utf-8");
        header("Content-Disposition: attachment; filename=report.xls");  //File name extension was wrong
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
        header("Cache-Control: private",false);
        echo str_replace("&lt;br /&gt;", " ", $_POST["content"]);
        exit;
    }
    if ($_POST["format"]=='csv')
    {

        header("Content-type: text/csv");
        header("Content-Disposition: attachment; filename=report.csv");
        header("Pragma: no-cache");
        header("Expires: 0");
        echo str_replace("<br />", " ", $_POST["content"]);
    }
    else{
        echo "ne por�an fomrat za export";
    }
}
else {
echo "Post za paramter nije poslan";
}
?>