<?php
/**
 * ownCloud
 *
 * @author Paurakh Sharma Humagain <paurakh@jankaritech.com>
 * @copyright Copyright (c) 2019, JankariTech
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
namespace Page;

use Behat\Mink\Session;

/**
 * Class ActivitySettingForm
 *
 * @package Page
 */
class ActivitySettingForm extends OwncloudPage {
	private $activityCheckboxXpath = "//td[contains(@data-select-group,'%s')]/preceding-sibling::td[%s]";
	private $activityCheckboxId = "//input[@id='%s']";

	/**
	 * change activity log setting
	 *
	 * @param string $disablesOrEnables
	 * @param string $streamOrMail
	 * @param string $activityType
	 * @param Session $session
	 *
	 * @return void
	 * @throws \Exception
	 */
	public function changeActivityLogSetting(
		$disablesOrEnables, $streamOrMail, $activityType, $session
	) {
		$streamOrMailNumber = $streamOrMail === "stream" ? 1 : 2;
		$checkboxFullXpath = \sprintf(
			$this->activityCheckboxXpath, $activityType, $streamOrMailNumber
		);
		$checkCheckboxFullId = \sprintf(
			$this->activityCheckboxId, $activityType . "_" . $streamOrMail
		);
		$checkCheckbox = $this->find("xpath", $checkCheckboxFullId);
		$activityCheckbox = $this->find("xpath", $checkboxFullXpath);
		$this->assertElementNotNull(
			$activityCheckbox,
			__METHOD__ . " xpath $checkboxFullXpath " .
			" cannot find label for $streamOrMail checkbox" .
			"for $activityType activity"
		);
		$this->assertElementNotNull(
			$checkCheckbox,
			__METHOD__ .
			" id $checkCheckboxFullId " .
			"could not find checkbox"
		);
		if ($disablesOrEnables === 'enables') {
			if (!$checkCheckbox->isChecked()) {
				$activityCheckbox->click();
			}
		} elseif ($disablesOrEnables === 'disables') {
			if ($checkCheckbox->isChecked()) {
				$activityCheckbox->click();
			}
		} else {
			throw new \Exception(
				__METHOD__ . " invalid action: $disablesOrEnables"
			);
		}
		$this->waitForAjaxCallsToStartAndFinish($session);
	}
}
