<?php
/* Texts Test cases generated on: 2011-06-06 10:26:28 : 1307345188*/
App::import('Controller', 'Texts');

class TestTextsController extends TextsController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class TextsControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.text', 'app.user', 'app.image', 'app.story');

	function startTest() {
		$this->Texts =& new TestTextsController();
		$this->Texts->constructClasses();
	}

	function endTest() {
		unset($this->Texts);
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
