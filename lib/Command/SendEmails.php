<?php
/**
 * @author Viktar Dubiniuk <dubiniuk@owncloud.com>
 *
 * @copyright Copyright (c) 2019, ownCloud GmbH
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

namespace OCA\Activity\Command;

use OCA\Activity\MailQueueHandler;
use OCP\IConfig;
use OCP\ILogger;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SendEmails extends Command {
	const BATCH_SIZE = 250;

	/** @var MailQueueHandler */
	private $mqHandler;

	/** @var IConfig */
	private $config;

	/** @var ILogger */
	private $logger;

	/**
	 * SendEmails constructor.
	 *
	 * @param MailQueueHandler $mailQueueHandler
	 * @param IConfig $config
	 * @param ILogger $logger
	 */
	public function __construct(MailQueueHandler $mailQueueHandler,
								   IConfig $config,
								   ILogger $logger) {
		parent::__construct();
		$this->mqHandler = $mailQueueHandler;
		$this->config = $config;
		$this->logger = $logger;
	}

	protected function configure() {
		$this->setName('activity:send-emails')
			->setDescription('Send all pending activity emails now');
	}

	/**
	 * @param InputInterface $input
	 * @param OutputInterface $output
	 *
	 * @return int|void
	 */
	public function execute(InputInterface $input, OutputInterface $output) {
		do {
			$usersNotified = $this->sendBatch();
		} while ($usersNotified > 0);
	}

	protected function sendBatch() {
		$allUsers = $this->mqHandler->getAllUsers(self::BATCH_SIZE);
		if (empty($allUsers)) {
			// No users found to notify, mission abort
			return 0;
		}

		$affectedUIDs = \array_map(function ($u) {
			return $u['uid'];
		}, $allUsers);
		$userLanguages = $this->config->getUserValueForUsers('core', 'lang', $affectedUIDs);
		$userTimezones = $this->config->getUserValueForUsers('core', 'timezone', $affectedUIDs);
		$defaultLang = $this->config->getSystemValue('default_language', 'en');
		$defaultTimeZone = \date_default_timezone_get();

		$sentMailForUsers = [];
		foreach ($allUsers as $user) {
			$uid = $user['uid'];
			if (empty($user['email'])) {
				// The user did not setup an email address
				// So we will not send an email but still discard the queue entries
				$this->logger->debug("Couldn't send notification email to user '$uid' (email address isn't set for that user)", ['app' => 'activity']);
				$sentMailForUsers[] = [
					'uid' => $uid,
					'maxMailId' => $user['max_mail_id']
				];
				continue;
			}

			try {
				$language = (!empty($userLanguages[$uid])) ? $userLanguages[$uid] : $defaultLang;
				$timezone = (!empty($userTimezones[$uid])) ? $userTimezones[$uid] : $defaultTimeZone;
				$this->mqHandler->sendAllEmailsToUser($uid, $user['email'], $language, $timezone, $user['max_mail_id']);
				$sentMailForUsers[] = [
					'uid' => $uid,
					'maxMailId' => $user['max_mail_id']
				];
			} catch (\Exception $e) {
				// Delete all entries we dealt with
				$this->mqHandler->deleteAllSentItems($sentMailForUsers);

				// Throw the exception again - which gets logged by core and the job is handled appropriately
				throw $e;
			}
		}

		// Delete all entries we dealt with
		$this->mqHandler->deleteAllSentItems($sentMailForUsers);

		return \count($allUsers);
	}
}
