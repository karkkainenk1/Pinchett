<?php
/* Stories Test cases generated on: 2011-06-06 10:26:28 : 1307345188*/
App::import('Controller', 'Stories');

class TestStoriesController extends StoriesController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class StoriesControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.story', 'app.user', 'app.image', 'app.text');

	function startTest() {
		$this->Stories =& new TestStoriesController();
		$this->Stories->constructClasses();
	}

	function endTest() {
		unset($this->Stories);
		ClassRegistry::flush();
	}

	function testIndex() {

	}

	function testView() {

	}

	function testAdd() {

	}

	function testEdit() {

	}

	function testDelete() {

	}

}
