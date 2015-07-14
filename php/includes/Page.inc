<?php 
class Page{//this entire class is project specific
	/*
	* Returns a barebone full website html structure populated with some test text
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function front(){
		$dom_doc = Utils::dom_doc("Website");

		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);
		$p_element = $content_element->appendChild($dom_doc->createElement("p"));
		$p_element->nodeValue = "This is where the front page text content goes";
		
		//echo $_SERVER['SCRIPT_NAME'],"<BR>";
		//echo basename(getcwd());
		
		return $dom_doc;
	}
	/*
	* Returns the dom_doc populated with project items
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function projects(){
		$dom_doc = Utils::dom_doc("Website - Projects");

		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);
		
		$rows = SQLiteParser::table_rows('database.db','projects');//read the database table named: projects
		foreach($rows as $row){
			$content_element->appendChild(Page::project_item_element($dom_doc,$row,true));
			//ArrayParser::parser_associative_array($row);
			//echo "<BR>";
		}
		return $dom_doc;
	}
	/*
	* Returns a dom_doc populated with The About page content
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function about(){
		$dom_doc = Utils::dom_doc("Website - About");

		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);
		$p_element = $content_element->appendChild($dom_doc->createElement("p"));
		
		$rows = SQLiteParser::table_rows('database.db','about');//read the database table named: about
		DOMModifier::append_html($p_element, $rows[0]["content"]);
		
		return $dom_doc;
	}
	/*
	* Returns a dom_doc populated with The Contact page content
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function contact(){
		$dom_doc = Utils::dom_doc("Website - Contact");

		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);
		$p_element = $content_element->appendChild($dom_doc->createElement("p"));
		//$p_element->nodeValue = "This is where the contact page text content goes";
		$rows = SQLiteParser::table_rows('database.db','contact');//read the database table named: about
		DOMModifier::append_html($p_element, $rows[0]["content"]);
		
		return $dom_doc;
	}
	/*
	* Returns a dom doc populated with news articles
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function news($iteration){
		$dom_doc = Utils::dom_doc("Website - News");
		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);//access the dom_doc content element
		$rows = SQLiteParser::table_rows('database.db','news');//read the database table named: news
		ArrayModifier::sort_by_date($rows,'date_created');//Sort by date_published
		
		$articles_per_page = 5;//max_articles_per_page
		$current_count_start = $iteration * $articles_per_page;
		$is_there_previous_articles = $current_count_start + $articles_per_page < count($rows);
		$current_count_end = $is_there_previous_articles ? $current_count_start + $articles_per_page : count($rows);
		for($i = $current_count_start;$i < $current_count_end;$i++){
			//echo $i;//output: 1234
			$content_element->appendChild(Page::news_article_element($dom_doc,$rows[$i],true));
			//ArrayParser::parser_associative_array($row);
			//echo "<BR>";
		}
		//pagination
		if($iteration > 0){//add a next link element if condition is met
			$next_url = "/news/" . $iteration == 1 ? "" : ($iteration-1);//we set the url to www.website.com/news/ for iteration that equals 0
			$next_link_element = $content_element->appendChild(DOMParser::link($dom_doc,"Newer ",$next_url));//create and add link element with dynamic url and title
		}
		if($is_there_previous_articles){//add a prev link element at the bottom if condition is met
			$prev_url = "/news/" . ($iteration+1);
			$prev_link_element = $content_element->appendChild(DOMParser::link($dom_doc,"Older ",$prev_url));//create and add link element with dynamic url and title
		}
		return $dom_doc;
	}
	/*
	* Return a div element with news element data, used in the news page overview
	* @Note: this is a project specific method, but could serve as future module for a framework
	* TODO: make it private, or mark it private?
	*/
	static public function news_article_element($dom_doc,$row,$is_preview){
		$article_element = $dom_doc->createElement("div");//maybe use html5 article
		$article_element->setAttribute("id", "news_article");
		$title_element = $article_element->appendChild($dom_doc->createElement("h1"));
		$title = $row["title"];//store the title as text
		$title_link = "/news/" . str_replace(" ","-", strtolower($title)) . "/";//we replace every space char with "-" so that the url is valid
		$title_link_element = $title_element->appendChild(DOMParser::link($dom_doc,$title,$title_link));//create and add link element with dynamic url and title
		$date_created_element = $article_element->appendChild($dom_doc->createElement("div"));
		$date_created_element->setAttribute("id", "date_created");
		$date_created_element->nodeValue = "Date created: " . $row["date_created"];
		
		//$image_link_element = $article_element->appendChild(DOMParser::link($dom_doc,"",$title_link));//create and add the link with an image inside
		//$image_element = $image_link_element->appendChild($dom_doc->createElement("img"));
		//$image_element->setAttribute("src", "/assets/320.png");//alt="Mountain View" style="width:304px;height:228px"
		//$image_element->setAttribute("alt", "320");
		
		$content_element = $article_element->appendChild($dom_doc->createElement("p"));
		if($is_preview){
			DOMModifier::append_html($content_element, $row["description"]);
			//$content_element->nodeValue = $row["description"];//set the text from the SQLite row obj
		}else{
			DOMModifier::append_html($content_element, $row["content"]);
			//$content_element->nodeValue = $row["content"];//set the text from the SQLite row obj
		}
		return $article_element;
	}
	/*
	* Returns a full dom document populated with a single news_article div element
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function news_article($news_article_name){
		$news_article_title = str_replace("-"," ", strtolower($news_article_name));//replaces the - with empty space
		$row = SQLiteParser::row('database.db','news','title',$news_article_title);//store the row data object
			//load news_article
			//check if there is a match in the database
		//trigger_error("Not implemented yet".$row["title"], E_USER_ERROR);
		
		$dom_doc = Utils::dom_doc("Website - News - ".$row["title"]);//create a dom document

		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);//access the content element
		$content_element->appendChild(Page::news_article_element($dom_doc,$row,false));//append the news article div element
		return $dom_doc;
	}
	/*
	* Return a div element with project element data, used in the project page overview
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function project_item_element($dom_doc,$row,$is_preview){
		$project_element = $dom_doc->createElement("div");
		$project_element->setAttribute("id", "project_item");
		
		$title_element = $project_element->appendChild($dom_doc->createElement("h1"));
		
		$title = $row["title"];//store the title as text
		$title_link = "/projects/" . str_replace(" ","-", strtolower($title)) . "/";//we replace every space char with "-" so that the url is valid
		$title_link_element = $title_element->appendChild(DOMParser::link($dom_doc,$title,$title_link));//create and add link element with dynamic url and title
	
		$content_element = $project_element->appendChild($dom_doc->createElement("p"));
		//$content_element->nodeValue = $row["description"];//set the text from the SQLite row obj
		
		if($is_preview){
			DOMModifier::append_html($content_element, $row["description"]);//set the text from the SQLite row obj
		}else{
			DOMModifier::append_html($content_element, $row["content"]);//set the text from the SQLite row obj
		}
		
		return $project_element;
	}
	/*
	* Returns a full dom document populated with a single project_item div element
	* @Note: this is a project specific method, but could serve as future module for a framework
	*/
	static public function project_item($project_name){
		$project_title = str_replace("-"," ", strtolower($project_name));
		$row = SQLiteParser::row('database.db','projects','title',$project_title);
			//load project
			//check if there is a match in the database
		//trigger_error("Not implemented yet".$row["title"], E_USER_ERROR);
		
		$dom_doc = Utils::dom_doc("Website - Projects - ".$row["title"]);

		/*Content*/
		$content_element = DOMParser::content_element($dom_doc);
		$content_element->appendChild(Page::project_item_element($dom_doc,$row,false));
		return $dom_doc;
	}	
}
?>