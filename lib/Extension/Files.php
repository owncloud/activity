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

namespace OCA\Activity\Extension;

class Files {
	public const TYPE_SHARE_CREATED = 'file_created';
	public const TYPE_SHARE_CHANGED = 'file_changed';
	public const TYPE_SHARE_DELETED = 'file_deleted';
	public const TYPE_SHARE_RESTORED = 'file_restored';
	public const TYPE_FILE_RENAMED = 'file_renamed';
	public const TYPE_FILE_MOVED = 'file_moved';
}
