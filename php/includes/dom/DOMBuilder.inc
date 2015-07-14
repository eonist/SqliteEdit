<?php 
/*you can set regular html to nodeValue's, you create a new node child and add it*/
class DOMBuilder{
	/*
	 *	$dom = new DOMDocument;
	 *	$dom->loadXml('<html><head><title>Test</title></head><body/></html>');
	 */
	static public function basic_html(){
		$dom_doc = new DOMDocument('1.0', 'UTF-8');
		$dom_doc->formatOutput = true;
		//$dom_doc->preserveWhiteSpace = false;
		$html = $dom_doc->appendChild($dom_doc->createElement("html"));
		$head = $html->appendChild($dom_doc->createElement("head"));
		$body = $html->appendChild($dom_doc->createElement("body"));
		return $dom_doc;
	}
}
?>