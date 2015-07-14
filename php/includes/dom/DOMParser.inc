<?php 
/*
* Note: you can set html to a nodeValue, create a new node child and add it
* Note: you use the @param $dom_doc value as a creator of the dom elemnt, php requires a dom displayObjectContainer reference to create dom elements
*/
class DOMParser{
	/*
	* Creates and returns a html eleme@Note: by creating a dom displayObjectContainer element
	* TODO create DOMBuilder
	* Note: you use the @param $dom_doc value as a creator of the dom elemnt, php requires a dom displayObjectContainer reference to create dom elements
	*/
	static public function link_element($dom_doc,$link_value){
		$li_element = DOMParser::li_element($dom_doc,$link_value);//is it possible to reference static methods in the same class without re=referencing the class as in this line
		$link_element = $li_element->firstChild;
		return $link_element;
	}
	/*
	 * Creates and Returns a dom doc link element
	 */
	static public function li_element($dom_doc,$link_value){
		$navigation_element = DOMParser::navigation_element($dom_doc);
		$ul_element = $navigation_element->getElementsByTagName('ul')->item(0);
		$li_elements = $ul_element->getElementsByTagName('li');
		foreach($li_elements as $li_element) {
			//print $element->hasAttribute($attribute);
			//print $element->getAttributeNode($attribute_name)->value;
			$link_element = $li_element->firstChild;
			
			if($link_element->nodeValue == $link_value){
				return $li_element;
			}
		}
		return null;/*throw some error first*/
	}
	
	/*
	* Creates and Returns an html element that you can populate with a value through the DomModifier::append_child(DOMNode $parent, $source)
	*/
	static public function html_element($dom_doc){
		$html_elements = $dom_doc->getElementsByTagName('html');
		$html_element = $html_elements->item(0);
		return $html_element;
	}
	/*
	* Creates and Returns a dom doc body element 
	*/
	static public function body_element($dom_doc){
		$html_element = DOMParser::html_element($dom_doc);
		$body_element = $html_element->getElementsByTagName('body')->item(0);
		return $body_element;
	}
	/*
	* Creates and Returns a dom doc content element
	*/
	static public function content_element($dom_doc){
		$body_element = DOMParser::body_element($dom_doc);
		$content_element = DOMParser::dom_node_by_name_and_attribute($body_element,"div","id","content");
		return $content_element;
	}
	/*
	* Creates and Returns a dom doc nav element
	* Note: maybe move all the creator methos to the DomBuilder class
	*/
	static public function navigation_element($dom_doc){
		$body_element = DOMParser::body_element($dom_doc);
		$navigation_element = DOMParser::dom_node_by_name_and_attribute($body_element,"div","id","navigation");
		return $navigation_element;
	}
	/*
	* Retrives and returns a dom element
	* @Note: this method seems to look one sub-level down for an item that matches the @param $name and $attribute_name and $attribute_value
	*/
	static public function dom_node_by_name_and_attribute($dom_node,$name,$attribute_name,$attribute_value){
		$elements = $dom_node->getElementsByTagName($name);
		//print $elements->length;
		foreach($elements as $element) {
			//print $element->hasAttribute($attribute);
			//print $element->getAttributeNode($attribute_name)->value;
			if($element->hasAttribute($attribute_name) && $element->getAttributeNode($attribute_name)->value == $attribute_value){
				return $element;
			}
		}
		return null;
	}
	/*
	* Creates and returns a list_link dom item populated with @param $text and $url
	*/
	static public function list_link($dom_doc,$text,$url){
		$li_element = $dom_doc->createElement("li");
		$link = $li_element->appendChild(DOMParser::link($dom_doc,$text,$url));
		return $li_element;
	}
	/*
	* Creates and returns a list dom item populated with @param $text and $url
	*/
	static public function link($dom_doc,$text,$url){
		$link = $dom_doc->createElement('a',$text);
		$link->setAttribute("href", "$url");
		return $link;
	}
	/*
	* Creates and returns a full html website populated with all the bells and whistles that one usually find in a html page
	* @Note: its also possible to arrive at the same reult by doing the bellow:
	* $dom = new DOMDocument;
	* $dom->loadXml('<html><head><title>Test</title></head><body/></html>');
	*/
	static public function html($title){
		$dom_doc = new DOMDocument('1.0', 'UTF-8');
		$dom_doc->formatOutput = true;
		//$dom_doc->preserveWhiteSpace = false;
		$html = $dom_doc->appendChild($dom_doc->createElement("html"));
		$html->setAttribute("xmlns", "http://www.w3.org/1999/xhtml");//needed?
		$html->setAttribute("xml:lang", "en");
		$html->setAttribute("lang", "en");
		$head = $html->appendChild(DOMParser::head($dom_doc,$title));
		$meta = $head->appendChild($dom_doc->createElement("meta"));//needed?
		$meta->setAttribute("http-equiv", "Content-Type");
		$meta->setAttribute("content", "text/html");
		$meta->setAttribute("charset", "utf-8");
		$link = $head->appendChild($dom_doc->createElement("link"));
		$link->setAttribute("rel", "stylesheet");
		$link->setAttribute("href", "/style/screen_main.css");
		$link->setAttribute("type", "text/css");
		$link->setAttribute("media", "screen");
		$link->setAttribute("title", "no title");
		$body = $html->appendChild($dom_doc->createElement("body"));
		$masthead = $body->appendChild(DOMParser::mast_head($dom_doc));
		$navigation = $body->appendChild(DOMParser::navigation($dom_doc));
		$content = $body->appendChild(DOMParser::content($dom_doc));
		$footer = $body->appendChild(DOMParser::footer($dom_doc));
		return $dom_doc;
	}
	/*
	* Creates and returns a head dom item populated with the @param $title
	*/
	static public function head($dom_doc,$title){
		$head = $dom_doc->createElement('head');
		$head->appendChild(DOMParser::title($dom_doc,$title));
		return $head;
	}
	/*
	* Creates and returns a title item populated with @param $title
	* @Note: you could also just add the title text as a second arg in createElement
	*/
	static public function title($dom_doc,$title){
		$title_element = $dom_doc->createElement("title");/**/
		$title_text_element = $title_element->appendChild($dom_doc->createTextNode($title));
		return $title_element;
	}
	/*
	* Creates and returns a mast head dom item
	*/
	static public function mast_head($dom_doc){
		$mast_head_div = $dom_doc->createElement('div');
		$mast_head_div->setAttribute("id", 'mastHead');
		return $mast_head_div;
	}
	/*
	* Creates and returns nav "div" dom item 
	*/
	static public function navigation($dom_doc){
		$navigation = $dom_doc->createElement('div');
		$navigation->setAttribute("id", "navigation");
		$ul_element = $navigation->appendChild($dom_doc->createElement("ul"));
		return $navigation;
	}
	/*
	* Creates and returns a div content dom element
	*/
	static public function content($dom_doc){
		$content = $dom_doc->createElement('div');
		$content->setAttribute("id", "content");
		$content->setAttribute("class", "clearfix");
		return $content;
	}
	/*
	* Creates and returns a footer dom item
	*/
	static public function footer($dom_doc){
		$footer = $dom_doc->createElement('div');
		$footer->setAttribute("id", "footer");
		return $footer;
	}
}
?>