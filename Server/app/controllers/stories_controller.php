<?php
class StoriesController extends AppController {

	var $name = 'Stories';

	function getAddressForCoordinates($latitude, $longitude) {
		$url = "http://maps.googleapis.com/maps/api/geocode/json?";
		$url .= "sensor=false&";
		$url .= "latlng=".$latitude.",".$longitude;
		$responseData = file_get_contents($url);
		$responseArray = json_decode($responseData);
		return $responseArray->results[0]->address_components[1]->short_name." ".$responseArray->results[0]->address_components[0]->short_name;
	}

	function add() {
		if(!empty($this->data) && !empty($this->data['Story']['user_id']) && !empty($this->data['Story']['device_id'])) {
 			$user = $this->Story->User->findById($this->data['Story']['user_id']);
			$latitude = $this->data['Story']['latitude'];
			$longitude = $this->data['Story']['longitude'];
			$this->data['Story']['address'] = $this->getAddressForCoordinates($latitude, $longitude);
			if(!empty($user['User']['device_id']) && $user['User']['device_id'] == $this->data['Story']['device_id']) {
				$this->Story->create();
				$this->data['Story']['headline'] = trim($this->data['Story']['headline']);
				if($this->Story->save($this->data)) {
					$stories = $this->Story->findByLocation($latitude, $longitude);
					$this->set('returnData', array('success'=>true, 'data'=>$stories));
				} else {
					$this->set('returnData', array('success'=>false, 'message'=>'Adding story failed.'));
				}
			} else {
				$this->set('returnData', array('success'=>false, 'message'=>'Authentication failed.'));
			}
		} else {
			$this->set('returnData', array('success'=>false, 'message'=>'Adding story failed.'));
		}
	}


	function getById($id = null) {
		if (!$id) {
			$this->set('returnData', array('success'=>false, 'message'=>'Story not found.'));
		} else {
			if(!empty($this->data['Story']['user_id']) && !empty($this->data['Story']['device_id'])) {
				$storyClickData = array();
				$storyClickData['StoryClick'] = array();
				$storyClickData['StoryClick']['story_id'] = $id;
				$storyClickData['StoryClick']['user_id'] = $this->data['Story']['user_id'];
				$this->Story->StoryClick->create();
				$this->Story->StoryClick->save($storyClickData);
			}
			$story = $this->Story->read(null, $id);
			$story['Story']['date'] = date('j.n.Y H:i', strtotime($story['Story']['created']));
			$this->set('returnData', array('success'=>true, 'data'=>$story));
		}
	}

	function getContentByStoryId($id = null) {
		if ($id) {
			if(!empty($this->data['Story']['user_id']) && !empty($this->data['Story']['device_id'])) {
				$storyClickData = array();
				$storyClickData['StoryClick'] = array();
				$storyClickData['StoryClick']['story_id'] = $id;
				$storyClickData['StoryClick']['user_id'] = $this->data['Story']['user_id'];
				$this->Story->StoryClick->create();
				$this->Story->StoryClick->save($storyClickData);
			}
		}

		$this->set('returnData', array('success'=>true, 'data'=>$this->Story->getContentByStoryId($id)));
	}

	function getLatestForLocation() {
		$latitude = $this->data['Story']['latitude'];
		$longitude = $this->data['Story']['longitude'];
		$stories = $this->Story->findByLocation($latitude, $longitude);
		$this->set('returnData', array('success'=>true, 'data'=>$stories));
	}
}
