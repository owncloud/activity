<?php

/**
 * ownCloud
 *
 * @author Paurakh Sharma Humagain <paurakh@jankaritech.com>
 *
 * @copyright Copyright (c) 2018, JankariTech
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License,
 * as published by the Free Software Foundation;
 * either version 3 of the License, or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 *
 */
namespace Page;

use PHPUnit_Framework_Assert;
use Behat\Mink\Session;
use Behat\Mink\Element\NodeElement;

/**
 * Activity page.
 */
class ActivityPage extends OwncloudPage {

	/**
	 *
	 * @var string $path
	 */
	protected $path = '/index.php/apps/activity';

	protected $activityContainerXpath = "//div[@class='boxcontainer']";

	protected $activityListXpath = "//div[@class='activitysubject']";
	protected $avatarClassXpath = "(//div[@class='activitysubject'])[%s]//div[@class='avatar']";
	protected $fileNameFieldXpath = "(//div[@class='activitysubject'])[%s]//a[@class='filename has-tooltip']";

	/**
	 * get specified activity message
	 *
	 * @param integer $index
	 *
	 * @return string
	 */
	public function getActivityMessageOfIndex($index) {
		$activities = $this->getAllActivityMessageLists();
		PHPUnit_Framework_Assert::assertArrayHasKey(
			$index,
			$activities,
			__METHOD__ .
			"Could not find the index $index in the activity list"
		);
		$activity  = $activities[$index];
		return $this->getTrimmedText($activity);
	}

	/**
	 * get all activity list
	 *
	 * @return NodeElement[]
	 */
	public function getAllActivityMessageLists() {
		return $this->findAll("xpath", $this->activityListXpath);
	}

	/**
	 * waits for the page to appear completely
	 *
	 * @param Session $session
	 * @param int $timeout_msec
	 *
	 * @return void
	 */
	public function waitTillPageIsLoaded(
		Session $session,
		$timeout_msec = STANDARD_UI_WAIT_TIMEOUT_MILLISEC
	) {
		$this->waitTillXpathIsVisible(
			$this->activityContainerXpath, $timeout_msec
		);
	}
}
