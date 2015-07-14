<?php 
class ArrayAsserter{
	/*
	* Returns true if any of the items in $array match $item
	*/
	static public function any($item,$array){
		foreach($array as $array_item){
			if($item == $array_item) return true;
		}
		return false;
	}
}
?>