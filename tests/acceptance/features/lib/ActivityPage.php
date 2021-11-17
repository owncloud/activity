<?php declare(strict_types=1);

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

use PHPUnit\Framework\Assert;
use Behat\Mink\Session;

/**
 * Activity page
 *
 * Works for both Activity page and 'Activity' tab on the details dialog currently.
 *
 * As they both are sharing the similar structure, if, in the future, the
 * activity app gets an overhaul, it might require us to have two separate pages.
 */
class ActivityPage extends OwncloudPage {

	/**
	 *
	 * @var string $path
	 */
	protected $path = '/index.php/apps/activity';

	protected $activityContainerXpath = "//div[@class='boxcontainer']";
	protected $noActivityIconXpath = "//div[@class='icon-activity']";

	protected $activityListXpath = "//div[@class='activitysubject']";
	protected $avatarClassXpath = "(//div[@class='activitysubject'])[%s]//div[@class='avatar']";
	protected $fileNameFieldXpath = "(//div[@class='activitysubject'])[%s]//a[@class='filename has-tooltip']";

	protected $messageTextXpath = "(//div[@class='activitysubject'])[%s]/../*[@class='activitymessage']";

	protected $activityListFilterXpath = "//a[@data-navigation='%s']";

	/**
	 * get specified activity message
	 *
	 * @param integer $index
	 *
	 * @return string
	 */
	public function getActivityMessageOfIndex(int $index): string {
		$activities = $this->getAllActivityMessageLists();
		Assert::assertArrayHasKey(
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
	public function getAllActivityMessageLists(): array {
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
	public function filterActivityListBy(Session $session, string $activityType): void {
		$activityFilters = [
			'All Activities' => 'all',
			'Activities by you' => 'self',
			'Activities by others' => 'by',
			'Favorites' => 'files_favorites',
			'Comments' => 'comments',
			'Shares' => 'shares',
			'Antivirus' => 'files_antivirus',
			'Files' => 'files'
		];
		Assert::assertArrayHasKey(
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
	 * 		The index starts from 1 as it's retrieved from xpath directly
	 *      Note: this is called with the "text" from a test step, so it comes
	 *            as a string, although it is expected to be a numeric string.
	 *
	 * @throws \Exception
	 *
	 * @return string|null
	 */
	public function getCommentMessageOfIndex(string $index): ?string {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"comment index starts from 1"
			);
		}
		$commentMsgXpath = \sprintf($this->messageTextXpath, $index);
		$messageElement =  $this->find('xpath', $commentMsgXpath);
		if ($messageElement === null) {
			return null;
		}
		return $this->getTrimmedText($messageElement);
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
		int $timeout_msec = STANDARD_UI_WAIT_TIMEOUT_MILLISEC
	): void {
		$container = $this->waitTillElementIsNotNull(
			$this->activityContainerXpath,
			$timeout_msec
		);
		if ($container === null) {
			$this->waitTillXpathIsVisible(
				$this->noActivityIconXpath,
				$timeout_msec
			);
		}
	}
}
