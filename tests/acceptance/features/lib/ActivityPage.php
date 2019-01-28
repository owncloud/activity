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
	protected $messageContainerXpath = "//div[@class='messagecontainer']";
	protected $messageTextXpath = "//div[@class='activitymessage']";

	protected $activityListFilterXpath = "//a[@data-navigation='%s']";

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
		return $activities[$index];
	}

	/**
	 * get all activity list
	 *
	 * @return string[]
	 */
	public function getAllActivityMessageLists() {
		$messages = [];
		$messagesElement =  $this->findAll("xpath", $this->activityListXpath);
		foreach ($messagesElement as $messageElement) {
			\array_push($messages, $this->getTrimmedText($messageElement));
		}
		return $messages;
	}

	/**
	 * filter activity list
	 *
	 * @param Session $session
	 * @param string $activityType
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function filterActivityListBy($session, $activityType) {
		$activityFilters = [
			'All Activities' => 'all',
			'Activities by you' => 'self',
			'Activity by others' => 'by',
			'Favourites' => 'files_favorites',
			'Comments' => 'comments',
			'Shares' => 'shares'
		];
		PHPUnit_Framework_Assert::assertArrayHasKey(
			$activityType,
			$activityFilters,
			__METHOD__ .
			"Could not find filter $activityType"
		);
		$filterXpath = \sprintf(
			$this->activityListFilterXpath,
			$activityFilters[$activityType]
		);
		$filter = $this->find("xpath", $filterXpath);
		$this->assertElementNotNull(
			$filter,
			__METHOD__ .
			" xpath $filterXpath" .
			"could not find filter"
		);
		$filter->click();
		$this->waitForAjaxCallsToStartAndFinish($session);
	}

	/**
	 * Return comment message of the given activity index
	 *
	 * @param string $index
	 *
	 * @return string|null
	 * @throws \Exception
	 */
	public function getCommentMessageOfIndex($index) {
		$messages = $this->findAll('xpath', $this->messageContainerXpath);
		$message = $messages[$index];
		$comment = $message->find('xpath', $this->messageTextXpath);
		if ($comment === null) {
			return null;
		}
		return $this->getTrimmedText($comment);
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
