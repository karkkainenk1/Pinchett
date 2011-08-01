<?php
class TextsController extends AppController {

	var $name = 'Texts';

	function getAll($story_id = null) {
		if($story_id == null) {
			$this->set('returnData', array('success'=>false, 'message'=>'Getting content failed'));
		} else {
			$texts = $this->Text->find('list', array('order'=>'id DESC', 'conditions'=>array('story_id'=>$story_id)));
			$this->set('returnData', array('success'=>true, 'data'=>$texts));
		}
	}

	function add() {
		if(!empty($this->data) && !empty($this->data['Text']['user_id']) && !empty($this->data['Text']['device_id']) && !empty($this->data['Text']['story_id'])) {
			$user_id = $this->data['Text']['user_id'];
			$device_id = $this->data['Text']['device_id'];
			$story_id = $this->data['Text']['story_id'];
	
 			$user = $this->Text->User->findById($user_id);
			if(!empty($user['User']['device_id']) && $user['User']['device_id'] == $device_id) {
				$this->data['Text']['content'] = trim($this->data['Text']['content']);
				$this->Text->create();
				if($this->Text->save($this->data)) {
					$texts = $this->Text->find('list', array('order'=>'id DESC', 'story_id'=>$story_id));
					$this->set('returnData', array('success'=>true));
				} else {
					$this->set('returnData', array('success'=>false, 'message'=>'Adding message failed.'));
				}
			} else {
				$this->set('returnData', array('success'=>false, 'message'=>'Authentication failed.'));
			}
		} else {
			$this->set('returnData', array('success'=>false, 'message'=>'Adding message failed.'));
		}
	}
}
