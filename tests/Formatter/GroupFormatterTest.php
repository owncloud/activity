<?php
/**
 * @author Sujith Haridasan <sharidasan@owncloud.com>
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

namespace OCA\Activity\Tests\Formatter;

use OCA\Activity\Formatter\IFormatter;
use OCA\Activity\Formatter\GroupFormatter;
use OCA\Activity\Tests\TestCase;
use OCP\IGroup;
use OCP\IGroupManager;

class GroupFormatterTest extends TestCase {

	/** @var  \OCP\IGroupManager|\PHPUnit_Framework_MockObject_MockObject */
	protected $groupManager;

	/**
	 * @param array $methods
	 * @return IFormatter|\PHPUnit_Framework_MockObject_MockObject
	 */
	public function getFormatter(array $methods = []) {
		if (empty($methods)) {
			$this->groupManager = $this->createMock(IGroupManager::class);
			return new GroupFormatter($this->groupManager);
		} else {
			return $this->getMockBuilder('OCA\Activity\Formatter\BaseFormatter')
				->setConstructorArgs([
				])
				->setMethods($methods)
				->getMock();
		}
	}

	public function dataFormat() {
		return [
			['para<m>eter1', '<parameter>para&lt;m&gt;eter1</parameter>'],
			['para<m>eter2', '<parameter>para&lt;m&gt;eter2</parameter>'],
		];
	}

	/**
	 * @dataProvider dataFormat
	 *
	 * @param string $parameter
	 * @param string $expected
	 */
	public function testFormat($parameter, $expected) {
		/** @var \OCP\Activity\IEvent|\PHPUnit_Framework_MockObject_MockObject $event */
		$event = $this->getMockBuilder('OCP\Activity\IEvent')
			->disableOriginalConstructor()
			->getMock();

		$formatter = $this->getFormatter();
		$group = $this->createMock(IGroup::class);
		$this->groupManager->expects($this->once())
			->method('get')
			->willReturn($group);
		$group->expects($this->once())
			->method('getDisplayName')
			->willReturn($parameter);

		$this->assertSame($expected, $formatter->format($event, $parameter));
	}
}
