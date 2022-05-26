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
use OCA\Activity\Tests\Unit\TestCase;
use OCP\IGroup;
use OCP\IGroupManager;

class GroupFormatterTest extends TestCase {

	/** @var  \OCP\IGroupManager|\PHPUnit\Framework\MockObject\MockObject */
	protected $groupManager;

	/**
	 * @param array $methods
	 * @return IFormatter|\PHPUnit\Framework\MockObject\MockObject
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
			['para<m>eter1', '<parameter>display:para&lt;m&gt;eter1</parameter>'],
			['para<m>eter2', '<parameter>display:para&lt;m&gt;eter2</parameter>'],
			['unknown', '<parameter>unknown</parameter>', false],
		];
	}

	/**
	 * @dataProvider dataFormat
	 *
	 * @param string $parameter
	 * @param string $expected
	 */
	public function testFormat($parameter, $expected, $groupKnown = true) {
		/** @var \OCP\Activity\IEvent|\PHPUnit\Framework\MockObject\MockObject $event */
		$event = $this->getMockBuilder('OCP\Activity\IEvent')
			->disableOriginalConstructor()
			->getMock();

		$formatter = $this->getFormatter();
		$group = null;
		if ($groupKnown) {
			$group = $this->createMock(IGroup::class);
			$group->expects($this->once())
				->method('getDisplayName')
				->willReturn("display:$parameter");
		}
		$this->groupManager->expects($this->once())
			->method('get')
			->willReturn($group);

		$this->assertSame($expected, $formatter->format($event, $parameter));
	}
}
