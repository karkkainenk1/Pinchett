<?php
/* Image Test cases generated on: 2011-06-06 10:07:29 : 1307344049*/
App::import('Model', 'Image');

class ImageTestCase extends CakeTestCase {
	var $fixtures = array('app.image', 'app.user', 'app.click', 'app.story', 'app.text');

	function startTest() {
		$this->Image =& ClassRegistry::init('Image');
	}

	function endTest() {
		unset($this->Image);
		ClassRegistry::flush();
	}

}
