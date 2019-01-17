<?php
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
	 * @param integer $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param TableNode $expectedProperties
	 *
	 * @return void
	 */
	public function activityWithIndexShouldMatch(
		$index, $user, TableNode $expectedProperties
	) {
		$user = $this->featureContext->getActualUsername($user);
		$fullUrl = $this->featureContext->getBaseUrl() .
				   "/index.php/apps/activity/api/v2/activity";
		$response = HttpRequestHelper::get(
			$fullUrl,
			$user,
			$this->featureContext->getPasswordForUser($user)
		);
		PHPUnit_Framework_Assert::assertEquals(
			200, $response->getStatusCode()
		);
		$responseDecoded = \json_decode(
			$response->getBody()->getContents(), true
		);
		$activityData = $responseDecoded['ocs']['data'][$index - 1];
		foreach ($expectedProperties->getRowsHash() as $key => $value) {
			PHPUnit_Framework_Assert::assertArrayHasKey(
				$key, $activityData
			);
			$value = $this->featureContext->substituteInLineCodes(
				$value, ['preg_quote' => ['/']]
			);
			PHPUnit_Framework_Assert::assertNotFalse(
				(bool)\preg_match($value, $activityData[$key]),
				"'$value' does not match '{$activityData[$key]}'"
			);
		}
	}

	/**
	 * @BeforeScenario
	 *
	 * @param BeforeScenarioScope $scope
	 *
	 * @return void
	 * @throws Exception
	 */
	public function setUpScenario(BeforeScenarioScope $scope) {
		// Get the environment
		$environment = $scope->getEnvironment();
		// Get all the contexts you need in this context
		$this->featureContext = $environment->getContext('FeatureContext');
	}
}
