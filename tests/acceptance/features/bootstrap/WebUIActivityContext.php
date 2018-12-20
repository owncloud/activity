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
	private $shareMessageFramework = "You shared %s with %s%s";

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
		$message = \sprintf($this->shareMessageFramework, $entry, $avatarText, $user);
		$latestActivityMessage = $this->activityPage->getActivityMessageOfIndex($index - 1);
		PHPUnit_Framework_Assert::assertEquals($message, $latestActivityMessage);
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
