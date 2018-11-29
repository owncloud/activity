<?php
/**
 * @author Joas Schilling <nickvergessen@owncloud.com>
 *
 * @copyright Copyright (c) 2016, ownCloud, Inc.
 * @license AGPL-3.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */

namespace OCA\Activity\Tests\Unit;

use OCA\Activity\Data;
use OCA\Activity\Tests\Unit\Mock\Extension;
use OCP\Activity\IExtension;

/**
 * Class ApiTest
 *
 * @group DB
 * @package OCA\Activity\Tests
 */
class ApiTest extends TestCase {
	protected $originalWEBROOT;

	protected function setUp() {
		parent::setUp();

		$this->originalWEBROOT = \OC::$WEBROOT;
		\OC::$WEBROOT = '';
		\OC::$server->getUserManager()->createUser('activity-api-user1', 'activity-api-user1');
		\OC::$server->getUserManager()->createUser('activity-api-user2', 'activity-api-user2');

		$activities = [
			[
				'affectedUser' => 'activity-api-user1',
				'subject' => 'subject1',
				'subjectparams' => ['/A/B.txt'],
				'type' => 'type1',
			],
			[
				'affectedUser' => 'activity-api-user1',
				'subject' => 'subject2',
				'subjectparams' => ['/A/B.txt', 'User'],
				'type' => 'type2',
			],
		];

		$queryActivity = \OC::$server->getDatabaseConnection()->prepare('INSERT INTO `*PREFIX*activity`(`app`, `subject`, `subjectparams`, `message`, `messageparams`, `file`, `link`, `user`, `affecteduser`, `timestamp`, `priority`, `type`)' . ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )');
		$loop = 0;
		foreach ($activities as $activity) {
			$queryActivity->execute([
				'app1',
				$activity['subject'],
				\json_encode($activity['subjectparams']),
				'',
				\json_encode([]),
				'file',
				'link',
				'user',
				$activity['affectedUser'],
				\time() + $loop,
				IExtension::PRIORITY_MEDIUM,
				$activity['type'],
			]);
			$loop++;
		}
	}

	protected function tearDown() {
		$data = new Data(
			$this->createMock('OCP\Activity\IManager'),
			\OC::$server->getDatabaseConnection(),
			$this->createMock('OCP\IUserSession')
		);

		$this->deleteUser($data, 'activity-api-user1');
		$this->deleteUser($data, 'activity-api-user2');

		$data->deleteActivities([
			'app' => 'app1',
		]);
		\OC::$WEBROOT = $this->originalWEBROOT;

		parent::tearDown();
	}

	protected function deleteUser(Data $data, $uid) {
		$data->deleteActivities([
			'affecteduser' => $uid,
		]);
		$user = \OC::$server->getUserManager()->get($uid);
		if ($user) {
			$user->delete();
		}
	}

	public function getData() {
		return [
			['activity-api-user2', 0, 30, []],
			['activity-api-user1', 0, 30, [
				[
					'link' => 'link',
					'file' => 'file',
					'date' => null,
					'id' => null,
					'message' => '',
					'subject' => 'Subject2 @User #A/B.txt',
				],
				[
					'link' => 'link',
					'file' => 'file',
					'date' => null,
					'id' => null,
					'message' => '',
					'subject' => 'Subject1 #A/B.txt',
				],
			]],
			['activity-api-user1', 0, 1, [
				[
					'link' => 'link',
					'file' => 'file',
					'date' => null,
					'id' => null,
					'message' => '',
					'subject' => 'Subject2 @User #A/B.txt',
				],
			]],
			['activity-api-user1', 1, 1, [
				[
					'link' => 'link',
					'file' => 'file',
					'date' => null,
					'id' => null,
					'message' => '',
					'subject' => 'Subject1 #A/B.txt',
				],
			]],
			['activity-api-user1', 5, 1, [
				[
					'link' => 'link',
					'file' => 'file',
					'date' => null,
					'id' => null,
					'message' => '',
					'subject' => 'Subject2 @User #A/B.txt',
				],
			]],
		];
	}

	/**
	 * @dataProvider getData
	 */
	public function testGet($user, $start, $count, $expected) {
		$_GET['start'] = $start;
		$_GET['count'] = $count;
		\OC_User::setUserId($user);
		$sessionUser = \OC::$server->getUserSession()->getUser();
		$this->assertInstanceOf('OCP\IUser', $sessionUser);
		$this->assertEquals($user, $sessionUser->getUID());

		$activityManager = new \OC\Activity\Manager(
			$this->createMock('OCP\IRequest'),
			$this->createMock('OCP\IUserSession'),
			$this->createMock('OCP\IConfig')
		);
		$activityManager->registerExtension(function () {
			return new Extension(\OCP\Util::getL10N('activity', 'en'), $this->createMock('\OCP\IURLGenerator'));
		});
		$this->overwriteService('ActivityManager', $activityManager);
		$result = \OCA\Activity\Api::get();
		$this->restoreService('ActivityManager');

		$this->assertEquals(100, $result->getStatusCode());
		$data = $result->getData();
		$this->assertEquals(\sizeof($expected), \sizeof($data));

		while (!empty($expected)) {
			$assertExpected = \array_shift($expected);
			$assertData = \array_shift($data);
			foreach ($assertExpected as $key => $value) {
				$this->assertArrayHasKey($key, $assertData);
				if ($value !== null) {
					$this->assertEquals($value, $assertData[$key]);
				}
			}
		}
	}
}
