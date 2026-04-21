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

namespace OCA\Activity\Formatter;

use OCP\Activity\IEvent;
use OCP\Util;

class BaseFormatter implements IFormatter {
	/**
	 * @param IEvent $event
	 * @param string $parameter The parameter to be formatted
	 * @return string|array The formatted parameter
	 */
	public function format(IEvent $event, string|array $parameter) {
		$sanitizedParameter = Util::sanitizeHTML($parameter);
		if (\is_array($sanitizedParameter)) {
			$sanitizedParameter = \implode("", $sanitizedParameter);
		}
		return '<parameter>' . $sanitizedParameter . '</parameter>';
	}
}
