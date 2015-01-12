<?php

namespace OCA\Activity\Sabre;

use OCA\Activity\AppInfo\Application;

class Collection extends \Sabre\DAV\Collection {

	public function __construct() {

	}

	/**
	 * Returns an array with all the child nodes
	 *
	 * @return \Sabre\DAV\INode[]
	 */
	function getChildren() {
		$app = new Application();
		$data = $app->getContainer()->query('ActivityData');

		$start = 0;
		$count = 100;

		$activities = $data->read(
			$app->getContainer()->query('GroupHelper'),
			$app->getContainer()->query('UserSettings'),
			$start, $count, 'all'
		);

		return array_map(function($item) {
			return new Node($item);
		}, $activities);
	}

	/**
	 * Returns the name of the node.
	 *
	 * This is used to generate the url.
	 *
	 * @return string
	 */
	function getName() {
		return 'activities';
	}
}
