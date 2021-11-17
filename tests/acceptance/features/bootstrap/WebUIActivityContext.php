<?php declare(strict_types=1);

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
use Behat\Gherkin\Node\TableNode;

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
	public function userHasBrowsedToTheActivityPage(): void {
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
	public function theUserFiltersActivityListBy(string $activityType): void {
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
		string $disablesOrEnables,
		string $streamOrMail,
		string $activityType
	): void {
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
	 * @param string $index
	 * @param PyStringNode $message
	 *
	 * @return void
	 *
	 * @throws \Exception
	 */
	public function theCommentMessageShouldBeListedOnTheActivityPage(
		string $index,
		PyStringNode $message
	): void {
		$commentMsg = $this->activityPage->getCommentMessageOfIndex($index);
		PHPUnit\Framework\Assert::assertNotNull($commentMsg, "Could not find comment message.");
		PHPUnit\Framework\Assert::assertEquals($message, $commentMsg);
	}

	/**
	 * @Then the activity number :index should not contain any comment message in the activity page
	 *
	 * @param string $index
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldNotContainAnyCommentMessageInTheActivityPage(string $index): void {
		$commentMsg = $this->activityPage->getCommentMessageOfIndex($index);
		PHPUnit\Framework\Assert::assertNull($commentMsg, "Comment exists with content: $commentMsg");
	}

	/**
	 * @Then the activity number :index should have message :message in the activity page/tab
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $message
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveMessageInTheActivityPage(
		string $index,
		string $message
	): void {
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
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $entry
	 * @param string $user
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingSharedFolderWithUser(
		string $index,
		string $entry,
		string $user
	): void {
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
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $entry
	 * @param string $user
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingUnsharedFileFromSelf(
		string $index,
		string $entry,
		string $user
	): void {
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
	 * @param string $index
	 * @param string $message
	 *
	 * @return void
	 */
	public function theActivityNumberShouldContainMessageInTheActivityPage(
		string $index,
		string $message
	): void {
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit\Framework\Assert::assertStringContainsString($message, $latestActivityMessage);
	}

	/**
	 * @Then the activity number :index should have a message saying that user :user has shared :entry with you
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param string $entry
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatUserHasSharedWithYou(
		string $index,
		string $user,
		string $entry
	): void {
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
	 * @Then the activity number :index should have a message saying that you restored the following files in the activity page:
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param TableNode $resource
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageAboutBatchRestoreInTheActivityPage(
		string $index,
		TableNode $resource
	): void {
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		$resource_array = [];
		foreach ($resource->getHash() as $row) {
			// checks if the file/folder name is present in the latest activity message log
			$entryCount = \substr_count($latestActivityMessage, $row['entry']);
			if ($entryCount === 1) {
				\array_push($resource_array, $row['entry']);
			} elseif ($entryCount < 1) {
				throw new Exception(\sprintf("%s entry not present in the log", $row['entry']));
			} else {
				throw new Exception(\sprintf("% entry present %d times in the log", $row['entry'], $entryCount));
			}
		}
		$join = "(" . \implode('|', $resource_array) . ")";
		if (\sizeof($resource->getHash()) === 1) {
			$message = "/You restored $join/";
		} else {
			$message = "/You restored [$join, *]* and $join/";
		}
		$matchRegex = \preg_match($message, $latestActivityMessage);
		PHPUnit\Framework\Assert::assertEquals(1, $matchRegex);
	}

	/**
	 * @Then the activity number :index should have a message saying that user :sharer has shared :entry with user :sharee
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $sharer
	 * @param string $entry
	 * @param string $sharee
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatUserHasSharedWithUser(
		string $index,
		string $sharer,
		string $entry,
		string $sharee
	): void {
		if ($index < 1) {
			throw new InvalidArgumentException(
				"activity index starts from 1"
			);
		}
		$avatarTextSharer = \strtoupper($sharer[0]);
		$avatarTextSharee = \strtoupper($sharee[0]);
		$message = \sprintf(
			$this->userSharedWithUserMsgFramework,
			$avatarTextSharer,
			$sharer,
			$entry,
			$avatarTextSharee,
			$sharee
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
	public function theActivityShouldNotHaveAnyMessageWithKeyword(string $tag): void {
		$activities = $this->activityPage->getAllActivityMessageLists();
		foreach ($activities as $activity) {
			PHPUnit\Framework\Assert::assertStringNotContainsString($tag, $activity);
		}
	}

	/**
	 * @Then /^the activity number (\d+) should have a message saying that user "([^"]*)" (created|deleted) system tag "([^"]*)"$/
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param string $createdOrDeleted
	 * @param string $tagName
	 *
	 * @return void
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatUserCreatedOrDeletedSystemTagLorem(
		string $index,
		string $user,
		string $createdOrDeleted,
		string $tagName
	): void {
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
	public function theActivityListShouldBeEmpty(): void {
		$activities = $this->activityPage->getAllActivityMessageLists();
		PHPUnit\Framework\Assert::assertEmpty(
			$activities,
			"Activity list was expected to be empty but was not"
		);
	}

	/**
	 * @Then /^the activity number (\d+) should have a message saying that user "([^"]*)" (created|deleted|changed) "([^"]*)"$/
	 *
	 * @param string $index
	 * @param string $user
	 * @param string $createdDeletedOrChanged
	 * @param string $entry
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldHaveAMessageUserCreatedOrDeletedOrChanged(
		string $index,
		string $user,
		string $createdDeletedOrChanged,
		string $entry
	): void {
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
	 * @param string $index
	 * @param string $youOrUser
	 * @param string $sharer
	 * @param string $entry
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatYouRemovedTheShareOfFor(
		string $index,
		string $youOrUser,
		string $sharer,
		string $entry
	): void {
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
	 * @param string $index
	 * @param string $user
	 * @param string $entry
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function theActivityNumberShouldHaveAMessageSayingThatRemovedTheShareFor(
		string $index,
		string $user,
		string $entry
	): void {
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
		string $index,
		string $prepos,
		string $user
	): void {
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
	public function before(BeforeScenarioScope $scope): void {
		// Get the environment
		$environment = $scope->getEnvironment();
		// Get all the contexts you need in this context
		$this->webUIGeneralContext = $environment->getContext('WebUIGeneralContext');
		$this->featureContext = $environment->getContext('FeatureContext');
	}
}
