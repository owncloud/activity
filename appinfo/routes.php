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

OC_API::register(
	'get',
	'/apps/activity/api/v1',
	array('OCA\Activity\Api', 'get'),
	'activity'
);

OC_API::register(
	'get',
	'/apps/activity/api/v1/page/{page}',
	array('OCA\Activity\Api', 'getPage'),
	'activity'
);

OC_API::register(
	'get',
	'/apps/activity/api/v1/filter/{filter}',
	array('OCA\Activity\Api', 'getFilter'),
	'activity'
);

OC_API::register(
	'get',
	'/apps/activity/api/v1/filter/{filter}/page/{page}',
	array('OCA\Activity\Api', 'getFilterPage'),
	'activity'
);
