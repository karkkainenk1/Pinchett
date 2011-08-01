<?php

class AppController extends Controller {

	var $components = array('RequestHandler');
	var $helpers = array('Javascript', 'Session', 'Form');
	function beforeFilter() {
    		$this->RequestHandler->setContent('json', 'application/json');
	}
}
