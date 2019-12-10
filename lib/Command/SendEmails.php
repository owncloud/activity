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

use OCA\Activity\BackgroundJob\EmailNotification;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SendEmails extends Command {
	/** @var EmailNotification */
	private $emailNotification;

	public function __construct(EmailNotification $emailNotification) {
		parent::__construct();
		$this->emailNotification = $emailNotification;
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
			$usersNotified = $this->emailNotification->sendAll();
		} while ($usersNotified > 0);
	}
}
