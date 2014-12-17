<?php

namespace OCA\Activity\Sabre;

class Node extends \Sabre\DAV\File {

	/**
	 * @param array $activity
	 */
	public function __construct($activity) {
		$this->activity = $activity;
		$this->content = json_encode($this->activity, JSON_PRETTY_PRINT);
	}

	function getName() {
		return $this->activity['activity_id'];
	}

	public function getLastModified() {
		return $this->activity['timestamp'];
	}

	public function get() {
		return $this->content;
	}

	public function getContentType() {
		return 'application/vnd.owncloud.activity+json';
	}

	public function getSize() {
		return strlen($this->content);
	}

}
