<?php 
include_once'array/ArrayParser.inc';
include_once'array/ArrayAsserter.inc';
include_once'array/ArrayModifier.inc';
include_once'sqlite/SQLiteParser.inc';
include_once'html/HTMLParser.inc';
include_once'dom/DOMParser.inc';
include_once'dom/DOMModifier.inc';
include_once'Page.inc';
class Utils{//this entire class is project specific
	/*
	 * Returns a html structure with body,mast_head and navigation
	 * @Note: this is a project specific method
	 */
	static public function dom_doc($title){
		$dom_doc = DOMParser::html($title);
		$body_element = DOMParser::body_element($dom_doc);
		
		/*mastHead - Logo or title goes here*/
		$mast_head_element = DOMParser::dom_node_by_name_and_attribute($body_element,"div","id","mastHead");
	
		$logo = $mast_head_element->appendChild(DOMParser::link($dom_doc,"","/"));//Logo goes here
		
		/*navigation - add UL LI LI LI wtih names and working links*/
		$navigation_element = Utils::navigation($dom_doc);
		return $dom_doc;
	}
	/*
	 * Returns a html navigation element
	 * @Note: this is a project specific method
	 */
	static public function navigation($dom_doc){
		$body_element = DOMParser::body_element($dom_doc);
		$navigation_element = DOMParser::dom_node_by_name_and_attribute($body_element,"div","id","navigation");
		$ul_element = $navigation_element->getElementsByTagName('ul')->item(0);
		$menu_titles = array("projects","news","about","contact");
		foreach($menu_titles as $menu_title){
			$link_element = DOMParser::list_link($dom_doc,ucfirst($menu_title),"/".$menu_title."/");
			$ul_element->appendChild($link_element);
		}
		/*set current list link in nav to bold*/
		if(ArrayAsserter::any(basename(getcwd()),$menu_titles)){/*emphasize only pages that are in the menu*/
			DOMModifier::emphasize_list_link($dom_doc,ucfirst(basename(getcwd())));/*derive Contact from the document name then uppercase etc*/
		}
		return $navigation_element;
	}
}
?>