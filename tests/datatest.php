<?php

/**
 * ownCloud - Activity App
 *
 * @author Joas Schilling
 * @copyright 2014 Joas Schilling nickvergessen@owncloud.com
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU AFFERO GENERAL PUBLIC LICENSE for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace OCA\Activity\Tests;

use OCA\Activity\Data;
use OCP\Activity\IExtension;

class DataTest extends TestCase {
	public function getFilterFromParamData() {
		return array(
			array('test', 'all'),
			array('all', 'all'),
			array('by', 'by'),
			array('files', 'files'),
			array('self', 'self'),
			array('shares', 'shares'),
			array('test', 'all'),
			array(null, 'all'),
		);
	}

	/**
	 * @dataProvider getFilterFromParamData
	 */
	public function testGetFilterFromParam($globalValue, $expected) {
		if ($globalValue !== null) {
			$_GET['filter'] = $globalValue;
		}

		$data = new \OCA\Activity\Data(
			$this->getMock('\OCP\Activity\IManager')
		);
		$this->assertEquals(
			$expected,
			$data->getFilterFromParam()
		);
	}

	public function dataSend() {
		return [
			// Default case
			['author', 'affectedUser', 'author', 'affectedUser', true],
			// Public page / Incognito mode
			['', 'affectedUser', '', 'affectedUser', true],
			// No affected user, falling back to author
			['author', '', 'author', 'author', true],
			// No affected user and no author => no activity
			['', '', '', '', false],
		];
	}

	/**
	 * @dataProvider dataSend
	 *
	 * @param string $actionUser
	 * @param string $affectedUser
	 */
	public function testSend($actionUser, $affectedUser, $expectedAuthor, $expectedAffected, $expectedActivity) {
		$mockSession = $this->getMockBuilder('\OC\User\Session')
			->disableOriginalConstructor()
			->getMock();

		if ($actionUser !== '') {
			$mockUser = $this->getMockBuilder('\OCP\IUser')
				->disableOriginalConstructor()
				->getMock();
			$mockUser->expects($this->any())
				->method('getUID')
				->willReturn($actionUser);

			$mockSession->expects($this->any())
				->method('getUser')
				->willReturn($mockUser);
		} else {
			$mockSession->expects($this->any())
				->method('getUser')
				->willReturn(null);
		}

		$this->overwriteService('UserSession', $mockSession);
		$this->deleteTestActivities();

		$this->assertSame($expectedActivity, Data::send('test', 'subject', [], '', [], '', '', $affectedUser, 'type', IExtension::PRIORITY_MEDIUM));

		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->prepare('SELECT `user`, `affecteduser` FROM `*PREFIX*activity` WHERE `app` = ? ORDER BY `activity_id` DESC');
		$query->execute(['test']);
		$row = $query->fetch();

		if ($expectedActivity) {
			$this->assertEquals(['user' => $expectedAuthor, 'affecteduser' => $expectedAffected], $row);
		} else {
			$this->assertFalse($row);
		}

		$this->deleteTestActivities();
		$this->restoreService('UserSession');
	}

	/**
	 * Delete all testing activities
	 */
	public function deleteTestActivities() {
		$connection = \OC::$server->getDatabaseConnection();
		$query = $connection->prepare('DELETE FROM `*PREFIX*activity` WHERE `app` = ?');
		$query->execute(['test']);
	}
}
