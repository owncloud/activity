<?php
/**
 * @author Joas Schilling <nickvergessen@owncloud.com>
 * @author Thomas Müller <thomas.mueller@tmit.eu>
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

use OCA\Activity\MailQueueHandler;
use OCP\IUser;

/**
 * Class MailQueueHandlerTest
 *
 * @group DB
 * @package OCA\Activity\Tests
 */
class MailQueueHandlerTest extends TestCase {

	/** @var MailQueueHandler */
	protected $mailQueueHandler;

	/** @var \PHPUnit\Framework\MockObject\MockObject|\OCP\Mail\IMailer */
	protected $mailer;

	/** @var \PHPUnit\Framework\MockObject\MockObject */
	protected $message;

	/** @var \OCP\IUserManager */
	protected $userManager;

	/** @var \PHPUnit\Framework\MockObject\MockObject|\OCP\Activity\IManager */
	protected $activityManager;

	/** @var \PHPUnit\Framework\MockObject\MockObject|\OCA\Activity\DataHelper */
	protected $dataHelper;

	/** @var IUser */
	protected $user1;

	/** @var IUser */
	protected $user2;

	/** @var IUser */
	protected $user3;

	protected function setUp(): void {
		parent::setUp();

		$user1Id = $this->getUniqueId('mailqueueuser1_');
		$user2Id = $this->getUniqueId('mailqueueuser2_');
		$user3Id = $this->getUniqueId('mailqueueuser3_');
		$app = $this->getUniqueID('MailQueueHandlerTest');

		// we need an actual user manager because the class joins
		// on the oc_accounts table
		$this->userManager = \OC::$server->getUserManager();
		$this->user1 = $this->userManager->createUser($user1Id, 'test');
		$this->user1->setEMailAddress('user1@localhost');
		$this->user2 = $this->userManager->createUser($user2Id, 'test');
		$this->user2->setEMailAddress('user2@localhost');
		$this->user3 = $this->userManager->createUser($user3Id, 'test');

		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->prepare('INSERT INTO `*PREFIX*activity_mq` '
			. ' (`amq_appid`, `amq_subject`, `amq_subjectparams`, `amq_affecteduser`, `amq_timestamp`, `amq_type`, `amq_latest_send`) '
			. ' VALUES(?, ?, ?, ?, ?, ?, ?)');

		$query->execute([$app, 'Test data', 'Param1', $user1Id, 150, 'phpunit', 152]);
		$query->execute([$app, 'Test data', 'Param1', $user1Id, 150, 'phpunit', 153]);
		$query->execute([$app, 'Test data', 'Param1', $user2Id, 150, 'phpunit', 150]);
		$query->execute([$app, 'Test data', 'Param1', $user2Id, 150, 'phpunit', 151]);
		$query->execute([$app, 'Test data', 'Param1', $user3Id, 150, 'phpunit', 154]);
		$query->execute([$app, 'Test data', 'Param1', $user3Id, 150, 'phpunit', 155]);

		$event = $this->getMockBuilder('OCP\Activity\IEvent')
			->disableOriginalConstructor()
			->getMock();
		$event->expects($this->any())
			->method('setApp')
			->willReturnSelf();
		$event->expects($this->any())
			->method('setType')
			->willReturnSelf();
		$event->expects($this->any())
			->method('setAffectedUser')
			->willReturnSelf();
		$event->expects($this->any())
			->method('setTimestamp')
			->willReturnSelf();
		$event->expects($this->any())
			->method('setSubject')
			->willReturnSelf();

		$this->activityManager = $this->getMockBuilder('OCP\Activity\IManager')
			->disableOriginalConstructor()
			->getMock();
		$this->activityManager->expects($this->any())
			->method('generateEvent')
			->willReturn($event);

		$this->dataHelper = $this->getMockBuilder('OCA\Activity\DataHelper')
				->disableOriginalConstructor()
				->getMock();
		$this->dataHelper->expects($this->any())
			->method('getParameters')
			->willReturn([]);

		$this->message = $this->getMockBuilder('OC\Mail\Message')
			->disableOriginalConstructor()
			->getMock();
		$this->mailer = $this->createMock('OCP\Mail\IMailer');
		$this->mailer->expects($this->any())
			->method('createMessage')
			->willReturn($this->message);
		$this->mailQueueHandler = new MailQueueHandler(
			$this->createMock('\OCP\IDateTimeFormatter'),
			$connection,
			$this->dataHelper,
			$this->mailer,
			$this->getMockBuilder('\OCP\IURLGenerator')
				->disableOriginalConstructor()
				->getMock(),
			$this->userManager,
			$this->activityManager
		);
	}

	protected function tearDown(): void {
		$query = \OC::$server->getDatabaseConnection()->prepare('DELETE FROM `*PREFIX*activity_mq` WHERE `amq_timestamp` < 500');
		$query->execute();

		$this->user1->delete();
		$this->user2->delete();
		$this->user3->delete();

		parent::tearDown();
	}

	public function getAffectedUsersData() {
		return [
			[null, ['user2', 'user1', 'user3'], []],
			[5, ['user2', 'user1', 'user3'], []],
			[3, ['user2', 'user1', 'user3'], []],
			[2, ['user2', 'user1'], ['user3']],
			[1, ['user2'], ['user1', 'user3']],
		];
	}

	/**
	 * @dataProvider getAffectedUsersData
	 *
	 * @param int $limit
	 * @param array $affected
	 * @param array $untouched
	 */
	public function testGetAffectedUsers($limit, $affected, $untouched) {
		$maxTime = 200;

		$affected = \array_map(function ($userVar) {
			return [
				'uid' => $this->$userVar->getUID(),
				'email' => $this->$userVar->getEMailAddress()
			];
		}, $affected);
		$untouched = \array_map(function ($userVar) {
			return [
				'uid' => $this->$userVar->getUID(),
				'email' => $this->$userVar->getEMailAddress()
			];
			return $this->$userVar->getUID();
		}, $untouched);

		$this->assertRemainingMailEntries($untouched, $maxTime, 'before doing anything');
		$users = $this->mailQueueHandler->getAffectedUsers($limit, $maxTime);
		$this->assertRemainingMailEntries($untouched, $maxTime, 'after getting the affected users');

		$this->assertEquals($affected, $users);

		$uids = \array_map(function ($u) {
			return $u['uid'];
		}, $users);

		foreach ($uids as $user) {
			list($data, $skipped) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$user, $maxTime]);
			$this->assertNotEmpty($data, 'Failed asserting that each user has a mail entry');
			$this->assertSame(0, $skipped);
		}
		$this->assertRemainingMailEntries($untouched, $maxTime, 'after getting the affected items');

		$this->mailQueueHandler->deleteSentItems($uids, $maxTime);

		foreach ($uids as $user) {
			list($data, $skipped) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$user, $maxTime]);
			$this->assertEmpty($data, 'Failed to assert that all entries for the affected users have been deleted');
			$this->assertSame(0, $skipped);
		}
		$this->assertRemainingMailEntries($untouched, $maxTime, 'after deleting the affected items');
	}

	public function testGetItemsForUser() {
		list($data, $skipped) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$this->user1->getUID(), 200]);
		$this->assertCount(2, $data, 'Failed to assert the user has 2 entries');
		$this->assertSame(0, $skipped);

		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->prepare('INSERT INTO `*PREFIX*activity_mq` '
			. ' (`amq_appid`, `amq_subject`, `amq_subjectparams`, `amq_affecteduser`, `amq_timestamp`, `amq_type`, `amq_latest_send`) '
			. ' VALUES(?, ?, ?, ?, ?, ?, ?)');

		$app = $this->getUniqueID('MailQueueHandlerTest');
		for ($i = 0; $i < 15; $i++) {
			$query->execute([$app, 'Test data', 'Param1', $this->user1->getUID(), 150, 'phpunit', 160 + $i]);
		}

		list($data, $skipped) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$this->user1->getUID(), 200, 5]);
		$this->assertCount(5, $data, 'Failed to assert the user has 2 entries');
		$this->assertSame(12, $skipped);
	}

	public function testSendEmailToUser() {
		$maxTime = 200;
		$user = $this->user2->getUID();
		$userDisplayName = 'user two';
		$this->user2->setDisplayName($userDisplayName);
		$email = 'usertwo@localhost';
		$this->user2->setEMailAddress($email);

		$this->mailer->expects($this->once())
			->method('send')
			->with($this->message);

		$this->message->expects($this->once())
			->method('setTo')
			->with([$email => $userDisplayName]);
		$this->message->expects($this->once())
			->method('setSubject');
		$this->message->expects($this->once())
			->method('setPlainBody');
		$this->message->expects($this->once())
			->method('setHtmlBody');
		$this->message->expects($this->once())
			->method('setFrom');

		$this->activityManager->expects($this->exactly(2))
			->method('setCurrentUserId')
			->withConsecutive(
				[$user],
				[null]
			);

		$users = $this->mailQueueHandler->getAffectedUsers(1, $maxTime);
		$this->assertEquals([['uid' => $user, 'email' => $email]], $users);
		$this->mailQueueHandler->sendEmailToUser($user, $email, 'en', 'UTC', $maxTime);

		// Invalid user, no object no email
		$this->mailQueueHandler->sendEmailToUser($user . $user, $email, 'en', 'UTC', $maxTime);
	}

	/**
	 * Trigger the cleanup with no users (if first email fails to send)
	 * Should not throw an exception
	 */
	public function testDeleteSentItemsWithNoUsers() {
		$this->assertNull(
			$this->mailQueueHandler->deleteSentItems([], \time())
		);
	}

	/**
	 * @param array $users
	 * @param int $maxTime
	 * @param string $explain
	 */
	protected function assertRemainingMailEntries(array $users, $maxTime, $explain) {
		if (!empty($untouched)) {
			foreach ($users as $user) {
				list($data, ) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$user, $maxTime]);
				$this->assertNotEmpty(
					$data,
					'Failed asserting that the remaining user ' . $user. ' still has mails in the queue ' . $explain
				);
			}
		}
	}

	public function getAllUsersData() {
		return [
			[null, ['user2', 'user1', 'user3'], []],
			[5, ['user2', 'user1', 'user3'], []],
			[3, ['user2', 'user1', 'user3'], []],
			[2, ['user2', 'user1'], ['user3']],
			[1, ['user2'], ['user1', 'user3']],
		];
	}

	/**
	 * @dataProvider getAllUsersData
	 *
	 * @param int $limit
	 * @param array $affected
	 * @param array $untouched
	 */
	public function testGetAllUsers($limit, $affected, $untouched) {
		$affected = \array_map(function ($userVar) {
			return [
				'uid' => $this->$userVar->getUID(),
				'email' => $this->$userVar->getEMailAddress()
			];
		}, $affected);
		$untouched = \array_map(function ($userVar) {
			return [
				'uid' => $this->$userVar->getUID(),
				'email' => $this->$userVar->getEMailAddress()
			];
		}, $untouched);

		$users = $this->mailQueueHandler->getAllUsers($limit);

		$uids = \array_map(function ($u) {
			return [
				'uid' => $u['uid'],
				'maxMailId' => $u['max_mail_id']
			];
		}, $users);

		foreach ($uids as $user) {
			list($data, $skipped) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$user['uid'], MailQueueHandler::POSTGRE_MAX_INT]);
			$this->assertNotEmpty($data, 'Failed asserting that each user has a mail entry');
			$this->assertSame(0, $skipped);
		}

		$this->mailQueueHandler->deleteAllSentItems($uids);

		foreach ($uids as $user) {
			list($data, $skipped) = $this->invokePrivate($this->mailQueueHandler, 'getItemsForUser', [$user['uid'], MailQueueHandler::POSTGRE_MAX_INT]);
			$this->assertEmpty($data, 'Failed to assert that all entries for the affected users have been deleted');
			$this->assertSame(0, $skipped);
		}
	}

	public function testSendAllEmailsToUser() {
		$maxTime = 200;
		$user = $this->user2->getUID();
		$userDisplayName = 'user two';
		$this->user2->setDisplayName($userDisplayName);
		$email = 'usertwo@localhost';
		$this->user2->setEMailAddress($email);

		$this->mailer->expects($this->once())
			->method('send')
			->with($this->message);

		$this->message->expects($this->once())
			->method('setTo')
			->with([$email => $userDisplayName]);
		$this->message->expects($this->once())
			->method('setSubject');
		$this->message->expects($this->once())
			->method('setPlainBody');
		$this->message->expects($this->once())
			->method('setHtmlBody');
		$this->message->expects($this->once())
			->method('setFrom');

		$this->activityManager->expects($this->exactly(2))
			->method('setCurrentUserId')
			->withConsecutive(
				[$user],
				[null]
			);

		$users = $this->mailQueueHandler->getAllUsers(1);
		$this->mailQueueHandler->sendAllEmailsToUser($user, $email, 'en', 'UTC', $maxTime);

		// Invalid user, no object no email
		$this->mailQueueHandler->sendAllEmailsToUser($user . $user, $email, 'en', 'UTC', $maxTime);
	}
}
