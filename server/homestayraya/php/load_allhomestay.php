<?php

	error_reporting(0);
	include_once("dbconnect.php");
	$search  = $_GET["search"];
	$results_per_page = 6;
	$pageno = (int)$_GET['pageno'];
	$page_first_result = ($pageno - 1) * $results_per_page;
	
	if ($search =="all"){
		$sqlloadhomestay = "SELECT * FROM tbl_homestay ORDER BY homestay_date DESC";
	}
	else{
		$sqlloadhomestay = "SELECT * FROM tbl_homestay WHERE homestay_name LIKE '%$search%' ORDER BY homestay_date DESC";
	}
	
	$result = $conn->query($sqlloadhomestay);
	$number_of_result = $result->num_rows;
	$number_of_page = ceil($number_of_result / $results_per_page);
	$sqlloadhomestay = $sqlloadhomestay . " LIMIT $page_first_result , $results_per_page";
	$result = $conn->query($sqlloadhomestay);
	
	if ($result->num_rows > 0) {
		$homestayarray["homestay"] = array();
		while($row = $result->fetch_assoc()){
			$hslist = array();
			$hslist['homestay_id'] = $row['homestay_id'];
			$hslist['homestay_name'] = $row['homestay_name'];
			$hslist['homestay_desc'] = $row['homestay_desc'];
			$hslist['homestay_price'] = $row['homestay_price'];
			$hslist['homestay_room'] = $row['homestay_room'];
			$hslist['homestay_state'] = $row['homestay_state'];
			$hslist['homestay_locality'] = $row['homestay_locality'];
			$hslist['homestay_lat'] = $row['homestay_lat'];
			$hslist['homestay_lng'] = $row['homestay_lng'];
			$hslist['homestay_contact'] = $row['homestay_contact'];
			$hslist['homestay_date'] = $row['homestay_date'];
			array_push($homestayarray["homestay"],$hslist);
		}
		$response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $homestayarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
?>