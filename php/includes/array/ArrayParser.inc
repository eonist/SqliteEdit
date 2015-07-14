<?php 
class ArrayParser{
	/*echos out an array*/
	static public function parse_array($arr){
		for($i = 0;$i < count($arr);$i++){
			if(is_string($arr[$i])){
				echo "<li>", $arr[$i],"</li>";
			}
		}
	}
	/*echos out an associative array*/
	static public function parser_associative_array($arr){
		$return_array = array();
		foreach($arr as $k => $v){
			echo $k , ": " ,$v, "<BR>";
		}
	}
}
?>