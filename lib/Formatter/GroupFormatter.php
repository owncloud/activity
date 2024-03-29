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

namespace OCA\Activity\Formatter;

use OCP\Activity\IEvent;
use OCP\IGroupManager;
use OCP\Util;

class GroupFormatter implements IFormatter {
	/** @var IGroupManager  */
	protected $groupManager;

	public function __construct(IGroupManager $groupManager) {
		$this->groupManager = $groupManager;
	}

	/**
	 * @param IEvent $event
	 * @param string $parameter The parameter to be formatted
	 * @return string The formatted parameter
	 */
	public function format(IEvent $event, $parameter) {
		$group = $this->groupManager->get($parameter);
		$displayName = $parameter;
		if ($group !== null) {
			$displayName = $group->getDisplayName();
		}
		return '<parameter>' . Util::sanitizeHTML($displayName) . '</parameter>';
	}
}
