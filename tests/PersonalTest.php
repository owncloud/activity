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

namespace OCA\Activity\Tests;
use OCA\Activity\AppInfo\Application;
use OCA\Activity\Controller\Settings;
use OCA\Activity\PersonalPanel;
use OCP\AppFramework\IAppContainer;

/**
 * Class PersonalTest
 *
 * @package OCA\Activity\Tests
 */
class PersonalTest extends TestCase {

	protected $panel;
	protected $app;

	public function setUp() {
		parent::setUp();
		$this->app = $this->getMockBuilder(Application::class)
			->disableOriginalConstructor()
			->getMock();
		$this->panel = new PersonalPanel($this->app);
	}

	public function testReturnsTemplateResponse() {
		$container = $this->getMockBuilder(IAppContainer::class)->getMock();
		$controller = $this->getMockBuilder(Settings::class)
			->disableOriginalConstructor()->getMock();
		$container->expects($this->once())->method('query')->willReturn($controller);
		$this->app->expects($this->once())->method('getContainer')->willReturn($container);
		$tmpl = $this->panel->getPanel();
	}
}
