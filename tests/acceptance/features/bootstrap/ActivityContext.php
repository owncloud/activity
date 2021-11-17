<?php declare(strict_types=1);
/**
 * ownCloud
 *
 * @author Artur Neumann <info@jankaritech.com>
 * @copyright Copyright (c) 2018 Artur Neumann info@jankaritech.com
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
use Behat\Gherkin\Node\TableNode;
use PHPUnit\Framework\Assert;
use TestHelpers\HttpRequestHelper;

require_once 'bootstrap.php';

/**
 * Context for activity specific steps
 */
class ActivityContext implements Context {
	/**
	 * @var FeatureContext
	 */
	private $featureContext;

	/**
	 * @Then the activity number :index of user :user should match these properties:
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param TableNode $expectedProperties
	 *
	 * @return void
	 */
	public function activityWithIndexShouldMatch(
		string $index,
		string $user,
		TableNode $expectedProperties
	): void {
		$responseDecoded = $this->getActivitiesForUser($user);
		$activityData = $responseDecoded['ocs']['data'][$index - 1];
		foreach ($expectedProperties->getRowsHash() as $key => $value) {
			Assert::assertArrayHasKey(
				$key,
				$activityData
			);
			$value = $this->featureContext->substituteInLineCodes(
				$value,
				$user,
				['preg_quote' => ['/']]
			);
			Assert::assertNotFalse(
				(bool)\preg_match($value, $activityData[$key]),
				"'$value' does not match '{$activityData[$key]}'"
			);
		}
	}

	/**
	 * @Then user :user should not have any activity entries
	 *
	 * @param string $user
	 *
	 * @return void
	 */
	public function userShouldNotHaveAnyActivityEntries(
		string $user
	): void {
		$responseDecoded = $this->getActivitiesForUser($user);
		$activityDataArray = $responseDecoded['ocs']['data'];
		Assert::assertIsArray($activityDataArray);
		$numberOfActivityEntries = \count($activityDataArray);
		Assert::assertEquals(
			0,
			$numberOfActivityEntries,
			"User $user has $numberOfActivityEntries activity entries but should have none"
		);
	}

	/**
	 * @Then user :user should not have any activity entries with type :type
	 *
	 * @param string $user
	 * @param string $activityType
	 *
	 * @return void
	 */
	public function userShouldNotHaveAnyActivityEntriesWithType(
		string $user,
		string $activityType
	): void {
		$responseDecoded = $this->getActivitiesForUser($user);
		$activityDataArray = $responseDecoded['ocs']['data'];
		Assert::assertIsArray($activityDataArray);
		foreach ($activityDataArray as $activityData) {
			Assert::assertArrayHasKey(
				'type',
				$activityData
			);
			Assert::assertNotEquals(
				$activityType,
				$activityData['type'],
				"found an activity entry of type $activityType for user $user which should not exist"
			);
		}
	}

	/**
	 * @param string $user
	 *
	 * @return array of activity entries
	 */
	public function getActivitiesForUser(
		string $user
	): array {
		$user = $this->featureContext->getActualUsername($user);
		$fullUrl = $this->featureContext->getBaseUrl() .
			"/index.php/apps/activity/api/v2/activity";
		$response = HttpRequestHelper::get(
			$fullUrl,
			$this->featureContext->getStepLineRef(),
			$user,
			$this->featureContext->getPasswordForUser($user)
		);
		Assert::assertEquals(
			200,
			$response->getStatusCode()
		);
		$responseDecoded = \json_decode(
			$response->getBody()->getContents(),
			true
		);
		return $responseDecoded;
	}

	/**
	 * @BeforeScenario
	 *
	 * @param BeforeScenarioScope $scope
	 *
	 * @return void
	 * @throws Exception
	 */
	public function setUpScenario(BeforeScenarioScope $scope): void {
		// Get the environment
		$environment = $scope->getEnvironment();
		// Get all the contexts you need in this context
		$this->featureContext = $environment->getContext('FeatureContext');
	}
}
