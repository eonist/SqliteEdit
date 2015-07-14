<?php 
class ArrayModifier{
	/*
	* Sorts an array by date
	* TODO: add DECending Acending flag in the future
	*/
	static public function sort_by_date($arr,$date_key){
		foreach ($arr as $key => $row) {//sort table for the sort array by date functionality
		    $dates[$key] = $row[$date_key];
		}
		array_multisort($dates, SORT_NUMERIC, SORT_DESC, $arr);//sorts the array by date
	}
}
?>