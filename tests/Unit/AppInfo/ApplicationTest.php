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

namespace OCA\Activity\Tests\AppInfo;

use OCA\Activity\AppInfo\Application;
use OCA\Activity\Tests\Unit\TestCase;

/**
 * Class ApplicationTest
 *
 * @group DB
 * @package OCA\Activity\Tests\AppInfo
 */
class ApplicationTest extends TestCase {
	/** @var \OCA\Activity\AppInfo\Application */
	protected $app;

	/** @var \OCP\AppFramework\IAppContainer */
	protected $container;

	protected function setUp() {
		parent::setUp();
		$this->app = new Application();
		$this->container = $this->app->getContainer();
	}

	public function testContainerAppName() {
		$this->app = new Application();
		$this->assertEquals('activity', $this->container->getAppName());
	}

	public function queryData() {
		return [
			['ActivityData', 'OCA\Activity\Data'],
			['OCP\IL10N', 'OCP\IL10N'],
			['Consumer', 'OCA\Activity\Consumer'],
			['Consumer', 'OCP\Activity\IConsumer'],
			['DataHelper', 'OCA\Activity\DataHelper'],
			['GroupHelper', 'OCA\Activity\GroupHelper'],
			['Hooks', 'OCA\Activity\FilesHooks'],
			['MailQueueHandler', 'OCA\Activity\MailQueueHandler'],
			['Navigation', 'OCA\Activity\Navigation'],
			['UserSettings', 'OCA\Activity\UserSettings'],
			['OCA\Activity\ViewInfoCache', 'OCA\Activity\ViewInfoCache'],
			['SettingsController', 'OCP\AppFramework\Controller'],
			['ActivitiesController', 'OCP\AppFramework\Controller'],
			['FeedController', 'OCP\AppFramework\Controller'],
		];
	}

	/**
	 * @dataProvider queryData
	 * @param string $service
	 * @param string $expected
	 */
	public function testContainerQuery($service, $expected) {
		$this->assertTrue($this->container->query($service) instanceof $expected);
	}
}
