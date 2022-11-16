<?php
/**
 * @author Benedikt Kulmann <b@kulmann.biz>
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

namespace OCA\Activity\Tests\Formatter;

use OCA\Activity\Formatter\IFormatter;
use OCA\Activity\Formatter\UrlFormatter;
use OCA\Activity\Tests\Unit\TestCase;
use OCP\Activity\IEvent;

class UrlFormatterTest extends TestCase {
	/**
	 * @param array $methods
	 * @return IFormatter|\PHPUnit\Framework\MockObject\MockObject
	 */
	public function getFormatter(array $methods = []) {
		if (empty($methods)) {
			return new UrlFormatter();
		} else {
			return $this->getMockBuilder(UrlFormatter::class)
				->setConstructorArgs([])
				->setMethods($methods)
				->getMock();
		}
	}

	public function dataFormat() {
		return [
			'empty parameter list' => ['', ''],
			'no url but name given' => [
				\json_encode(['name' => 'ownCloud']),
				''
			],
			'invalid url given' => [
				\json_encode(['url' => 'this is no url']),
				''
			],
			'relative url given' => [
				\json_encode(['url' => '/relative/url']),
				''
			],
			'url as only parameter' => [
				\json_encode(['url' => 'https://owncloud.com/']),
				'<parameter><a href="https://owncloud.com/">https://owncloud.com/</a></parameter>'
			],
			'url and name' => [
				\json_encode(['url' => 'https://owncloud.com/', 'name' => 'ownCloud']),
				'<parameter><a href="https://owncloud.com/">ownCloud</a></parameter>'
			],
			'url, name and invalid target' => [
				\json_encode(['url' => 'https://owncloud.com/', 'name' => 'ownCloud', 'target' => 'invalid']),
				'<parameter><a href="https://owncloud.com/">ownCloud</a></parameter>'
			],
			'url, name and valid target' => [
				\json_encode(['url' => 'https://owncloud.com/', 'name' => 'ownCloud', 'target' => '_blank']),
				'<parameter><a href="https://owncloud.com/" target="_blank">ownCloud</a></parameter>'
			],
		];
	}

	/**
	 * @dataProvider dataFormat
	 *
	 * @param string $parameter
	 * @param string $expected
	 */
	public function testFormat($parameter, $expected) {
		/** @var \OCP\Activity\IEvent|\PHPUnit\Framework\MockObject\MockObject $event */
		$event = $this->getMockBuilder(IEvent::class)
			->disableOriginalConstructor()
			->getMock();

		$formatter = $this->getFormatter();
		$this->assertSame($expected, $formatter->format($event, $parameter));
	}
}
