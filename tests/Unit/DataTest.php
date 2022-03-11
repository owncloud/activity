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

use OC\DB\QueryBuilder\Literal;
use OCA\Activity\Data;
use OCA\Activity\Tests\Unit\Mock\Extension;

/**
 * Class DataTest
 *
 * @group DB
 * @package OCA\Activity\Tests
 */
class DataTest extends TestCase {
	/** @var \OCA\Activity\Data */
	protected $data;

	/** @var \OCP\IL10N */
	protected $activityLanguage;

	/** @var \OC\Activity\Manager|\PHPUnit\Framework\MockObject\MockObject */
	protected $activityManager;

	/** @var \OCP\IUserSession|\PHPUnit\Framework\MockObject\MockObject */
	protected $session;

	protected function setUp(): void {
		parent::setUp();

		$this->activityLanguage = $activityLanguage = \OCP\Util::getL10N('activity', 'en');
		$this->activityManager = new \OC\Activity\Manager(
			$this->createMock('OCP\IRequest'),
			$this->createMock('OCP\IUserSession'),
			$this->createMock('OCP\IConfig')
		);
		$this->session = $this->getMockBuilder('OCP\IUserSession')
			->disableOriginalConstructor()
			->getMock();

		$this->activityManager->registerExtension(function () use ($activityLanguage) {
			return new Extension($activityLanguage, $this->createMock('\OCP\IURLGenerator'));
		});
		$this->data = new Data(
			$this->activityManager,
			\OC::$server->getDatabaseConnection(),
			$this->session
		);
	}

	protected function tearDown(): void {
		$this->restoreService('UserSession');
		parent::tearDown();
	}

	public function dataGetNotificationTypes() {
		return [
			['type1'],
		];
	}

	/**
	 * @dataProvider dataGetNotificationTypes
	 * @param string $typeKey
	 */
	public function testGetNotificationTypes($typeKey) {
		$this->assertArrayHasKey($typeKey, $this->data->getNotificationTypes($this->activityLanguage));
		// Check cached version aswell
		$this->assertArrayHasKey($typeKey, $this->data->getNotificationTypes($this->activityLanguage));
	}

	public function validateFilterData() {
		return [
			// Default filters
			['all', 'all'],
			['by', 'by'],
			['self', 'self'],

			// Filter from extension
			['filter1', 'filter1'],

			// Inexistent or empty filter
			['test', 'all'],
			[null, 'all'],
		];
	}

	/**
	 * @dataProvider validateFilterData
	 *
	 * @param string $filter
	 * @param string $expected
	 */
	public function testValidateFilter($filter, $expected) {
		$this->assertEquals($expected, $this->data->validateFilter($filter));
	}

	public function dataSend() {
		return [
			// Default case
			['author', 'affectedUser', 'author', 'affectedUser', true],
			// Public page / Incognito mode
			['', 'affectedUser', '', 'affectedUser', true],
			// No affected user => no activity
			['author', '', 'author', '', false],
			// No affected user and no author => no activity
			['', '', '', '', false],
		];
	}

	/**
	 * @dataProvider dataSend
	 *
	 * @param string $actionUser
	 * @param string $affectedUser
	 * @param string $expectedAuthor
	 * @param string $expectedAffected
	 * @param bool $expectedActivity
	 */
	public function testSend($actionUser, $affectedUser, $expectedAuthor, $expectedAffected, $expectedActivity) {
		$mockSession = $this->getMockBuilder('\OC\User\Session')
			->disableOriginalConstructor()
			->getMock();

		$this->overwriteService('UserSession', $mockSession);
		$this->deleteTestActivities();

		$event = \OC::$server->getActivityManager()->generateEvent();
		$event->setApp('test')
			->setType('type')
			->setAffectedUser($affectedUser)
			->setSubject('subject', []);
		if ($actionUser !== '') {
			$event->setAuthor($actionUser);
		}

		$this->assertSame($expectedActivity, $this->data->send($event));

		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->prepare('SELECT `user`, `affecteduser` FROM `*PREFIX*activity` WHERE `app` = ? ORDER BY `activity_id` DESC');
		$query->execute(['test']);
		$row = $query->fetch();

		if ($expectedActivity) {
			$this->assertEquals(['user' => $expectedAuthor, 'affecteduser' => $expectedAffected], $row);
		} else {
			$this->assertFalse($row);
		}

		$this->deleteTestActivities();
		$this->restoreService('UserSession');
	}

	/**
	 * @dataProvider dataSend
	 *
	 * @param string $actionUser
	 * @param string $affectedUser
	 * @param string $expectedAuthor
	 * @param string $expectedAffected
	 * @param bool $expectedActivity
	 */
	public function testStoreMail($actionUser, $affectedUser, $expectedAuthor, $expectedAffected, $expectedActivity) {
		$mockSession = $this->getMockBuilder('\OC\User\Session')
			->disableOriginalConstructor()
			->getMock();

		$this->overwriteService('UserSession', $mockSession);
		$this->deleteTestMails();

		$time = \time();

		$event = \OC::$server->getActivityManager()->generateEvent();
		$event->setApp('test')
			->setType('type')
			->setAffectedUser($affectedUser)
			->setSubject('subject', [])
			->setTimestamp($time);

		$this->assertSame($expectedActivity, $this->data->storeMail($event, $time + 10));

		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->prepare('SELECT `amq_latest_send`, `amq_affecteduser` FROM `*PREFIX*activity_mq` WHERE `amq_appid` = ? ORDER BY `mail_id` DESC');
		$query->execute(['test']);
		$row = $query->fetch();

		if ($expectedActivity) {
			$this->assertEquals(['amq_latest_send' => $time + 10, 'amq_affecteduser' => $expectedAffected], $row);
		} else {
			$this->assertFalse($row);
		}

		$this->deleteTestMails();
		$this->restoreService('UserSession');
	}

	public function dataGet() {
		return [
			['asc', 'filter1', 1],
			['desc', 'filter1', 4],
			['asc', 'self', 1],
			['desc', 'self', 2],
			['asc', 'by', 3],
			['desc', 'by', 4],
			['asc', 'filter', 1, 'object1', 23],
			['desc', 'filter', 4, 'object2', 42],
		];
	}

	/**
	 * @dataProvider dataGet
	 *
	 * @param string $sort
	 * @param string $filter
	 * @param int $lastGiven
	 * @param string $objectType
	 * @param int $objectId
	 */
	public function testGet($sort, $filter, $lastGiven, $objectType = '', $objectId = 0) {
		$this->deleteTestActivities();

		$activities = [];
		$activities[1] = $this->populateActivity(1, 'user1', 'user1', 'type1', $objectType, $objectId);
		$activities[2] = $this->populateActivity(2, 'user1', 'user1', 'type2', $objectType, $objectId);
		$activities[3] = $this->populateActivity(3, 'user1', 'user2', 'type1', $objectType, $objectId);
		$activities[4] = $this->populateActivity(4, 'user1', 'user2', 'type2', $objectType, $objectId);
		$activities[5] = $this->populateActivity(5, 'user2', 'user1', 'type2', $objectType, $objectId);

		/** @var \OCA\Activity\GroupHelper|\PHPUnit\Framework\MockObject\MockObject $groupHelper */
		$groupHelper = $this->getMockBuilder('OCA\Activity\GroupHelper')
			->disableOriginalConstructor()
			->getMock();
		$groupHelper->expects($this->once())
			->method('setUser')
			->with('user1');

		/** @var \OCA\Activity\UserSettings|\PHPUnit\Framework\MockObject\MockObject $settings */
		$settings = $this->getMockBuilder('OCA\Activity\UserSettings')
			->disableOriginalConstructor()
			->getMock();
		$settings->expects($this->once())
			->method('getNotificationTypes')
			->with('user1', 'stream')
			->willReturn(['type1', 'type2']);

		/** @var \OC\Activity\Manager|\PHPUnit\Framework\MockObject\MockObject $activityManager */
		$activityManager = $this->getMockBuilder('OCP\Activity\IManager')
			->disableOriginalConstructor()
			->getMock();
		$activityManager->expects($this->any())
			->method('filterNotificationTypes')
			->with(['type1', 'type2'], $filter)
			->willReturn(['type1', 'type2']);
		$activityManager->expects($this->once())
			->method('getQueryForFilter')
			->with($filter)
			->willReturn([null, null]);

		/** @var \OCA\Activity\Data|\PHPUnit\Framework\MockObject\MockObject $data */
		$data = new \OCA\Activity\Data(
			$activityManager,
			\OC::$server->getDatabaseConnection(),
			$this->session
		);

		$result = $data->get($groupHelper, $settings, 'user1', 0, 1, $sort, $filter, $objectType, $objectId);

		$this->assertArrayHasKey('data', $result);
		$this->assertEquals(null, $result['data']);
		$this->assertArrayHasKey('headers', $result);
		$this->assertArrayHasKey('X-Activity-Last-Given', $result['headers']);
		$this->assertEquals($activities[$lastGiven], $result['headers']['X-Activity-Last-Given']);
		$this->assertArrayHasKey('has_more', $result);
		$this->assertEquals(true, $result['has_more']);

		$this->deleteTestActivities();
	}

	/**
	 */
	public function testGetNoSettings() {
		$this->expectException(\BadMethodCallException::class);
		$this->expectExceptionMessage('No settings enabled');
		$this->expectExceptionCode(3);

		/** @var \OCA\Activity\GroupHelper|\PHPUnit\Framework\MockObject\MockObject $groupHelper */
		$groupHelper = $this->getMockBuilder('OCA\Activity\GroupHelper')
			->disableOriginalConstructor()
			->getMock();
		$groupHelper->expects($this->once())
			->method('setUser')
			->with('user1');

		/** @var \OCA\Activity\UserSettings|\PHPUnit\Framework\MockObject\MockObject $settings */
		$settings = $this->getMockBuilder('OCA\Activity\UserSettings')
			->disableOriginalConstructor()
			->getMock();
		$settings->expects($this->once())
			->method('getNotificationTypes')
			->with('user1', 'stream')
			->willReturn(['settings']);

		/** @var \OC\Activity\Manager|\PHPUnit\Framework\MockObject\MockObject $activityManager */
		$activityManager = $this->getMockBuilder('OCP\Activity\IManager')
			->disableOriginalConstructor()
			->getMock();
		$activityManager->expects($this->any())
			->method('filterNotificationTypes')
			->with(['settings'], 'filter1')
			->willReturn([]);
		$activityManager->expects($this->never())
			->method('getQueryForFilter');

		/** @var \OCA\Activity\Data|\PHPUnit\Framework\MockObject\MockObject $data */
		$data = new \OCA\Activity\Data(
			$activityManager,
			\OC::$server->getDatabaseConnection(),
			$this->session
		);

		$data->get($groupHelper, $settings, 'user1', 0, 0, 'asc', 'filter1');
	}

	/**
	 */
	public function testGetNoUser() {
		$this->expectException(\OutOfBoundsException::class);
		$this->expectExceptionMessage('Invalid user');
		$this->expectExceptionCode(1);

		/** @var \OCA\Activity\GroupHelper|\PHPUnit\Framework\MockObject\MockObject $groupHelper */
		$groupHelper = $this->getMockBuilder('OCA\Activity\GroupHelper')
			->disableOriginalConstructor()
			->getMock();

		/** @var \OCA\Activity\UserSettings|\PHPUnit\Framework\MockObject\MockObject $settings */
		$settings = $this->getMockBuilder('OCA\Activity\UserSettings')
			->disableOriginalConstructor()
			->getMock();

		$this->data->get($groupHelper, $settings, '', 0, 0, 'asc', '');
	}

	public function dataSetOffsetFromSince() {
		return [
			['ASC', '`timestamp` >= 123465789', '`activity_id` > {id}', null, null, null],
			['DESC', '`timestamp` <= 123465789', '`activity_id` < {id}', null, null, null],
			['DESC', null, null, 'invalid-user', null, null],
			['DESC', null, null, null, 1, 'X-Activity-First-Known'],
			['DESC', null, null, 'user', false, null],
		];
	}

	/**
	 * @dataProvider dataSetOffsetFromSince
	 *
	 * @param string $sort
	 * @param string $timestampWhere
	 * @param string $idWhere
	 * @param string $offsetUser
	 * @param int $offsetId
	 * @param string $expectedHeader
	 */
	public function testSetOffsetFromSince($sort, $timestampWhere, $idWhere, $offsetUser, $offsetId, $expectedHeader) {
		$this->deleteTestActivities();
		$user = $this->getUniqueID('testing');
		if ($offsetUser === null) {
			$offsetUser = $user;
		} elseif ($offsetUser === 'invalid-user') {
			$this->expectException('OutOfBoundsException');
			$this->expectExceptionMessage('Invalid since');
			$this->expectExceptionCode(2);
		}

		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->getQueryBuilder();
		$query->insert('activity')
			->values([
				'app' => $query->createNamedParameter('test'),
				'affecteduser' => $query->createNamedParameter($user),
				'timestamp' => 123465789,
				'subject' => $query->createNamedParameter('subject'),
				'subjectparams' => $query->createNamedParameter('subjectparams'),
				'priority' => 1,
			])
			->execute();
		$id = $query->getLastInsertId();

		$mock = $this->getMockBuilder('OCP\DB\QueryBuilder\IQueryBuilder')
			->disableOriginalConstructor()
			->getMock();
		$mock->expects($this->any())
			->method('expr')
			->willReturn($query->expr());
		$mock->expects($this->any())
			->method('createNamedParameter')
			->willReturnCallback(function ($arg) use ($query) {
				return new Literal($arg);
			});
		if ($timestampWhere !== null && $idWhere !== null) {
			$mock->expects($this->exactly(2))
				->method('andWhere')
				->withConsecutive(
					[$timestampWhere],
					[\str_replace('{id}', $id, $idWhere)]
				);
		} else {
			$mock->expects($this->never())
				->method('andWhere');
		}

		if ($offsetId === null) {
			$offsetId = $id;
		} elseif ($offsetId === false) {
			$offsetId = 0;
		} else {
			$offsetId += $id;
		}

		$headers = $this->invokePrivate($this->data, 'setOffsetFromSince', [$mock, $offsetUser, $offsetId, $sort]);

		if ($expectedHeader) {
			$this->assertArrayHasKey($expectedHeader, $headers);
			$this->assertEquals($id, $headers[$expectedHeader]);
		} else {
			$this->assertCount(0, $headers);
		}

		$this->deleteTestActivities();
	}

	/**
	 * @param int $num
	 * @param string $affected
	 * @param string $user
	 * @param string $type
	 * @param string $objectType
	 * @param int $objectId
	 * @return int
	 */
	protected function populateActivity($num, $affected, $user, $type, $objectType, $objectId) {
		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->getQueryBuilder();
		$query->insert('activity')
			->values([
				'app' => $query->createNamedParameter('test'),
				'affecteduser' => $query->createNamedParameter($affected),
				'user' => $query->createNamedParameter($user),
				'timestamp' => 123465789 + $num,
				'type' => $query->createNamedParameter($type),
				'object_type' => $query->createNamedParameter($objectType),
				'object_id' => $query->createNamedParameter($objectId),
				'subject' => $query->createNamedParameter('subject'),
				'subjectparams' => $query->createNamedParameter('subjectparams'),
				'priority' => 1,
			])
			->execute();

		return $query->getLastInsertId();
	}

	/**
	 * Delete all testing activities
	 */
	protected function deleteTestActivities() {
		$query = \OC::$server->getDatabaseConnection()->getQueryBuilder();
		$query->delete('activity')
			->where($query->expr()->eq('app', $query->createNamedParameter('test')));
		$query->execute();
	}

	/**
	 * Delete all testing mails
	 */
	protected function deleteTestMails() {
		$query = \OC::$server->getDatabaseConnection()->getQueryBuilder();
		$query->delete('activity_mq')
			->where($query->expr()->eq('amq_appid', $query->createNamedParameter('test')));
		$query->execute();
	}
}
