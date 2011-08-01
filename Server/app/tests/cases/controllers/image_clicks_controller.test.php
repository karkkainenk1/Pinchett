<?php
/* ImageClicks Test cases generated on: 2011-06-06 10:26:28 : 1307345188*/
App::import('Controller', 'ImageClicks');

class TestImageClicksController extends ImageClicksController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class ImageClicksControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.image_click', 'app.image', 'app.user', 'app.story', 'app.text');

	function startTest() {
		$this->ImageClicks =& new TestImageClicksController();
		$this->ImageClicks->constructClasses();
	}

	function endTest() {
		unset($this->ImageClicks);
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
