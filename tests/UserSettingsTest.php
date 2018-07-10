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

namespace OCA\Activity\Tests;

use OCA\Activity\Data;
use OCA\Activity\Tests\Mock\Extension;
use OCA\Activity\UserSettings;

class UserSettingsTest extends TestCase {
	/** @var UserSettings */
	protected $userSettings;

	/** @var \PHPUnit_Framework_MockObject_MockObject */
	protected $config;

	protected function setUp() {
		parent::setUp();

		$activityLanguage = \OCP\Util::getL10N('activity', 'en');
		$activityManager = new \OC\Activity\Manager(
			$this->createMock('OCP\IRequest'),
			$this->createMock('OCP\IUserSession'),
			$this->createMock('OCP\IConfig')
		);
		$activityManager->registerExtension(function () use ($activityLanguage) {
			return new Extension($activityLanguage, $this->createMock('\OCP\IURLGenerator'));
		});
		$this->config = $this->createMock('OCP\IConfig');
		$this->userSettings = new UserSettings($activityManager, $this->config, new Data(
			$activityManager,
			$this->createMock('\OCP\IDBConnection'),
			$this->createMock('\OCP\IUserSession')
		));
	}

	protected function tearDown() {
		parent::tearDown();
	}

	public function getDefaultSettingData() {
		return [
			['stream', 'type1', true],
			['email', 'type1', false],
			['setting', 'self', true],
			['setting', 'selfemail', false],
			['setting', 'batchtime', 3600],
			['setting', 'not-exists', false],
		];
	}

	/**
	 * @dataProvider getDefaultSettingData
	 *
	 * @param string $method
	 * @param string $type
	 * @param mixed $expected
	 */
	public function testGetDefaultSetting($method, $type, $expected) {
		$this->assertEquals($expected, $this->userSettings->getDefaultSetting($method, $type));
	}

	public function getNotificationTypesData() {
		return [
			//array('test1', 'stream', array('type1')),
			['noPreferences', 'email', ['type2']],
		];
	}

	/**
	 * @dataProvider getNotificationTypesData
	 *
	 * @param string $user
	 * @param string $method
	 * @param array $expected
	 */
	public function testGetNotificationTypes($user, $method, $expected) {
		$this->config->expects($this->any())
			->method('getUserValue')
			->with($this->anything(), 'activity', $this->stringStartsWith('notify_'), $this->anything())
			->willReturnMap([
				['test1', 'activity', 'notify_stream_type1', true, 1],
				['test1', 'activity', 'notify_stream_type2', true, 0],
				['noPreferences', 'activity', 'notify_email_type1', false, 0],
				['noPreferences', 'activity', 'notify_email_type2', true, 1],
			]);

		$this->assertEquals($expected, $this->userSettings->getNotificationTypes($user, $method));
	}

	public function filterUsersBySettingData() {
		return [
			[[], 'stream', 'type1', []],
			[['test', 'test1', 'test2', 'test3', 'test4'], 'stream', 'type3', ['test1' => 1, 'test4' => 1]],
			[['test', 'test1', 'test2', 'test3', 'test4', 'test5'], 'email', 'type3', ['test1' => '1', 'test4' => '4', 'test5' => 1]],
			[['test', 'test6'], 'stream', 'type1', ['test' => 1, 'test6' => 1]],
			[['test', 'test6'], 'stream', 'type4', ['test6' => 1]],
			[['test6'], 'email', 'type2', ['test6' => '2700']],
			[['test', 'test6'], 'email', 'type2', ['test' => '3600', 'test6' => '2700']],
			[['test', 'test6'], 'email', 'type1', ['test6' => '2700']],
		];
	}

	/**
	 * @dataProvider filterUsersBySettingData
	 *
	 * @param array $users
	 * @param string $method
	 * @param string $type
	 * @param array $expected
	 */
	public function testFilterUsersBySetting($users, $method, $type, $expected) {
		$this->config->expects($this->any())
			->method('getUserValueForUsers')
			->with($this->anything(), $this->anything(), $this->anything())
			->willReturnMap([
				['activity', 'notify_stream_type1', ['test', 'test6'], ['test6' => '1']],
				['activity', 'notify_stream_type4', ['test', 'test6'], ['test6' => '1']],
				['activity', 'notify_stream_type3', ['test', 'test1', 'test2', 'test3', 'test4'], ['test1' => '1', 'test2' => '0', 'test3' => '', 'test4' => '1']],

				['activity', 'notify_email_type1', ['test', 'test6'], ['test6' => '1']],
				['activity', 'notify_email_type2', ['test6'], ['test6' => '1']],
				['activity', 'notify_email_type2', ['test', 'test6'], ['test6' => '1']],
				['activity', 'notify_email_type3', ['test', 'test1', 'test2', 'test3', 'test4', 'test5'], ['test1' => '1', 'test2' => '0', 'test3' => '', 'test4' => '3', 'test5' => '1']],

				['activity', 'notify_setting_batchtime', ['test6'], ['test6' => '2700']],
				['activity', 'notify_setting_batchtime', ['test', 'test6'], ['test6' => '2700']],
				['activity', 'notify_setting_batchtime', ['test1', 'test4', 'test5'], ['test1' => '1', 'test4' => '4']],
			]);

		$this->assertEquals($expected, $this->userSettings->filterUsersBySetting($users, $method, $type));
	}
}
