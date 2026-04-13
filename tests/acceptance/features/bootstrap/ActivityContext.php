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
use TestHelpers\WebDavHelper;

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
		$url = "/index.php/apps/activity/api/v2/activity/filter?object_type=files&object_id=$objectId";
		return $this->sendActivityGetRequest($url, $user);
	}

	/**
	 * @param string $url
	 * @param string $user
	 *
	 * @return array
	 * @throws GuzzleException
	 * @throws Exception
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
		$contents = $response->getBody()->getContents();
		if ($contents === "") {
			// If the empty string is returned then there are no activity entries.
			// Return an empty array because this function should always return an array.
			return [];
		}

		$decoded_json = \json_decode(
			$contents,
			true
		);
		if ($decoded_json === null) {
			throw new Exception(
				"JSON returned by sendActivityGetRequest to $fullUrl is not valid: '$contents'"
			);
		}
		return $decoded_json;
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
				(string)$this->featureContext->getLastCreatedPublicShareToken(),
				(string)$this->featureContext->getLastCreatedPublicShare()->uid_owner,
				(string)$this->featureContext->getLastCreatedPublicShare()->displayname_owner,
				(string)$this->featureContext->getLastCreatedPublicShare()->path
			)
		);
	}

	/**
	 * @When /^user "([^"]*)" restores the (?:file|folder|entry) with original path "([^"]*)" using the activity test code$/
	 *
	 * @param string|null $user
	 * @param string $originalPath
	 *
	 * @return void
	 * @throws JsonException
	 * @throws Exception
	 */
	public function elementInTrashIsRestoredUsingActivityTestCode(?string $user, string $originalPath):void {
		$user = $this->featureContext->getActualUsername($user);
		$this->restoreElement($user, $originalPath);
	}

	/**
	 * @param string $user
	 * @param string $originalPath
	 * @param string|null $destinationPath
	 * @param bool $throwExceptionIfNotFound
	 * @param string|null $asUser - To send request as another user
	 * @param string|null $password
	 *
	 * @return void
	 * @throws Exception
	 */
	private function restoreElement(string $user, string $originalPath, ?string $destinationPath = null, bool $throwExceptionIfNotFound = true, ?string $asUser = null, ?string $password = null):void {
		$asUser = $asUser ?? $user;
		$listing = $this->listTrashbinFolder($user);
		$originalPath = \trim($originalPath, '/');
		if ($destinationPath === null) {
			$destinationPath = $originalPath;
		}
		foreach ($listing as $entry) {
			if ($entry['original-location'] === $originalPath) {
				$this->sendUndeleteRequest(
					$user,
					$entry['href'],
					$destinationPath,
					$asUser,
					$password
				);
				return;
			}
		}
		// The requested element to restore was not even in the trashbin.
		// Throw an exception, because there was not any API call, and so there
		// is also no up-to-date response to examine in later test steps.
		if ($throwExceptionIfNotFound) {
			throw new \Exception(
				__METHOD__
				. " cannot restore from trashbin because no element was found for user $user at original path $originalPath"
			);
		}
	}

	/**
	 * List trashbin folder
	 *
	 * @param string|null $user user
	 * @param string $depth
	 *
	 * @return array of all the items in the trashbin of the user
	 * @throws Exception
	 */
	public function listTrashbinFolder(?string $user, string $depth = "1"):array {
		return $this->listTrashbinFolderCollection(
			$user,
			"",
			$depth
		);
	}

	/**
	 * List a collection in the trashbin
	 *
	 * @param string|null $user user
	 * @param string|null $collectionPath the string of ids of the folder and sub-folders
	 * @param string $depth
	 * @param int $level
	 *
	 * @return array response
	 * @throws Exception
	 */
	public function listTrashbinFolderCollection(?string $user, ?string $collectionPath = "", string $depth = "1", int $level = 1):array {
		// $collectionPath should be some list of file-ids like 2147497661/2147497662
		// or the empty string, which will list the whole trashbin from the top.
		$collectionPath = \trim($collectionPath, "/");
		$password = $this->featureContext->getPasswordForUser($user);
		$davPathVersion = $this->featureContext->getDavPathVersion();
		$response = WebDavHelper::listFolder(
			$this->featureContext->getBaseUrl(),
			$user,
			$password,
			$collectionPath,
			$depth,
			$this->featureContext->getStepLineRef(),
			[
				'oc:trashbin-original-filename',
				'oc:trashbin-original-location',
				'oc:trashbin-delete-timestamp',
				'd:resourcetype',
				'd:getlastmodified'
			],
			'trash-bin',
			$davPathVersion
		);
		$responseXml = HttpRequestHelper::getResponseXml(
			$response,
			__METHOD__ . " $collectionPath"
		);

		$subfolder = parse_url($this->featureContext->getBaseUrl(), PHP_URL_PATH);
		$subfolderWithSlashAtEnd = \trim($subfolder, "/") . "/";
		if ($subfolder === null) {
			$subfolder = "";
			$subfolderWithSlashAtEnd = "";
		}
		$files = $this->getTrashbinContentFromResponseXml($responseXml);
		// filter out the collection itself, we only want to return the members
		$files = \array_filter(
			$files,
			static function ($element) use ($user, $collectionPath, $subfolder) {
				$path = $collectionPath;
				if ($path !== "") {
					$path = $path . "/";
				}
				return ($element['href'] !== "$subfolder/remote.php/dav/trash-bin/$user/$path");
			}
		);

		foreach ($files as $file) {
			// check for unexpected/invalid href values and fail early in order to
			// avoid "common" situations that could cause infinite recursion.
			$trashbinRef = $file["href"];
			$trimmedTrashbinRef = \trim($trashbinRef, "/");
			$expectedStart = "{$subfolderWithSlashAtEnd}remote.php/dav/trash-bin/$user";
			$expectedStartLength = \strlen($expectedStart);
			if ((\substr($trimmedTrashbinRef, 0, $expectedStartLength) !== $expectedStart)
				|| (\strlen($trimmedTrashbinRef) === $expectedStartLength)
			) {
				// A top href (maybe without even the username) has been returned
				// in the response. That should never happen, or have been filtered out
				// by code above.
				throw new Exception(
					__METHOD__ . " Error: unexpected href in trashbin propfind at level $level: '$trashbinRef'"
				);
			}
			if ($file["collection"]) {
				$trimmedHref = \trim($trashbinRef, "/");
				$explodedHref = \explode("/", $trimmedHref);
				$trashbinId = $collectionPath . "/" . end($explodedHref);
				$nextFiles = $this->listTrashbinFolderCollection(
					$user,
					$trashbinId,
					$depth,
					$level + 1
				);
				// filter the collection element. We only want the members.
				$nextFiles = \array_filter(
					$nextFiles,
					static function ($element) use ($user, $trashbinRef) {
						return ($element['href'] !== $trashbinRef);
					}
				);
				\array_push($files, ...$nextFiles);
			}
		}
		return $files;
	}

	/**
	 * Get files list from the response from trashbin api
	 *
	 * @param SimpleXMLElement|null $responseXml
	 *
	 * @return array
	 */
	public function getTrashbinContentFromResponseXml(?SimpleXMLElement $responseXml): array {
		$xmlElements = $responseXml->xpath('//d:response');
		$files = \array_map(
			static function (SimpleXMLElement $element) {
				$href = $element->xpath('./d:href')[0];

				$propStats = $element->xpath('./d:propstat');
				$successPropStat = \array_filter(
					$propStats,
					static function (SimpleXMLElement $propStat) {
						$status = $propStat->xpath('./d:status');
						return (string) $status[0] === 'HTTP/1.1 200 OK';
					}
				);
				if (isset($successPropStat[0])) {
					$successPropStat = $successPropStat[0];

					$name = $successPropStat->xpath('./d:prop/oc:trashbin-original-filename');
					$mtime = $successPropStat->xpath('./d:prop/oc:trashbin-delete-timestamp');
					$resourcetype = $successPropStat->xpath('./d:prop/d:resourcetype');
					if (\array_key_exists(0, $resourcetype) && ($resourcetype[0]->asXML() === "<d:resourcetype><d:collection/></d:resourcetype>")) {
						$collection[0] = true;
					} else {
						$collection[0] = false;
					}
					$originalLocation = $successPropStat->xpath('./d:prop/oc:trashbin-original-location');
				} else {
					$name = [];
					$mtime = [];
					$collection = [];
					$originalLocation = [];
				}

				return [
					'href' => (string) $href,
					'name' => isset($name[0]) ? (string) $name[0] : null,
					'mtime' => isset($mtime[0]) ? (string) $mtime[0] : null,
					'collection' => isset($collection[0]) ? $collection[0] : false,
					'original-location' => isset($originalLocation[0]) ? (string) $originalLocation[0] : null
				];
			},
			$xmlElements
		);

		return $files;
	}

	/**
	 * @param string $user
	 * @param string $trashItemHRef
	 * @param string $destinationPath
	 * @param string|null $asUser - To send request as another user
	 * @param string|null $password
	 *
	 * @return ResponseInterface
	 */
	private function sendUndeleteRequest(string $user, string $trashItemHRef, string $destinationPath, ?string $asUser = null, ?string $password = null):ResponseInterface {
		$asUser = $asUser ?? $user;
		$destinationPath = \trim($destinationPath, '/');
		$destinationValue = $this->featureContext->getBaseUrl() . "/remote.php/dav/files/$user/$destinationPath";

		$trashItemHRef = $this->convertTrashbinHref($trashItemHRef);
		$headers['Destination'] = $destinationValue;
		$response = $this->featureContext->makeDavRequest(
			$asUser,
			'MOVE',
			$trashItemHRef,
			$headers,
			null,
			'trash-bin',
			'2',
			false,
			$password,
			[],
			$user
		);
		$this->featureContext->setResponse($response);
		return $response;
	}

	/**
	 * converts the trashItemHRef from /<base>/remote.php/dav/trash-bin/<user>/<item_id>/ to /trash-bin/<user>/<item_id>
	 *
	 * @param string $href
	 *
	 * @return string
	 */
	private function convertTrashbinHref(string $href):string {
		$trashItemHRef = \trim($href, '/');
		$trashItemHRef = \strstr($trashItemHRef, '/trash-bin');
		$trashItemHRef = \trim($trashItemHRef, '/');
		$parts = \explode('/', $trashItemHRef);
		$decodedParts = \array_slice($parts, 2);
		return '/' . \join('/', $decodedParts);
	}
}
