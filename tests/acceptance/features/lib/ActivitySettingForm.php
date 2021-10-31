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
		string $disablesOrEnables,
		string $streamOrMail,
		string $activityType,
		Session $session
	): void {
		$streamOrMailNumber = $streamOrMail === "stream" ? 1 : 2;
		$checkboxFullXpath = \sprintf(
			$this->activityCheckboxXpath,
			$activityType,
			$streamOrMailNumber
		);
		$checkboxId = $activityType . "_" . $streamOrMail;
		$checkCheckboxFullId = \sprintf(
			$this->activityCheckboxId,
			$checkboxId
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
				$this->scrollDownAppContent($checkboxId, $session);
				$activityCheckbox->click();
			}
		} elseif ($disablesOrEnables === 'disables') {
			if ($checkCheckbox->isChecked()) {
				$this->scrollDownAppContent($checkboxId, $session);
				$activityCheckbox->click();
			}
		} else {
			throw new \Exception(
				__METHOD__ . " invalid action: $disablesOrEnables"
			);
		}
		$this->waitForAjaxCallsToStartAndFinish($session);
	}

	/**
	 * scrolls down the content of the general settings page to make the
	 * requested id visible. The div with the scrollbar has id app-content.
	 *
	 * Note: there is a similar function in core acceptance tests FilesPageBasic.php
	 *
	 * @param string $idToScrollIntoView
	 * @param Session $session
	 *
	 * @return void
	 */
	public function scrollDownAppContent(
		string $idToScrollIntoView,
		Session $session
	): void {
		$this->scrollToPosition(
			"#app-content",
			'$("#' . $idToScrollIntoView . '").position().top',
			$session
		);
	}
}
