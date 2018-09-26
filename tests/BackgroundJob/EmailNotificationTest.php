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

namespace OCA\Activity\Tests\BackgroundJob;

use OCA\Activity\BackgroundJob\EmailNotification;
use OCA\Activity\Tests\TestCase;

/**
 * Class EmailNotificationTest
 *
 * @group DB
 * @package OCA\Activity\Tests\BackgroundJob
 */
class EmailNotificationTest extends TestCase {
	public function constructAndRunData() {
		return [
			[true],
			[false],
			[null],
		];
	}

	/**
	 * @dataProvider constructAndRunData
	 *
	 * @param bool $isCLI
	 */
	public function testConstructAndRun($isCLI) {
		$backgroundJob = new EmailNotification(
			$this->getMockBuilder('OCA\Activity\MailQueueHandler')->disableOriginalConstructor()->getMock(),
			$this->createMock('OCP\IConfig'),
			$this->createMock('OCP\ILogger'),
			$isCLI
		);

		$jobList = $this->createMock('\OCP\BackgroundJob\IJobList');

		/** @var \OC\BackgroundJob\JobList $jobList */
		$backgroundJob->execute($jobList);
		$this->assertTrue(true);
	}

	public function testRunStep() {
		$mailQueueHandler = $this->getMockBuilder('OCA\Activity\MailQueueHandler')
			->disableOriginalConstructor()
			->getMock();
		$config = $this->getMockBuilder('OCP\IConfig')
			->disableOriginalConstructor()
			->getMock();
		$backgroundJob = new EmailNotification(
			$mailQueueHandler,
			$config,
			$this->createMock('OCP\ILogger'),
			true
		);

		$mailQueueHandler->expects($this->any())
			->method('getAffectedUsers')
			->with(2, 200)
			->willReturn([
				['uid' => 'test1', 'email' => 'test1@localhost'],
				['uid' => 'test2', 'email' => ''],
			]);
		$mailQueueHandler->expects($this->once())
			->method('sendEmailToUser')
			->with('test1', 'test1@localhost', 'de', \date_default_timezone_get(), $this->anything());
		$config->expects($this->any())
			->method('getUserValueForUsers')
			->willReturnMap([
				['core', 'lang', [
					'test1',
					'test2',
				], [
					'test1' => 'de',
					'test2' => 'en',
				]]
			]);

		$this->assertEquals(2, $this->invokePrivate($backgroundJob, 'runStep', [2, 200]));
	}

	/**
	 * Test run where all emails fail to send - cleanup should error
	 * @expectedException \Exception
	 */
	public function testRunStepWhereEmailThrowsException() {
		$mailQueueHandler = $this->getMockBuilder('OCA\Activity\MailQueueHandler')
			->disableOriginalConstructor()
			->getMock();
		$config = $this->getMockBuilder('OCP\IConfig')
			->disableOriginalConstructor()
			->getMock();
		$backgroundJob = new EmailNotification(
			$mailQueueHandler,
			$config,
			$this->createMock('OCP\ILogger'),
			true
		);

		$mailQueueHandler->expects($this->any())
			->method('getAffectedUsers')
			->with(2, 200)
			->willReturn([
				['uid' => 'test1', 'email' => 'test1@localhost'],
			]);
		$e = new \Exception();
		// Sending the email will throw an exception
		$mailQueueHandler->expects($this->once())
			->method('sendEmailToUser')
			->with('test1', 'test1@localhost', 'de', \date_default_timezone_get(), $this->anything())
			->willThrowException($e);
		$config->expects($this->any())
			->method('getUserValueForUsers')
			->willReturnMap([
				['core', 'lang', [
					'test1'
				], [
					'test1' => 'de'
				]]
			]);

		// Cleanup will be performed, but should now handle having no users supplied to it
		// This deals with the case that the first email in the queue throws
		// an exception that we cannot handle.

		$this->assertEquals(1, $this->invokePrivate($backgroundJob, 'runStep', [2, 200]));
	}
}
