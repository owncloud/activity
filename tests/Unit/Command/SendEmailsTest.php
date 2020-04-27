<?php
/**
 * @author Viktar Dubiniuk <dubiniuk@owncloud.com>
 *
 * @copyright Copyright (c) 2019, ownCloud, Inc.
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

namespace OCA\Activity\Tests\Command;

use OCA\Activity\Command\SendEmails;
use OCA\Activity\MailQueueHandler;
use OCA\Activity\Tests\Unit\TestCase;
use OCP\IConfig;
use OCP\ILogger;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Tester\CommandTester;

/**
 * Class SendEmailsTest
 *
 * @group DB
 */
class SendEmailsTest extends TestCase {
	/** @var MailQueueHandler | \PHPUnit\Framework\MockObject\MockObject */
	private $mqHandler;

	/** @var IConfig | \PHPUnit\Framework\MockObject\MockObject */
	private $config;

	/** @var ILogger | \PHPUnit\Framework\MockObject\MockObject */
	private $logger;

	/** @var SendEmails */
	private $sendEmails;

	protected function setUp(): void {
		parent::setUp();
		$this->mqHandler = $this->createMock(MailQueueHandler::class);
		$this->config = $this->createMock(IConfig::class);
		$this->logger = $this->createMock(ILogger::class);
		$this->sendEmails = new SendEmails($this->mqHandler, $this->config, $this->logger);
	}

	public function testSend() {
		$this->mqHandler->method('getAllUsers')
			->willReturnOnConsecutiveCalls(
				[
					[
						'uid' => 'anon',
						'email' => 'anon@im.org',
						'max_mail_id' => 50,
					]
				],
				[]
			);
		$this->mqHandler->expects($this->once())
			->method('sendAllEmailsToUser')
			->with('anon', 'anon@im.org', 'en', 'UTC', 50);
		$this->mqHandler->expects($this->once())
			->method('deleteAllSentItems')
			->with([
				['uid' => 'anon', 'maxMailId' => 50]
			]);

		$this->config->method('getUserValueForUsers')->willReturnOnConsecutiveCalls(
				['anon' => 'en'],
				['anon' => 'UTC']
		);

		$this->sendEmails->execute(
			$this->createMock(InputInterface::class),
			$this->createMock(OutputInterface::class)
		);
	}

	public function testSendVerbose() {
		$exceptionMessage = 'broken intentionally';
		$this->mqHandler->method('getAllUsers')
			->willReturnOnConsecutiveCalls(
				[
					[
						'uid' => 'anon',
						'email' => 'anon@im.org',
						'max_mail_id' => 50,
					]
				],
				[]
			);
		$this->mqHandler->expects($this->once())
			->method('sendAllEmailsToUser')
			->willThrowException(new \Exception($exceptionMessage));
		$this->mqHandler->expects($this->once())
			->method('deleteAllSentItems')
			->with([]);

		$this->config->method('getUserValueForUsers')->willReturnOnConsecutiveCalls(
			['anon' => 'en'],
			['anon' => 'UTC']
		);

		$tester = new CommandTester($this->sendEmails);
		$tester->execute([], ['verbosity' => OutputInterface::VERBOSITY_VERY_VERBOSE]);
		$output = $tester->getDisplay();
		$this->assertStringContainsString("Notification to user 'anon' has been not sent: {$exceptionMessage}", $output);
	}
}
