<?php
/* Text Test cases generated on: 2011-06-06 10:05:24 : 1307343924*/
App::import('Model', 'Text');

class TextTestCase extends CakeTestCase {
	var $fixtures = array('app.text', 'app.user', 'app.click', 'app.image', 'app.story');

	function startTest() {
		$this->Text =& ClassRegistry::init('Text');
	}

	function endTest() {
		unset($this->Text);
		ClassRegistry::flush();
	}

}
