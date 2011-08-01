<?php
/* Story Test cases generated on: 2011-06-06 10:03:35 : 1307343815*/
App::import('Model', 'Story');

class StoryTestCase extends CakeTestCase {
	var $fixtures = array('app.story', 'app.user', 'app.click', 'app.image', 'app.text');

	function startTest() {
		$this->Story =& ClassRegistry::init('Story');
	}

	function endTest() {
		unset($this->Story);
		ClassRegistry::flush();
	}

}
