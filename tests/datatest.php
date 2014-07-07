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

class DataTest extends \PHPUnit_Framework_TestCase {
	public function getFilterFromParamData() {
		return array(
			array('exists', 'test', 'all'),
			array('exists', 'all', 'all'),
			array('exists', 'by', 'by'),
			array('exists', 'files', 'files'),
			array('exists', 'self', 'self'),
			array('exists', 'shares', 'shares'),
			array('not-exists', 'test', 'all'),
		);
	}

	/**
	 * @dataProvider getFilterFromParamData
	 */
	public function testGetFilterFromParam($parameter, $globalValue, $expected) {
		$_GET['exists'] = $globalValue;

		$this->assertEquals(
			$expected,
			\OCA\Activity\Data::getFilterFromParam($parameter)
		);
	}
}
