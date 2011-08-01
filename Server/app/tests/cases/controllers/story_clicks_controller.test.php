<?php
/* StoryClicks Test cases generated on: 2011-06-06 10:26:28 : 1307345188*/
App::import('Controller', 'StoryClicks');

class TestStoryClicksController extends StoryClicksController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class StoryClicksControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.story_click', 'app.story', 'app.user', 'app.image', 'app.text');

	function startTest() {
		$this->StoryClicks =& new TestStoryClicksController();
		$this->StoryClicks->constructClasses();
	}

	function endTest() {
		unset($this->StoryClicks);
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
