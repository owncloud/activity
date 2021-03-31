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

use OCA\Activity\Consumer;
use OCP\DB;
use OCP\Activity\IExtension;

/**
 * Class ConsumerTest
 *
 * @group DB
 * @package OCA\Activity\Tests
 */
class ConsumerTest extends TestCase {
	/** @var \OCA\Activity\Consumer */
	protected $consumer;

	/** @var \OCA\Activity\Data|\PHPUnit\Framework\MockObject\MockObject */
	protected $data;

	/** @var \OCP\L10N\IFactory|\PHPUnit\Framework\MockObject\MockObject */
	protected $l10nFactory;

	/** @var \OCA\Activity\UserSettings */
	protected $userSettings;

	/** @var \OCP\Activity\IManager */
	protected $manager;

	protected function setUp(): void {
		parent::setUp();
		$this->deleteTestActivities();

		$this->data = $this->getMockBuilder('OCA\Activity\Data')
			->disableOriginalConstructor()
			->getMock();

		$this->userSettings = $this->getMockBuilder('OCA\Activity\UserSettings')
			->setMethods(['getUserSetting'])
			->disableOriginalConstructor()
			->getMock();

		$l10n = $this->getMockBuilder('OCP\IL10N')
			->disableOriginalConstructor()
			->getMock();

		$this->l10nFactory = $this->getMockBuilder('OCP\L10N\IFactory')
			->disableOriginalConstructor()
			->getMock();
		$this->l10nFactory->expects($this->any())
			->method('get')
			->with('activity')
			->willReturn($l10n);

		$this->manager = $this->getMockBuilder('OCP\Activity\IManager')
			->disableOriginalConstructor()
			->getMock();

		$this->userSettings->expects($this->any())
			->method('getUserSetting')
			->with($this->stringContains('affectedUser'), $this->anything(), $this->anything())
			->will($this->returnValueMap([
				['affectedUser', 'stream', 'type', true],
				['affectedUser2', 'stream', 'type', true],
				['affectedUser', 'setting', 'self', true],
				['affectedUser2', 'setting', 'self', false],
				['affectedUser', 'email', 'type', true],
				['affectedUser2', 'email', 'type', true],
				['affectedUser', 'setting', 'selfemail', true],
				['affectedUser2', 'setting', 'selfemail', false],
				['affectedUser', 'setting', 'batchtime', 10],
				['affectedUser2', 'setting', 'batchtime', 10],
			]));
	}

	protected function tearDown(): void {
		$this->deleteTestActivities();
		parent::tearDown();
	}

	protected function deleteTestActivities() {
		$query = DB::prepare('DELETE FROM `*PREFIX*activity` WHERE `app` = ?');
		$query->execute(['test']);
		$query = DB::prepare('DELETE FROM `*PREFIX*activity_mq` WHERE `amq_appid` = ?');
		$query->execute(['test']);
	}

	public function receiveData() {
		return [
			['type', 'author', 'affectedUser', 'subject', 'affectedUser'],
			['type2', 'author', 'affectedUser', 'subject', false],

			['type', 'author', 'affectedUser', 'subject_self', 'affectedUser'],
			['type', 'author', 'affectedUser2', 'subject_self', 'affectedUser2'],
			['type', 'author', 'affectedUser', 'subject2', 'affectedUser'],
			['type', 'author', 'affectedUser2', 'subject2', 'affectedUser2'],

			['type', 'affectedUser', 'affectedUser', 'subject_self', 'affectedUser'],
			['type', 'affectedUser2', 'affectedUser2', 'subject_self', false],
			['type', 'affectedUser', 'affectedUser', 'subject2', 'affectedUser'],
			['type', 'affectedUser2', 'affectedUser2', 'subject2', false],
		];
	}

	/**
	 * @dataProvider receiveData
	 *
	 * @param string $type
	 * @param string $author
	 * @param string $affectedUser
	 * @param string $subject
	 * @param array|false $expected
	 */
	public function testReceiveStream($type, $author, $affectedUser, $subject, $expected) {
		$this->data->method('getNotificationTypes')
			->willReturn([
				'type' => 'a translated description',
				'type2' => [
					'desc' => 'translated string description for the setting',
					'methods' => [IExtension::METHOD_STREAM, IExtension::METHOD_MAIL],
				]
			]);

		$consumer = new Consumer($this->data, $this->userSettings, $this->l10nFactory, $this->manager);
		$event = \OC::$server->getActivityManager()->generateEvent();
		$event->setApp('test')
			->setType($type)
			->setAffectedUser($affectedUser)
			->setAuthor($author)
			->setTimestamp(\time())
			->setSubject($subject, ['subjectParam1', 'subjectParam2'])
			->setMessage('message', ['messageParam1', 'messageParam2'])
			->setObject('', 0, 'file')
			->setLink('link');
		$this->deleteTestActivities();

		if ($expected === false) {
			$this->data->expects($this->never())
				->method('send');
		} else {
			$this->data->expects($this->once())
				->method('send');
		}

		$consumer->receive($event);
	}

	/**
	 * @dataProvider receiveData
	 *
	 * @param string $type
	 * @param string $author
	 * @param string $affectedUser
	 * @param string $subject
	 * @param array|false $expected
	 */
	public function testReceiveEmail($type, $author, $affectedUser, $subject, $expected) {
		$this->data->method('getNotificationTypes')
			->willReturn([
				'type' => 'a translated description',
				'type2' => [
					'desc' => 'translated string description for the setting',
					'methods' => [IExtension::METHOD_STREAM, IExtension::METHOD_MAIL],
				]
			]);

		$time = \time();
		$consumer = new Consumer($this->data, $this->userSettings, $this->l10nFactory, $this->manager);
		$event = \OC::$server->getActivityManager()->generateEvent();
		$event->setApp('test')
			->setType($type)
			->setAffectedUser($affectedUser)
			->setAuthor($author)
			->setTimestamp($time)
			->setSubject($subject, ['subjectParam1', 'subjectParam2'])
			->setMessage('message', ['messageParam1', 'messageParam2'])
			->setObject('', 0, 'file')
			->setLink('link');

		if ($expected === false) {
			$this->data->expects($this->never())
				->method('storeMail');
		} else {
			$this->data->expects($this->once())
				->method('storeMail')
				->with($event, $time + 10);
		}

		$consumer->receive($event);
	}
}
