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
 *
 */

namespace OCA\Activity;

/**
 * Class Api
 *
 * @package OCA\Activity
 */
class Api
{
	const MAX_ELEMENTS = 25;

	static public function get($param) {
		$param['filter'] = 'all';
		$param['page'] = 1;
		return self::getFilterPage($param);
	}

	static public function getPage($param) {
		$param['filter'] = 'all';
		$param['page'] = (isset($param['page'])) ? $param['page'] : 1;
		return self::getFilterPage($param);
	}

	static public function getFilter($param) {
		$param['filter'] = (isset($param['filter'])) ? $param['filter'] : 'all';
		$param['page'] = 1;
		return self::getFilterPage($param);
	}

	static public function getFilterPage($param) {
		$allowGrouping = (isset($_GET['allowgrouping']) && (!$_GET['allowgrouping'] || $_GET['allowgrouping'] === 'false')) ? false : true;
		$filter = (isset($param['filter'])) ? $param['filter'] : 'all';
		$page = (isset($param['page'])) ? $param['page'] : 1;
		$offset = (max($page, 1) - 1) * self::MAX_ELEMENTS;

		$activities = Data::read($offset, self::MAX_ELEMENTS, $filter, $allowGrouping);
		return new \OC_OCS_Result(array(
			'filter'		=> $filter,
			'page'			=> $page,
			'allowgrouping'	=> $allowGrouping,
			'activities'	=> $activities,
		));
	}
}
