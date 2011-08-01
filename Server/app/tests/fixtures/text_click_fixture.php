<?php
/* TextClick Fixture generated on: 2011-06-06 10:21:34 : 1307344894 */
class TextClickFixture extends CakeTestFixture {
	var $name = 'TextClick';

	var $fields = array(
		'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
		'text_id' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'user_id' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'created' => array('type' => 'datetime', 'null' => false, 'default' => NULL),
		'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1)),
		'tableParameters' => array('charset' => 'latin1', 'collate' => 'latin1_swedish_ci', 'engine' => 'MyISAM')
	);

	var $records = array(
		array(
			'id' => 1,
			'text_id' => 1,
			'user_id' => 1,
			'created' => '2011-06-06 10:21:34'
		),
	);
}
