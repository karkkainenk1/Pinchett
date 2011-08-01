<?php
class Story extends AppModel {
	var $name = 'Story';
	var $displayField = 'headline';
	var $order = 'Story.modified DESC';
	var $validate = array(
		'id' => array(
			'numeric' => array(
				'rule' => array('numeric'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			),
			'notempty' => array(
				'rule' => array('notempty'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			)
		),
		'user_id' => array(
			'numeric' => array(
				'rule' => array('numeric'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			),
			'notempty' => array(
				'rule' => array('notempty'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			)
		),
		'headline' => array(
			'notempty' => array(
				'rule' => array('notempty'),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			),
			'minlength' => array(
				'rule' => array('minlength'=>3),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			),
			'maxlength' => array(
				'rule' => array('maxlength'=>255),
				//'message' => 'Your custom message here',
				//'allowEmpty' => false,
				//'required' => false,
				//'last' => false, // Stop validation after this rule
				//'on' => 'create', // Limit validation to 'create' or 'update' operations
			)
		),
	);
	//The Associations below have been created with all possible keys, those that are not needed can be removed

	var $belongsTo = array(
		'User' => array(
			'className' => 'User',
			'foreignKey' => 'user_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		)
	);

	var $hasMany = array(
		'Image' => array(
			'className' => 'Image',
			'foreignKey' => 'story_id',
			'dependent' => false,
			'conditions' => '',
			'fields' => '',
			'order' => 'clicks DESC',
			'limit' => '',
			'offset' => '',
			'exclusive' => '',
			'finderQuery' => '',
			'counterQuery' => ''
		),
		'Text' => array(
			'className' => 'Text',
			'foreignKey' => 'story_id',
			'dependent' => false,
			'conditions' => '',
			'fields' => '',
			'order' => '',
			'limit' => '',
			'offset' => '',
			'exclusive' => '',
			'finderQuery' => '',
			'counterQuery' => ''
		),
		'StoryClick' => array(
			'className' => 'StoryClick',
			'foreignKey' => 'story_id'
		)
	);

	function distanceComparison($first, $second) {
		$firstDist = $first['Story']['comparisonDistance'];
		$secondDist = $second['Story']['comparisonDistance'];

		$delta = abs($firstDist - $secondDist);

		if($delta > 50 && $firstDist > $secondDist) {
			return 1;
		} elseif($delta > 50 && $firstDist < $secondDist) {
			return -1;
		} elseif($first['Story']['modified'] < $second['Story']['modified']) {
			return 1;
		} else {
			return -1;
		}
	}


	function findByLocation($latitude, $longitude) {
		$this->bindModel(
			array('hasMany' => array(
				'Text' => array(
					'className' => 'Text',
					'foreignKey' => 'story_id',
					'dependent' => false,
					'fields' => array('content'),
					'order' => 'id DESC',
					'limit' => 1
				),
				'Image' => array(
					'className' => 'Image',
					'foreignKey' => 'story_id',
					'fields' => 'id',
					'order' => 'clicks DESC, id DESC',
					'limit' => 1
				))
			)
		);

		$latitude = mysql_real_escape_string($latitude);
		$longitude = mysql_real_escape_string($longitude);
		$distance = "(acos(sin(radians(latitude))*sin(radians(".$latitude."))+cos(radians(latitude))*cos(radians(".$latitude."))*cos(radians(".$longitude.")-radians(longitude)))*6371000)";
		$stories = $this->find('all', array('limit'=>10, 'fields'=>array("Story.id", "Story.headline", "Story.created", "Story.address", $distance." AS distance", "Story.score"), 'group'=>'Story.id HAVING distance < 3000'));

		$totalScore = 0;

		foreach($stories AS $key => $value) {
			$stories[$key]['Story']['distance'] = $stories[$key][0]['distance'];


			if(isset($stories[$key]['Text'][0]['content'])) {
				$stories[$key]['Story']['text'] = $stories[$key]['Text'][0]['content'];
				unset($stories[$key]['Text']);
			} else {
				$stories[$key]['Story']['text'] = '';
			}

			if(!empty($stories[$key]['Image'])) {
				$stories[$key]['Story']['image_id'] = $stories[$key]['Image'][0]['id'];
				unset($stories[$key]['Image']);
			} else {
				$stories[$key]['Story']['image_id'] = null;
			}

			if($stories[$key]['Story']['distance'] < 100) {
				$stories[$key]['Story']['distance'] = "<100 m";
			} else if($stories[$key]['Story']['distance'] < 1000) {
				$stories[$key]['Story']['distance'] = ((int)((($stories[$key]['Story']['distance']+50)/100))*100) . " m";
			} else {
				$stories[$key]['Story']['distance'] = ((int)(($stories[$key]['Story']['distance']+500)/1000)) . " km";
			}


			//$stories[$key]['Story']['date'] = date('j.n.Y H:i', strtotime($stories[$key]['Story']['created']));

			
			$date = date('j.n.Y', strtotime($stories[$key]['Story']['created']));
			$time = date('H:i', strtotime($stories[$key]['Story']['created']));

			$stories[$key]['Story']['date'] = $date . " " . $time;
			$stories[$key]['Story']['date'] = $this->prettyDate($date . " " . $time);

			$stories[$key]['Story']['image_data'] = null;

			$totalScore += $stories[$key]['Story']['score'];
		}


		if($totalScore < 1) $totalScore = 1;

		foreach($stories AS $key => $value) {
			$stories[$key]['Story']['comparisonDistance'] = $stories[$key][0]['distance'] - 7000*($stories[$key]['Story']['score']/$totalScore);

			if(strtotime('now')-strtotime($stories[$key]['Story']['created']) < 300) $stories[$key]['Story']['comparisonDistance'] -= 10000; 
			//unset($stories[$key][0]);
			unset($stories[$key]['StoryClick']);
		}

		usort($stories, array('self', 'distanceComparison'));

		return $stories;
	}
	
	function getContentByStoryId($storyId) {
		$this->bindModel(
			array('hasMany' => array(
				'Text' => array(
					'className' => 'Text',
					'foreignKey' => 'story_id',
					'dependent' => false,
					'fields' => array('content', 'created', 'user_id'),
					'order' => 'id DESC',
				),
				'Image' => array(
					'className' => 'Image',
					'foreignKey' => 'story_id',
					'fields' => array('id', 'created', 'user_id'),
					'order' => 'clicks DESC, id DESC',
				))
			)
		);
		
		$storyData = $this->findById($storyId);
		
		/*$imageArray = $storyData['Image'];
		$textArray = $storyData['Text'];
	
		$combinedArray = array();

		$i = 0;
		while($i < count($imageArray) || $i < count($textArray)) {
			if($i < count($imageArray)) {
				$imageArray[$i]['type'] = 'image';
				array_push($combinedArray, $imageArray[$i]);
			}

			if($i < count($textArray)) {
				$textArray[$i]['type'] = 'text';
				array_push($combinedArray, $textArray[$i]);
			}
			$i++;
		}
		
		$storyData['content'] = $combinedArray;
		*/

		$date = date('j.n.Y', strtotime($storyData['Story']['created']));
		$time = date('H:i', strtotime($storyData['Story']['created']));

		$storyData['Story']['date'] = $this->prettyDate($date . " " . $time);

		foreach($storyData['Text'] AS $key => $text) {
			$date = date('j.n.Y', strtotime($storyData['Text'][$key]['created']));
			$time = date('H:i', strtotime($storyData['Text'][$key]['created']));
			$storyData['Text'][$key]['date'] = $this->prettyDate($date . " " . $time);

			$userData = $this->User->findById($storyData['Text'][$key]['user_id']);
			$storyData['Text'][$key]['username'] = $userData['User']['name'];
		}

		foreach($storyData['Image'] AS $key => $image) {
			$date = date('j.n.Y', strtotime($storyData['Image'][$key]['created']));
			$time = date('H:i', strtotime($storyData['Image'][$key]['created']));
			$storyData['Image'][$key]['date'] = $this->prettyDate($date . " " . $time);
			
			$userData = $this->User->findById($storyData['Image'][$key]['user_id']);
			$storyData['Image'][$key]['username'] = $userData['User']['name'];
		}

		return $storyData;
	}

	function prettyDate($fromDate) {
                $time = date('H:i', strtotime($fromDate));

                $currentDateTime = new DateTime(date('j.n.Y', strtotime('today')));
                $fromDateTime = new DateTime(date('Y-m-d', strtotime($fromDate)));

                $difference = $fromDateTime->diff($currentDateTime)->format('%a');

                if($difference == '0') {
                        $date = "Today " . $time;
                } else if($difference == '1') {
                        $date = "Yesterday " . $time;
                } else {
                        $date = $difference.' days ago';
                }

		return $date;
	}
}
