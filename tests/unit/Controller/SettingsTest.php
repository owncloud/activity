<?php
/**
 * @author Joas Schilling <nickvergessen@owncloud.com>
 * @author Lukas Reschke <lukas@owncloud.com>
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

namespace OCA\Activity\Tests\Controller;

use OCA\Activity\Controller\Settings;
use OCA\Activity\Data;
use OCA\Activity\Tests\Unit\TestCase;
use OCA\Activity\UserSettings;
use OCP\Activity\IExtension;
use OCP\IConfig;
use OCP\IRequest;
use OCP\IURLGenerator;
use OCP\IUser;
use OCP\Security\ISecureRandom;
use OCP\Util;

class SettingsTest extends TestCase {
	/** @var IConfig |  \PHPUnit\Framework\MockObject\MockObject */
	protected $config;

	/** @var IRequest | \PHPUnit\Framework\MockObject\MockObject */
	protected $request;

	/** @var IURLGenerator | \PHPUnit\Framework\MockObject\MockObject */
	protected $urlGenerator;

	/** @var Data | \PHPUnit\Framework\MockObject\MockObject */
	protected $data;

	/** @var ISecureRandom | \PHPUnit\Framework\MockObject\MockObject */
	protected $random;

	/** @var UserSettings | \PHPUnit\Framework\MockObject\MockObject */
	protected $userSettings;

	/** @var \OCP\IL10N */
	protected $l10n;

	/** @var Settings */
	protected $controller;

	/** @var IUser | \PHPUnit\Framework\MockObject\MockObject */
	private $user;

	protected function setUp(): void {
		parent::setUp();

		$this->data = $this->getMockBuilder(Data::class)
			->disableOriginalConstructor()
			->getMock();
		$this->userSettings = $this->getMockBuilder(UserSettings::class)
			->disableOriginalConstructor()
			->getMock();

		$this->config = $this->createMock(IConfig::class);
		$this->request = $this->createMock(IRequest::class);
		$this->urlGenerator = $this->createMock(IURLGenerator::class);
		$this->random = $this->createMock(ISecureRandom::class);
		$this->l10n = Util::getL10N('activity', 'en');

		$this->user = $this->createMock(IUser::class);
		$this->user->expects($this->any())->method('getUID')->willReturn('test');

		$this->controller = new Settings(
			'activity',
			$this->request,
			$this->config,
			$this->random,
			$this->urlGenerator,
			$this->data,
			$this->userSettings,
			$this->l10n,
			$this->user
		);
	}

	public function personalNonTypeSettingsData() {
		return [
			[3600, false, false, 0, false, false],
			[3600 * 24, true, false, 1, true, false],
			[3600 * 24 * 7, false, true, 2, false, true],
			[1, false, true, 255, false, true],
		];
	}

	/**
	 * @dataProvider personalNonTypeSettingsData
	 *
	 * @param int $expectedBatchTime
	 * @param bool $notifyEmail
	 * @param bool $notifyStream
	 * @param int $notifySettingBatchTime
	 * @param bool $notifySettingSelf
	 * @param bool $notifySettingSelfEmail
	 */
	public function testPersonalNonTypeSettings($expectedBatchTime, $notifyEmail, $notifyStream, $notifySettingBatchTime, $notifySettingSelf, $notifySettingSelfEmail) {
		$this->data->expects($this->any())
			->method('getNotificationTypes')
			->willReturn([
				'NotificationTestTypeShared' => 'Share description',
				'NotificationTestNoStream' => [
					'desc' => 'Email description',
					'methods' => [IExtension::METHOD_MAIL],
				],
				'NotificationTestNoEmail' => [
					'desc' => 'Stream description',
					'methods' => [IExtension::METHOD_STREAM],
				],
			]);

		$this->request->expects($this->any())
			->method('getParam')
			->willReturnMap([
				['NotificationTestTypeShared_email', false, $notifyEmail],
				['NotificationTestTypeShared_stream', false, $notifyStream],
				['NotificationTestNoStream_email', false, $notifyEmail],
				['NotificationTestNoEmail_stream', false, $notifyStream],
			]);

		$this->config
			->expects($this->exactly(7))
			->method('setUserValue')
			->withConsecutive(
				[
					'test',
					'activity',
					'notify_email_NotificationTestTypeShared',
					$notifyEmail,
				],
				[
					'test',
					'activity',
					'notify_stream_NotificationTestTypeShared',
					$notifyStream,
				],
				[
					'test',
					'activity',
					'notify_email_NotificationTestNoStream',
					$notifyEmail,
				],
				[
					'test',
					'activity',
					'notify_stream_NotificationTestNoEmail',
					$notifyStream,
				],
				[
					'test',
					'activity',
					'notify_setting_batchtime',
					$expectedBatchTime,
				],
				[
					'test',
					'activity',
					'notify_setting_self',
					$notifySettingSelf,
				],
				[
					'test',
					'activity',
					'notify_setting_selfemail',
					$notifySettingSelfEmail,
				],
			);

		$response = $this->controller->personal(
			$notifySettingBatchTime,
			$notifySettingSelf,
			$notifySettingSelfEmail
		)->getData();
		$this->assertDataResponse($response);
	}

	/**
	 * @param array $response
	 */
	protected function assertDataResponse($response) {
		$this->assertEquals(1, \sizeof($response));
		$this->assertArrayHasKey('data', $response);
		$data = $response['data'];
		$this->assertEquals(1, \sizeof($data));
		$this->assertArrayHasKey('message', $data);
		$this->assertEquals('Your settings have been updated.', $data['message']);
	}

	public function testDisplayPanelTypeTable() {
		$this->data->expects($this->any())
			->method('getNotificationTypes')
			->willReturn([
				'NotificationTestTypeShared'	=> 'Share description',
				'NotificationTestTypeShared2'	=> [
					'desc' => 'Share description2',
					'methods' => [IExtension::METHOD_MAIL],
				],
			]);

		$renderedResponse = $this->controller->displayPanel()->render();
		$this->assertStringContainsString('<form id="activity_notifications" class="section">', $renderedResponse);

		// Checkboxes for the type
		$this->assertStringContainsString('<label for="NotificationTestTypeShared_email">', $renderedResponse);
		$this->assertStringContainsString('<label for="NotificationTestTypeShared_stream">', $renderedResponse);

		$cleanedResponse = \str_replace(["\n", "\t"], ' ', $renderedResponse);
		while (\strpos($cleanedResponse, '  ') !== false) {
			$cleanedResponse = \str_replace('  ', ' ', $cleanedResponse);
		}
		$this->assertStringContainsString('<input type="checkbox" id="NotificationTestTypeShared2_email" name="NotificationTestTypeShared2_email" value="1" class="NotificationTestTypeShared2 email checkbox" />', $cleanedResponse);
		$this->assertStringContainsString('<input type="checkbox" id="NotificationTestTypeShared2_stream" name="NotificationTestTypeShared2_stream" value="1" class="NotificationTestTypeShared2 stream checkbox" disabled="disabled" />', $cleanedResponse);

		// Description of the type
		$cleanedResponse = \str_replace(["\n", "\t"], '', $renderedResponse);
		$this->assertStringContainsString('<td class="activity_select_group" data-select-group="NotificationTestTypeShared">Share description</td>', $cleanedResponse);
	}

	public function displayPanelEmailWarningData() {
		return [
			['', true],
			['test@localhost', false],
		];
	}

	/**
	 * @dataProvider displayPanelEmailWarningData
	 *
	 * @param string $email
	 * @param bool $containsWarning
	 */
	public function testDisplayPanelEmailWarning($email, $containsWarning) {
		$this->data->expects($this->any())
			->method('getNotificationTypes')
			->willReturn([]);
		$this->user->expects($this->any())
			->method('getEmailAddress')
			->willReturn($email);

		$renderedResponse = $this->controller->displayPanel()->render();
		$this->assertStringContainsString('<form id="activity_notifications" class="section">', $renderedResponse);

		if ($containsWarning) {
			$this->assertStringContainsString('You need to set up your email address before you can receive notification emails.', $renderedResponse);
		} else {
			$this->assertStringNotContainsString('You need to set up your email address before you can receive notification emails.', $renderedResponse);
		}
	}

	public function displayPanelEmailSendBatchSettingData() {
		return [
			[0, 0, 'Hourly'],
			[1, 255, 'As soon as possible'],
			['foobar', 0, 'Hourly'],
			[3600, 0, 'Hourly'],
			[3600 * 24, 1, 'Daily'],
			[3600 * 24 * 7, 2, 'Weekly'],
		];
	}

	/**
	 * @dataProvider displayPanelEmailSendBatchSettingData
	 *
	 * @param string $setting
	 * @param int $selectedValue
	 * @param string $selectedLabel
	 */
	public function testDisplayPanelEmailSendBatchSetting($setting, $selectedValue, $selectedLabel) {
		$this->data->expects($this->any())
			->method('getNotificationTypes')
			->willReturn([]);
		$this->userSettings->expects($this->any())
			->method('getUserSetting')
			->willReturn($setting);

		$renderedResponse = $this->controller->displayPanel()->render();
		$this->assertStringContainsString('<form id="activity_notifications" class="section">', $renderedResponse);

		$this->assertStringContainsString('<option value="' . $selectedValue . '" selected="selected">' . $selectedLabel . '</option>', $renderedResponse);
	}

	public function feedData() {
		return [
			['true', '012345678901234567890123456789', 'feedurl::'],
			['false', '', ''],
		];
	}

	/**
	 * @dataProvider feedData
	 *
	 * @param string $enabled
	 * @param string $token
	 * @param string $urlPrefix
	 */
	public function testFeed($enabled, $token, $urlPrefix) {
		$this->data->expects($this->any())
			->method('getNotificationTypes')
			->willReturn([]);
		$this->random->expects($this->any())
			->method('generate')
			->with(30)
			->willReturn('012345678901234567890123456789');
		$this->urlGenerator->expects($this->any())
			->method('linkToRouteAbsolute')
			->with('activity.Feed.show', ['token' => '012345678901234567890123456789'])
			->willReturn('feedurl::012345678901234567890123456789');
		$this->config->expects($this->once())
			->method('setUserValue')
			->with('test', 'activity', 'rsstoken', $token);

		$response = $this->controller->feed($enabled)->getData();
		$this->assertEquals(1, \sizeof($response));
		$this->assertArrayHasKey('data', $response);
		$data = $response['data'];
		$this->assertEquals(2, \sizeof($data));
		$this->assertArrayHasKey('message', $data);
		$this->assertArrayHasKey('rsslink', $data);

		$this->assertEquals($urlPrefix . $token, $data['rsslink']);
		$this->assertEquals('Your settings have been updated.', $data['message']);
	}
}
