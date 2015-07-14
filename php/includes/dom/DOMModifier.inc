<?php 
//$some_dom_node->nodeValue = "logo goes here";
class DOMModifier{
	/*
	*
	*/
	static public function emphasize_list_link($dom_doc,$link_value){
		$link_element = DOMParser::link_element($dom_doc,$link_value);
		$link_element->nodeValue = "";//remove text value
		$link_element->appendChild($dom_doc->createElement("em",$link_value));/*TODO replace the node with a new one, replaceChild()*/
	}
	/*
	* @Note adding html to a dom_doc is hard, this method is not pretty but enables this functionality
	* @Note There may be way simpler ways to achive this, further research is needed though
	*/
	static public function append_html(DOMNode $parent, $source) {
	    $temp_dom_doc = new DOMDocument();
	    $temp_dom_doc->loadHTML($source);
	    foreach ($temp_dom_doc->getElementsByTagName('body')->item(0)->childNodes as $node) {
			$imported_node = $parent->ownerDocument->importNode($node, TRUE); 
			$parent->appendChild($imported_node);
	    }
	}
}
?>