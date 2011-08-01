<?php
/* Images Test cases generated on: 2011-06-06 10:26:28 : 1307345188*/
App::import('Controller', 'Images');

class TestImagesController extends ImagesController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class ImagesControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.image', 'app.user', 'app.story', 'app.text');

	function startTest() {
		$this->Images =& new TestImagesController();
		$this->Images->constructClasses();
	}

	function endTest() {
		unset($this->Images);
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
