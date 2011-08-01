<?php
/* User Test cases generated on: 2011-06-06 10:01:03 : 1307343663*/
App::import('Model', 'User');

class UserTestCase extends CakeTestCase {
	var $fixtures = array('app.user', 'app.click', 'app.image', 'app.story', 'app.text');

	function startTest() {
		$this->User =& ClassRegistry::init('User');
	}

	function endTest() {
		unset($this->User);
		ClassRegistry::flush();
	}

}
