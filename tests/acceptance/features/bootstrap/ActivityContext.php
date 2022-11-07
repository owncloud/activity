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
use GuzzleHttp\Exception\GuzzleException;
use PHPUnit\Framework\Assert;
use Psr\Http\Message\ResponseInterface;
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
	 * Asserts provided table data with index to json decoded activity response
	 *
	 * @param string $user
	 * @param string $index
	 * @param array $responseDecoded
	 * @param TableNode $expectedProperties
	 *
	 * @return void
	 */
	private function assertActivityIndexContent(
		string $user,
		string $index,
		array $responseDecoded,
		TableNode $expectedProperties
	):void {
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
	 * @Then the activity number :index of user :user should match these properties:
	 *
	 * @param string $index (starting from 1, newest to the oldest)
	 * @param string $user
	 * @param TableNode $expectedProperties
	 *
	 * @return void
	 * @throws GuzzleException
	 */
	public function activityWithIndexShouldMatch(
		string $index,
		string $user,
		TableNode $expectedProperties
	): void {
		$responseDecoded = $this->getActivitiesForUser($user);
		$this->assertActivityIndexContent($user, $index, $responseDecoded, $expectedProperties);
	}

	/**
	 * @Then /^as user "([^"]*)" the activity number (\d+) for "([^"]*)" should match these properties:$/
	 *
	 * @param string $user
	 * @param string $index
	 * @param string $path
	 * @param TableNode $expectedProperties
	 *
	 * @return void
	 * @throws GuzzleException
	 */
	public function asUserTheActivityNumberForShouldMatchTheseProperties(
		string $user,
		string $index,
		string $path,
		TableNode $expectedProperties
	):void {
		$responseDecoded = $this->getActivitiesForFileAsUser($user, $path);
		$this->assertActivityIndexContent($user, $index, $responseDecoded, $expectedProperties);
	}

	/**
	 * @Then user :user should not have any activity entries
	 *
	 * @param string $user
	 *
	 * @return void
	 * @throws GuzzleException
	 */
	public function userShouldNotHaveAnyActivityEntries(
		string $user
	): void {
		$responseDecoded = $this->getActivitiesForUser($user);
		$activityDataArray = $responseDecoded['ocs']['data'];
		Assert::assertIsArray($activityDataArray);
		$numberOfActivityEntries = \count($activityDataArray);
		$activityTypes = [];
		foreach ($activityDataArray as $activityData) {
			$activityTypes[$activityData["type"]] = true;
		}
		$activityTypesString = \implode(",", \array_keys($activityTypes));
		Assert::assertEquals(
			0,
			$numberOfActivityEntries,
			"User $user has $numberOfActivityEntries activity entries but should have none (found activity type(s) $activityTypesString)"
		);
	}

	/**
	 * @Then user :user should not have any activity entries with type :type
	 *
	 * @param string $user
	 * @param string $activityType
	 *
	 * @return void
	 * @throws GuzzleException
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
	 * @throws GuzzleException
	 */
	public function getActivitiesForUser(
		string $user
	): array {
		$user = $this->featureContext->getActualUsername($user);
		$url = "/index.php/apps/activity/api/v2/activity";
		return $this->sendActivityGetRequest($url, $user);
	}

	/**
	 * @param string $user
	 * @param string $resource
	 *
	 * @return array
	 * @throws GuzzleException
	 * @throws JsonException
	 */
	public function getActivitiesForFileAsUser(
		string $user,
		string $resource
	): array {
		$user = $this->featureContext->getActualUsername($user);
		$objectId = $this->featureContext->getFileIdForPath($user, $resource);
		$url = "/index.php/apps/activity/api/v2/activity/filter?object_type=files&object_id=${objectId}";
		return $this->sendActivityGetRequest($url, $user);
	}

	/**
	 * @param string $url
	 * @param string $user
	 *
	 * @return array
	 * @throws GuzzleException
	 */
	private function sendActivityGetRequest(string $url, string $user):array {
		$fullUrl = $this->featureContext->getBaseUrl() . $url;
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
		return \json_decode(
			$response->getBody()->getContents(),
			true
		);
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

	/**
	 * @param string $remote remote url to add as server to the public link
	 * @param string $user actor for this operation
	 * @param string $token token of the public link to be interacted with
	 * @param string $owner owner of the public link
	 * @param string $ownerDisplayName display name of the owner of the public link
	 * @param string $path path of the resource in the public link share
	 * @param string $password password of the public link if password protected
	 *
	 * @return ResponseInterface
	 * @throws GuzzleException|JsonException
	 */
	public function addOwnCloudServerToThePublicLink(
		string $remote,
		string $user,
		string $token,
		string $owner,
		string $ownerDisplayName,
		string $path,
		string $password = ""
	): ResponseInterface {
		$user = $this->featureContext->getActualUsername($user);
		$userPassword = $this->featureContext->getPasswordForUser($user);
		$fullUrl = $this->featureContext->getRemoteBaseUrl() . "/index.php/apps/files_sharing/external";

		return HttpRequestHelper::post(
			$fullUrl,
			$this->featureContext->getStepLineRef(),
			$user,
			$userPassword,
			null,
			[
				'remote' => $remote,
				'token' => $token,
				'owner' => $owner,
				'ownerDisplayName' => $ownerDisplayName,
				'name' => $path,
				'password' => $password
			]
		);
	}

	/**
	 * @When /^user "([^"]*)" adds the last public link share to the remote server using the Sharing API$/
	 *
	 * @param string $user
	 *
	 * @return void
	 * @throws GuzzleException|JsonException|Exception
	 */
	public function userHasAddedTheLastPublicLinkShareToRemoteServer(string $user):void {
		$this->featureContext->setResponse(
			$this->addOwnCloudServerToThePublicLink(
				$this->featureContext->getLocalBaseUrl(),
				$user,
				$this->featureContext->getLastPublicShareToken(),
				$this->featureContext->getLastPublicShareAttribute("uid_owner"),
				$this->featureContext->getLastPublicShareAttribute("displayname_owner"),
				$this->featureContext->getLastPublicShareAttribute("path")
			)
		);
	}
}
