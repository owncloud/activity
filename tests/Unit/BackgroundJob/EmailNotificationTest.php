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
use OCA\Activity\MailQueueHandler;
use OCA\Activity\Tests\Unit\TestCase;
use OCP\BackgroundJob\IJobList;
use OCP\IConfig;
use OCP\ILogger;
use OCP\IUser;
use OCP\IUserManager;
use PHPUnit\Framework\MockObject\MockObject;

/**
 * Class EmailNotificationTest
 *
 * @group DB
 * @package OCA\Activity\Tests\BackgroundJob
 */
class EmailNotificationTest extends TestCase {
	/** @var MailQueueHandler | MockObject */
	private $mqHandler;

	/** @var IUserManager | MockObject */
	private $userManager;

	/** @var IConfig | MockObject */
	private $config;

	/** @var ILogger | MockObject */
	private $logger;

	protected function setUp(): void {
		parent::setUp();
		$this->mqHandler = $this->createMock(MailQueueHandler::class);
		$this->userManager = $this->createMock(IUserManager::class);
		$this->config = $this->createMock(IConfig::class);
		$this->logger = $this->createMock(ILogger::class);
	}

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
			$this->mqHandler,
			$this->userManager,
			$this->config,
			$this->logger,
			$isCLI
		);

		$jobList = $this->createMock(IJobList::class);

		/** @var JobList $jobList */
		$backgroundJob->execute($jobList);
		$this->assertTrue(true);
	}

	public function testRunStep() {
		$backgroundJob = new EmailNotification(
			$this->mqHandler,
			$this->userManager,
			$this->config,
			$this->logger,
			true
		);

		$this->mqHandler->expects($this->any())
			->method('getAffectedUsers')
			->with(2, 200)
			->willReturn([
				['uid' => 'test1', 'email' => 'test1@localhost'],
				['uid' => 'test2', 'email' => ''],
			]);
		$this->mqHandler->expects($this->once())
			->method('sendEmailToUser')
			->with('test1', 'test1@localhost', 'de', \date_default_timezone_get(), $this->anything());
		$this->config->expects($this->any())
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
		$fakeUser = $this->createMock(IUser::class);
		$fakeUser->expects($this->once())->method('isEnabled')
			->willReturn(true);
		$this->userManager->method('get')->willReturn($fakeUser);

		$this->assertEquals(2, $this->invokePrivate($backgroundJob, 'runStep', [2, 200]));
	}

	/**
	 * Test run where all emails fail to send - cleanup should error
	 */
	public function testRunStepWhereEmailThrowsException() {
		$this->expectException(\Exception::class);

		$backgroundJob = new EmailNotification(
			$this->mqHandler,
			$this->userManager,
			$this->config,
			$this->logger,
			true
		);

		$this->mqHandler->expects($this->any())
			->method('getAffectedUsers')
			->with(2, 200)
			->willReturn([
				['uid' => 'test1', 'email' => 'test1@localhost'],
			]);
		$e = new \Exception();
		// Sending the email will throw an exception
		$this->mqHandler->expects($this->once())
			->method('sendEmailToUser')
			->with('test1', 'test1@localhost', 'de', \date_default_timezone_get(), $this->anything())
			->willThrowException($e);
		$this->config->expects($this->any())
			->method('getUserValueForUsers')
			->willReturnMap([
				['core', 'lang', [
					'test1'
				], [
					'test1' => 'de'
				]]
			]);
		$fakeUser = $this->createMock(IUser::class);
		$fakeUser->expects($this->once())->method('isEnabled')
			->willReturn(true);
		$this->userManager->method('get')->willReturn($fakeUser);

		// Cleanup will be performed, but should now handle having no users supplied to it
		// This deals with the case that the first email in the queue throws
		// an exception that we cannot handle.

		$this->assertEquals(1, $this->invokePrivate($backgroundJob, 'runStep', [2, 200]));
	}
}
