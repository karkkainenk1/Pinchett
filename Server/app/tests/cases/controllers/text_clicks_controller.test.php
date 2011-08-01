<?php
/* TextClicks Test cases generated on: 2011-06-06 10:26:28 : 1307345188*/
App::import('Controller', 'TextClicks');

class TestTextClicksController extends TextClicksController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class TextClicksControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.text_click', 'app.text', 'app.user', 'app.image', 'app.story');

	function startTest() {
		$this->TextClicks =& new TestTextClicksController();
		$this->TextClicks->constructClasses();
	}

	function endTest() {
		unset($this->TextClicks);
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
