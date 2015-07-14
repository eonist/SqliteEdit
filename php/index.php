
<?php
include_once'includes/Utils.inc';
$page_titles = array("projects","news","about","contact");//the sub pages for the domain (i.e: www.domain.com/news/2/)

//echo $_SERVER['REQUEST_URI'],"<BR>";
//Note: This method takes care of the dynamic URL from the adressbar input
//Note: the switch takes care of the first item after the domain handle (i.e: www.domain.com/news/)
//Note: the subsequent if else statements take care of article subsub pages (i.e: www.domain.com/news/2/)
//todo: add the bellow in an external php class nambeduURIHandeler.inc
preg_match_all("/(?<=\/)[^\/]+?(?=(\/|\$))/", $_SERVER['REQUEST_URI'],$matches);/*seperates the items in the URI*/
if(sizeof($matches[0]) > 0){/*assert if there is anything in the matches array*/
//	echo "an item was found","<BR>";
	//ArrayParser::parse_array($matches[0]);
	//print_r($matches[0]);
	$first_item = $matches[0][0];
	//echo $first_item,"<BR>";	
	switch ($first_item) {
		case $page_titles[0]://projects
			if(sizeof($matches[0]) == 1){
				//echo "first URI item matches one of the main pages","<BR>";
				$dom_doc = Page::projects();
			}elseif(sizeof($matches[0]) == 2){
				//load project_item
				$project_name = $matches[0][1];
				$dom_doc = Page::project_item($project_name);
				//trigger_error("Not implemented yet", E_USER_ERROR);
			}
			break;
		case $page_titles[1]://news
			if(sizeof($matches[0]) == 1){
				//echo "first URI item matches one of the main pages","<BR>";
				$dom_doc = Page::news(0);
			}elseif(sizeof($matches[0]) == 2 && is_numeric($matches[0][1])){//www.website.com/news/2  etc
				$dom_doc = Page::news($matches[0][1]);//the argument is the second URI item
			}elseif(sizeof($matches[0]) == 2){
				$news_article_name = $matches[0][1];
				$dom_doc = Page::news_article($news_article_name);
			}
			break;
		case $page_titles[2]: 
			$dom_doc = Page::about(); 
			break;
		case $page_titles[3]: 
			$dom_doc = Page::contact(); 
			break;
		default: 
			trigger_error("No match", E_USER_ERROR);//default;
	}
}else{//load up the front_page html
	//echo "NO item was found","<BR>";
	$dom_doc = Page::front(); 
}



echo $dom_doc->saveHTML();//outputs the html

//Note: this is the mockup of how thos document works, can be deleted in the future
//note you should only have 1 index.php doc that controls everything
//get the first item, it should be news, contact, projects, about, load the apropriate page html
	//if the first item is empty, then your at the front page so load the front html
//if your  URI is /project/first-project/
	//then you look in the project database for the first project with the title: first-project
	//then you load this project in the appropriate html context
//if your URI is /news/first-news-article
	//then you look in the news database for the first project with the title: first-news-article
	//then you load this project in the appropriate html context
//if your URI is /projects/first-project/first-item/
	//then you look for this project_item in the table project_items in the database
	//then you load the project-item in the appropriate html context

//all other requests goes to the front page

?>