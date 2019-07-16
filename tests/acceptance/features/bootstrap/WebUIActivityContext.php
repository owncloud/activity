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
use Page\ActivitySettingForm;
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
	 *
	 * @var ActivitySettingForm
	 */
	private $activitySettingForm;

	/**
	 * @var string
	 */
	private $youSharedMsgFramework = "You shared %s with %s%s";

	/**
	 * @var string
	 */
	private $youUnSharedMsgFramework = "You unshared %s shared by %s%s from self";

	/**
	 * @var string
	 */
	private $sharedWithYouMsgFramework = "%s%s shared %s with you";

	/**
	 * @var string
	 */
	private $userSharedWithUserMsgFramework = "%s%s shared %s with %s%s";

	/**
	 * @var string
	 */
	private $userCreatedSystemTagMsgFramework = "%s%s created system tag %s";

	/**
	 * @var string
	 */
	private $userDeletedSystemTagMsgFramework = "%s%s deleted system tag %s";

	/**
	 * @var string
	 */
	private $userCreatedMsgFramework = "%s%s created %s";

	/**
	 * @var string
	 */
	private $userDeletedMsgFramework = "%s%s deleted %s";

	/**
	 * @var string
	 */
	private $userChangedMsgFramework = "%s%s changed %s";

	/**
	 * @var string
	 */
	private $youRemovedTheShareOfForMsgFramework = "You removed the share of %s%s for %s";

	/**
	 * @var string
	 */
	private $userRemovedTheShareOfForMsgFramework = "%s%s removed the share of %s%s for %s";

	/**
	 * @var string
	 */
	private $userRemovedTheShareForMsgFramework = "%s%s removed the share for %s";

	/**
	 * @var string
	 */
	private $sharedWithUserTabMsgFramework = "Shared %s %s%s";

	/**
	 * WebUIAdminSharingSettingsContext constructor.
	 *
	 * @param ActivitySettingForm $activitySettingForm
	 * @param ActivityPage $activityPage
	 * @param LoginPage $loginPage
	 */
	public function __construct(
		ActivitySettingForm $activitySettingForm,
		ActivityPage $activityPage,
		LoginPage $loginPage
	) {
		$this->activitySettingForm = $activitySettingForm;
		$this->activityPage = $activityPage;
		$this->loginPage = $loginPage;
	}

	/**
	 * @Given the user has browsed to the activity page
	 * @When the user browses to the activity page
	 *
	 * @return void
	 */
	public function userHasBrowsedToTheActivityPage() {
		if (!$this->activityPage->isOpen()) {
			$this->activityPage->open();
			$this->activityPage->waitTillPageIsLoaded($this->getSession());
			$this->webUIGeneralContext->setCurrentPageObject($this->activityPage);
		}
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
	 * @When /^the user (disables|enables) activity log (stream|mail) for "([^"]*)" using the webUI$/
	 *
	 * @param string $disablesOrEnables
	 * @param string $streamOrMail
	 * @param string $activityType
	 *
	 * @return void
	 */
	public function theUseTriggersActivityLogSettingUsingTheWebui(
		$disablesOrEnables,
		$streamOrMail,
		$activityType
	) {
		$this->activitySettingForm->changeActivityLogSetting(
			$disablesOrEnables,
			$streamOrMail,
			$activityType,
			$this->getSession()
		);
	}

	/**
	 * @Then the comment message for activity number :index in the activity page/tab should be:
	 *
	 * @param int $index
	 * @param string $message
	 *
	 * @return void
	 *
	 * @throws \Exception
	 */
	public function theCommentMessageShouldBeListedOnTheActivityPage($index, PyStringNode $message) {
		$commentMsg = $this->activityPage->getCommentMessageOfIndex($index);
		PHPUnit\Framework\Assert::assertNotNull($commentMsg, "Could not find comment message.");
		PHPUnit\Framework\Assert::assertEquals($message, $commentMsg);
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
		$commentMsg = $this->activityPage->getCommentMessageOfIndex($index);
		PHPUnit\Framework\Assert::assertNull($commentMsg, "Comment exists with content: $commentMsg");
	}

	/**
	 * @Then the activity number :index should have message :message in the activity page/tab
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
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
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
		$index,
		$entry,
		$user
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarText = \strtoupper($user[0]);
		//Need to add username initial at the beginning because if there is no avatar of the user then,
		// the username initial is shown on the webui
		$message = \sprintf($this->youSharedMsgFramework, $entry, $avatarText, $user);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity number :index should have a message saying that you have unshared file/folder :entry shared by :user from self
	 *
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $entry
	 * @param string $user
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingUnsharedFileFromSelf(
		$index,
		$entry,
		$user
	) {
		$avatarText = \strtoupper($user[0]);
		//Need to add username initial at the beginning because if there is no avatar of the user then,
		// the username initial is shown on the webui
		$message = \sprintf($this->youUnSharedMsgFramework, $entry, $avatarText, $user);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then /^the activity number (\d+) should contain message "([^"]*)" in the activity (page|tab)$/
	 *
	 * @param int $index
	 * @param string $message
	 *
	 * @return void
	 */
	public function theActivityNumberShouldContainMessageInTheActivityPage($index, $message) {
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit\Framework\Assert::assertContains($message, $latestActivityMessage);
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
		$index,
		$user,
		$entry
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarText = \strtoupper($user[0]);
		$message = \sprintf($this->sharedWithYouMsgFramework, $avatarText, $user, $entry);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity number :index should have a message saying that user :user1 has shared :entry with user :user2
	 *
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $user1
	 * @param string $entry
	 * @param string $user2
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatUserHasSharedWithUser(
		$index,
		$user1,
		$entry,
		$user2
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarTextUser1 = \strtoupper($user1[0]);
		$avatarTextUser2 = \strtoupper($user2[0]);
		$message = \sprintf(
			$this->userSharedWithUserMsgFramework,
			$avatarTextUser1,
			$user1,
			$entry,
			$avatarTextUser2,
			$user2
		);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
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
			PHPUnit\Framework\Assert::assertNotContains($tag, $activity);
		}
	}

	/**
	 * @Then /^the activity number (\d+) should have a message saying that user "([^"]*)" (created|deleted) system tag "([^"]*)"$/
	 *
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param string $createdOrDeleted
	 * @param string $tagName
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatUserCreatedOrDeletedSystemTagLorem(
		$index,
		$user,
		$createdOrDeleted,
		$tagName
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarText = \strtoupper($user[0]);
		if ($createdOrDeleted === "created") {
			$msgFramework = $this->userCreatedSystemTagMsgFramework;
		} else {
			$msgFramework = $this->userDeletedSystemTagMsgFramework;
		}
		$message = \sprintf(
			$msgFramework,
			$avatarText,
			$user,
			$tagName
		);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex(
			$index - 1
		);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity list should be empty
	 *
	 * @return void
	 */
	public function theActivityListShouldBeEmpty() {
		$activities = $this->activityPage->getAllActivityMessageLists();
		PHPUnit\Framework\Assert::assertEmpty(
			$activities,
			"Activity list was expected to be empty but was not"
		);
	}

	/**
	 * @Then /^the activity number (\d+) should have a message saying that user "([^"]*)" (created|deleted|changed) "([^"]*)"$/
	 *
	 * @param integer $index
	 * @param string $user
	 * @param string $createdDeletedOrChanged
	 * @param string $entry
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldHaveAMessageUserCreatedOrDeletedOrChanged(
		$index,
		$user,
		$createdDeletedOrChanged,
		$entry
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarText = \strtoupper($user[0]);
		if ($createdDeletedOrChanged === "created") {
			$msgFramework = $this->userCreatedMsgFramework;
		} elseif ($createdDeletedOrChanged === "deleted") {
			$msgFramework = $this->userDeletedMsgFramework;
		} else {
			$msgFramework = $this->userChangedMsgFramework;
		}
		$message = \sprintf($msgFramework, $avatarText, $user, $entry);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex(
			$index - 1
		);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then /^the activity number (\d+) should have a message saying that (you|"[^"]*") removed the share of "([^"]*)" for "([^"]*)"$/
	 *
	 * @param integer $index
	 * @param string $youOrUser
	 * @param string $sharer
	 * @param string $entry
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatYouRemovedTheShareOfFor(
		$index,
		$youOrUser,
		$sharer,
		$entry
	) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$sharerAvaterText = \strtoupper($sharer[0]);
		if ($youOrUser === "you") {
			$message = \sprintf(
				$this->youRemovedTheShareOfForMsgFramework,
				$sharerAvaterText,
				$sharer,
				$entry
			);
		} else {
			$youOrUser = \trim($youOrUser, '"');
			$userAvatarText = \strtoupper($youOrUser[0]);
			$message = \sprintf(
				$this->userRemovedTheShareOfForMsgFramework,
				$userAvatarText,
				$youOrUser,
				$sharerAvaterText,
				$sharer,
				$entry
			);
		}

		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex(
			$index - 1
		);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then /^the activity number (\d+) should have a message saying that "([^"]*)" removed the share for "([^"]*)"$/
	 *
	 * @param integer $index
	 * @param string $user
	 * @param string $entry
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatRemovedTheShareFor($index, $user, $entry) {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$userAvatarText = \strtoupper($user[0]);
		$message = \sprintf(
			$this->userRemovedTheShareForMsgFramework,
			$userAvatarText,
			$user,
			$entry
		);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex(
			$index - 1
		);
		PHPUnit\Framework\Assert::assertEquals($message, $latestActivityMessage);
	}

	/**
	 * @Then /^the activity number (\d+) should have message saying that the (?:file|folder|entry) is shared (with|by) user "([^"]*)" in the activity tab$/
	 *
	 * @param string  $index
	 * @param string  $prepos
	 * @param string  $user
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveMessageSayingSharedWithInTheActivityTab(
		$index,
		$prepos,
		$user
	) {
		$actualMsg = $this->activityPage->getActivityMessageOfIndex($index - 1);
		$expectedMsg = \sprintf(
			$this->sharedWithUserTabMsgFramework,
			$prepos,
			\strtoupper($user[0]),
			$user
		);
		PHPUnit\Framework\Assert::assertEquals($expectedMsg, $actualMsg);
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
