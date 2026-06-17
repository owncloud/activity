<?php
/**
 * ownCloud
 *
 * @author Phillip Davis <phil@jankaritech.com>
 * @copyright Copyright (c) 2026, ownCloud GmbH
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License,
 * as published by the Free Software Foundation;
 * either version 3 of the License, or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 *
 */

use Behat\Config\Config;
use Behat\Config\Extension;
use Behat\Config\Profile;
use Behat\Config\Suite;
use Cjm\Behat\StepThroughExtension\ServiceContainer\StepThroughExtension;

$featureContextArgs = [
	'baseUrl' => 'http://localhost:8080',
	'adminUsername' => 'admin',
	'adminPassword' => 'admin',
	'regularUserPassword' => 123456,
	'ocPath' => 'apps/testing/api/v1/occ',
];

return (new Config())
	->withProfile(
		(new Profile(
			'default',
			[
			'autoload' => [
			'' => '%paths.base%/../features/bootstrap',
			],
			]
		))
			->withExtension(new Extension(StepThroughExtension::class))
			->withSuite(
				(new Suite('webUIActivityComments'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'CommentsContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->withPaths('%paths.base%/../features/webUIActivityComments')
			)
			->withSuite(
				(new Suite('webUIActivityCreateUpdate'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->withPaths('%paths.base%/../features/webUIActivityCreateUpdate')
			)
			->withSuite(
				(new Suite('webUIActivityDeleteRestore'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'OccContext',
					)
					->addContext(
						'TrashbinContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->withPaths('%paths.base%/../features/webUIActivityDeleteRestore')
			)
			->withSuite(
				(new Suite('webUIActivityFileMoveAndRename'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->addContext(
						'WebUISharingContext',
					)
					->addContext(
						'OccContext',
					)
					->withPaths('%paths.base%/../features/webUIActivityFileMoveAndRename')
			)
			->withSuite(
				(new Suite('webUIActivitySharingExternal'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'FederationContext',
					)
					->addContext(
						'OccContext',
					)
					->addContext(
						'PublicWebDavContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->addContext(
						'WebUISharingContext',
					)
					->withPaths('%paths.base%/../features/webUIActivitySharingExternal')
			)
			->withSuite(
				(new Suite('webUIActivitySharingInternal'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->addContext(
						'WebUISharingContext',
					)
					->addContext(
						'OccContext',
					)
					->addContext(
						'TrashbinContext',
					)
					->withPaths('%paths.base%/../features/webUIActivitySharingInternal')
			)
			->withSuite(
				(new Suite('webUIActivityTags'))
					->addContext(
						'WebUIActivityContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'TagsContext',
					)
					->addContext(
						'WebUIFilesContext',
					)
					->addContext(
						'WebUIGeneralContext',
					)
					->addContext(
						'WebUILoginContext',
					)
					->addContext(
						'WebUIPersonalGeneralSettingsContext',
					)
					->withPaths('%paths.base%/../features/webUIActivityTags')
			)
			->withSuite(
				(new Suite('apiActivity'))
					->addContext(
						'ActivityContext',
					)
					->addContext(
						'OccContext',
					)
					->addContext(
						'TrashbinContext',
					)
					->addContext(
						'PublicWebDavContext',
					)
					->addContext(
						'FeatureContext',
						$featureContextArgs
					)
					->addContext(
						'FederationContext',
					)
					->withPaths('%paths.base%/../features/apiActivity')
			)
	);
