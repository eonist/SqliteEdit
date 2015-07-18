<?php 
class SQLiteParser{// utiliterian class, not project specific
	/*
	 * // :TODO: does this method return the entire row as a string with keys and values etc?
	 */
	static public function table_rows($db_name,$table_name){
		$db = new SQLite3($db_name);
		$results = $db->query('SELECT * FROM '.$table_name);
		$rows = array();
		while ($row = $results->fetchArray(SQLITE3_ASSOC)) {
		   // var_dump($row);
			$rows[] = $row;
			//ArrayParser::parser_associative_array($row);
			//echo "<BR>";
			//parse_array($row);
		}
		return $rows;
		//echo $results->numColumns(),"<BR>";
		//parse_array($results);
		//echo $results->fetchArray()[0], "<BR>";
		//echo $results->numColumns();
	}
	/*
	 * Returns a row in a database from @param $db_name that mathes: @param $table_name and $row_column_key and $row_value
	 * // :TODO: does it return a string?
	 */
	static public function row($db_name,$table_name,$row_column_key,$row_value){
		$db = new SQLite3($db_name);
		$query = "SELECT * FROM " .$table_name . " WHERE " .  $row_column_key  . " = " . "'" . $row_value . "'" . " COLLATE NOCASE";
	//	$query = 'SELECT * FROM '.$table_name;
		//$query = "SELECT * FROM news WHERE title = 'website is launched' COLLATE NOCASE";
	//	trigger_error($query, E_USER_ERROR);
		$results = $db->query($query);
	//	$rows = array();
		//trigger_error(sizeof($results->fetchArray(SQLITE3_ASSOC)), E_USER_ERROR);
		//trigger_error(gettype($results->fetchArray(SQLITE3_ASSOC)), E_USER_ERROR);
		//trigger_error($results->fetchArray(SQLITE3_ASSOC)["content"], E_USER_ERROR);
		return $results->fetchArray(SQLITE3_ASSOC);
	}
}

?>