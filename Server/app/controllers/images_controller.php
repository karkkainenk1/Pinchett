<?php
class ImagesController extends AppController {
	var $name = 'Images';
	var $components = array('Thumb');

	function getAll($story_id = null) {
		if($story_id == null) {
			$this->set('returnData', array('success'=>false, 'message'=>'Getting content failed'));
		} else {
			$images = $this->Image->find('list', array('order'=>'id DESC', 'conditions'=>array('story_id'=>$story_id)));
			$this->set('returnData', array('success'=>true, 'data'=>$images));
		}
	}

	function getScaledAndCutImageByStoryId($story_id) {
		$width = 70;
		$height = 70;
		if(!empty($this->data['Image']['width'])) {
			$width = $this->data['Image']['width'];
		}
		if(!empty($this->data['Image']['height'])) {
			$height = $this->data['Image']['height'];
		}
		$filename = $this->Image->findMostPopular($story_id);

		$this->Thumb->createCutThumb($filename, $width, $height);
		die();
	}

	function getScaledImageByStoryId($story_id) {
		$width = 70;
		$height = 70;
		if(!empty($this->data['Image']['width'])) {
			$width = $this->data['Image']['width'];
		}
		if(!empty($this->data['Image']['height'])) {
			$height = $this->data['Image']['height'];
		}
		$filename = $this->Image->findMostPopular($story_id);

		$this->Thumb->createThumb($filename, $width, $height);
		die();
	}

	function getScaledAndCutImageByImageId($image_id) {
		$width = 200;
		$height = 200;
		if(!empty($this->data['Image']['width'])) {
			$width = $this->data['Image']['width'];
		}
		if(!empty($this->data['Image']['height'])) {
			$height = $this->data['Image']['height'];
		}
		$imageData = $this->Image->findById($image_id);
		
		$filename = $imageData['Image']['image'];

		$this->Thumb->createCutThumb($filename, $width, $height);
		die();
	}

	function getScaledImageByImageId($image_id) {
		if(!empty($this->data['Image']['user_id']) && !empty($this->data['Image']['device_id'])) {
			$imageClickData = array();
			$imageClickData['ImageClick'] = array();
			$imageClickData['ImageClick']['image_id'] = $image_id;
			$imageClickData['ImageClick']['user_id'] = $this->data['Image']['user_id'];
			$this->Image->ImageClick->create();
			$this->Image->ImageClick->save($imageClickData);
		}

		$width = 200;
		$height = 200;
		if(!empty($this->data['Image']['width'])) {
			$width = $this->data['Image']['width'];
		}
		if(!empty($this->data['Image']['height'])) {
			$height = $this->data['Image']['height'];
		}
		$imageData = $this->Image->findById($image_id);
		
		$filename = $imageData['Image']['image'];

		$this->Thumb->createThumb($filename, $width, $height);
		die();
	}

	function add() {
		if(!empty($this->data) && !empty($this->data['Image']['user_id']) && !empty($this->data['Image']['device_id']) && !empty($this->data['Image']['story_id']) && is_uploaded_file($this->data['File']['tmp_name'])) {
			$user_id = $this->data['Image']['user_id'];
			$device_id = $this->data['Image']['device_id'];
			$story_id = $this->data['Image']['story_id'];
			$filename = $this->data['File']['tmp_name'];
			
			$image_name = md5($user_id.$device_id.microtime()).".jpg";
			if(move_uploaded_file($filename, '/var/www/proto/app/webroot/img/userpics/'.$image_name)) {
				$this->data['Image']['image'] = $image_name;
 				$user = $this->Image->User->findById($user_id);
				if(!empty($user['User']['device_id']) && $user['User']['device_id'] == $device_id) {
					$this->Image->create();
					if($this->Image->save($this->data)) {
						$texts = $this->Image->find('list', array('order'=>'id DESC', 'story_id'=>$story_id));
						$this->set('returnData', array('success'=>true));
					} else {
						print_r($this->Image->invalidFields());
						$this->set('returnData', array('success'=>false, 'message'=>'Adding image failed.'));
					}
				} else {
					$this->set('returnData', array('success'=>false, 'message'=>'Authentication failed.'));
				}
			} else {	
				$this->set('returnData', array('success'=>false, 'message'=>'Uploading image failed.'));
			}
	
		} else {
			$this->set('returnData', array('success'=>false, 'message'=>'Adding image failed.'));
		}
	}
}
