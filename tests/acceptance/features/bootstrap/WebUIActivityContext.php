<?php
/**
 * ownCloud
 *
 * @author Paurakh Sharma Humagain <paurakh@jankaritech.com>
 *
 * @copyright Copyright (c) 2018, JankariTech
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU AFFERO GENERAL PUBLIC LICENSE for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Gherkin\Node\PyStringNode;
use Behat\MinkExtension\Context\RawMinkContext;
use Page\ActivityPage;
use Page\LoginPage;

require_once 'bootstrap.php';

/**
 * WebUI Activity context.
 */
class WebUIActivityContext extends RawMinkContext implements Context {
	private $activityPage;

	/**
	 *
	 * @var WebUIGeneralContext
	 */
	private $webUIGeneralContext;

	/**
	 *
	 * @var FeatureContext
	 */
	private $featureContext;

	/**
	 *
	 * @var LoginPage
	 */
	private $loginPage;

	/**
	 * @var string
	 */
	private $youSharedMsgFramework = "You shared %s with %s%s";

	/**
	 * @var string
	 */
	private $sharedWithYouMsgFramework = "%s%s shared %s with you";

	/**
	 * WebUIAdminSharingSettingsContext constructor.
	 *
	 * @param ActivityPage $activityPage
	 * @param LoginPage $loginPage
	 */
	public function __construct(
		ActivityPage $activityPage,
		LoginPage $loginPage
	) {
		$this->activityPage = $activityPage;
		$this->loginPage = $loginPage;
	}

	/**
	 * @Given user :user has browsed to the activity page
	 * @When user :user browses to the activity page
	 *
	 * @param string $user
	 *
	 * @return void
	 */
	public function userHasBrowsedToTheActivityPage($user) {
		$this->loginPage->open();
		$this->webUIGeneralContext->loginAs(
			$user, $this->featureContext->getUserPassword($user)
		);
		$this->activityPage->open();
		$this->activityPage->waitTillPageIsLoaded($this->getSession());
		$this->webUIGeneralContext->setCurrentPageObject($this->activityPage);
	}

	/**
	 * @When the user filters activity list by :activityType
	 *
	 * @param string $activityType
	 *
	 * @return void
	 */
	public function theUserFiltersActivityListBy($activityType) {
		$this->activityPage->filterActivityListBy($this->getSession(), $activityType);
	}

	/**
	 * @Then the comment message for activity number :index in the activity page should be:
	 *
	 * @param int $index
	 * @param string $message
	 *
	 * @return void
	 *
	 * @throws \Exception
	 */
	public function theCommentMessageShouldBeListedOnTheActivityPage($index, PyStringNode $message) {
		$commentMsg = $this->activityPage->getCommentMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertNotNull($commentMsg, "Could not find comment message.");
		PHPUnit_Framework_Assert::assertEquals($message, $commentMsg);
	}

	/**
	 * @Then the activity number :index should not contain any comment message in the activity page
	 *
	 * @param int $index
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldNotContainAnyCommentMessageInTheActivityPage($index) {
		$commentMsg = $this->activityPage->getCommentMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertNull($commentMsg, "Comment exists with content: $commentMsg");
	}

	/**
	 * @Then the activity number :index should have message :message in the activity page
	 *
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $message
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveMessageInTheActivityPage($index, $message) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$message = $this->featureContext->substituteInLineCodes($message);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity number :index should have a message saying that you have shared file/folder :entry with user :user
	 *
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $entry
	 * @param string $user
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingSharedFolderWithUser(
		$index, $entry, $user
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarText = \strtoupper($user[0]);
		//Need to add username initial at the beginning because if there is no avatar of the user then,
		// the username initial is shown in the webUI
		$message = \sprintf($this->youSharedMsgFramework, $entry, $avatarText, $user);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then /^the activity number (\d+) should contain message "([^"]*)" in the activity page$/
	 *
	 * @param int $index
	 * @param string $message
	 *
	 * @return void
	 */
	public function theActivityNumberShouldContainMessageInTheActivityPage($index, $message) {
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertContains($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity number :index should have a message saying that user :user has shared :entry with you
	 *
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param string $entry
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatUserHasSharedWithYou(
		$index, $user, $entry
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarText = \strtoupper($user[0]);
		$message = \sprintf($this->sharedWithYouMsgFramework, $avatarText, $user, $entry);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity should not have any message with keyword :tag
	 *
	 * @param string $tag
	 *
	 * @return void
	 */
	public function theActivityShouldNotHaveAnyMessageWithKeyword($tag) {
		$activities = $this->activityPage->getAllActivityMessageLists();
		foreach ($activities as $activity) {
			PHPUnit_Framework_Assert::assertNotContains($tag, $activity);
		}
	}

	/**
	 * This will run before EVERY scenario.
	 * It will set the properties for this object.
	 *
	 * @BeforeScenario @webUI
	 *
	 * @param BeforeScenarioScope $scope
	 *
	 * @return void
	 */
	public function before(BeforeScenarioScope $scope) {
		// Get the environment
		$environment = $scope->getEnvironment();
		// Get all the contexts you need in this context
		$this->webUIGeneralContext = $environment->getContext('WebUIGeneralContext');
		$this->featureContext = $environment->getContext('FeatureContext');
	}
}
