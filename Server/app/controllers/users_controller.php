<?php
class UsersController extends AppController {

	var $name = 'Users';

	function index() {
		$this->User->recursive = 0;
		$this->set('users', $this->paginate());
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid user', true));
			$this->redirect(array('action' => 'index'));
		}
		$this->set('user', $this->User->read(null, $id));
	}

	function add() {
		if (!empty($this->data)) {
			$this->User->create();
			
			$this->data['User']['name'] = trim($this->data['User']['name']);

			if ($this->User->save($this->data)) {
				$this->set('returnData', array("success"=>true, 'user_id'=>$this->User->getInsertId()));
			} else {
				$oldUser = $this->User->findByName($this->data['User']['name']);
				if($oldUser['User']['device_id'] == $this->data['User']['device_id']) {
					$this->set('returnData', array('success'=>true, 'user_id'=>$oldUser['User']['id']));
				} else {
					$this->set('returnData', array("success"=>false, "message"=>"Name is already in use.\nPlease try another name."));
				}
			}
		} else {
			$this->set('returnData', array("success"=>false, "message"=>"No data given to server."));
		}
	}
}
