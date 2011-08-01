<?php
/* StoryClick Fixture generated on: 2011-06-06 10:19:42 : 1307344782 */
class StoryClickFixture extends CakeTestFixture {
	var $name = 'StoryClick';

	var $fields = array(
		'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
		'story_id' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'user_id' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'created' => array('type' => 'datetime', 'null' => false, 'default' => NULL),
		'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1)),
		'tableParameters' => array('charset' => 'latin1', 'collate' => 'latin1_swedish_ci', 'engine' => 'MyISAM')
	);

	var $records = array(
		array(
			'id' => 1,
			'story_id' => 1,
			'user_id' => 1,
			'created' => '2011-06-06 10:19:42'
		),
	);
}
