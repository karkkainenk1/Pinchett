<?php
/* Image Fixture generated on: 2011-06-06 10:07:29 : 1307344049 */
class ImageFixture extends CakeTestFixture {
	var $name = 'Image';

	var $fields = array(
		'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
		'user_id' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'story_id' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'image' => array('type' => 'string', 'null' => false, 'default' => NULL, 'length' => 100, 'collate' => 'latin1_swedish_ci', 'charset' => 'latin1'),
		'created' => array('type' => 'datetime', 'null' => false, 'default' => NULL),
		'modified' => array('type' => 'datetime', 'null' => false, 'default' => NULL),
		'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1)),
		'tableParameters' => array('charset' => 'latin1', 'collate' => 'latin1_swedish_ci', 'engine' => 'MyISAM')
	);

	var $records = array(
		array(
			'id' => 1,
			'user_id' => 1,
			'story_id' => 1,
			'image' => 'Lorem ipsum dolor sit amet',
			'created' => '2011-06-06 10:07:29',
			'modified' => '2011-06-06 10:07:29'
		),
	);
}
