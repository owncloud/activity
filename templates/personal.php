<?php
/* Copyright (c) 2014, Joas Schilling nickvergessen@owncloud.com
 * This file is licensed under the Affero General Public License version 3
 * or later. See the COPYING-README file. */

/** @var $l OC_L10N */
/** @var $_ array */
?>

<form id="activity_notifications" class="section">
	<h2><?php p($l->t('Notifications')); ?></h2>
	<table class="grid activitysettings">
		<thead>
			<tr>
				<th class="small activity_select_group" data-select-group="email">
					<?php p($l->t('Mail')); ?>
				</th>
				<th class="small activity_select_group" data-select-group="stream">
					<?php p($l->t('Stream')); ?>
				</th>
				<th><span id="activity_notifications_msg" class="msg"></span></th>
			</tr>
		</thead>
		<tbody>
		<?php foreach ($_['activities'] as $activity => $data): ?>
			<tr>
				<td class="small">
					<label for="<?php p($activity) ?>_email">
						<input type="checkbox" id="<?php p($activity) ?>_email" name="<?php p($activity) ?>_email"
							value="1" class="<?php p($activity) ?> email" <?php if ($data['email']): ?> checked="checked"<?php endif; ?> />
					</label>
				</td>
				<td class="small">
					<label for="<?php p($activity) ?>_stream">
						<input type="checkbox" id="<?php p($activity) ?>_stream" name="<?php p($activity) ?>_stream"
							value="1" class="<?php p($activity) ?> stream" <?php if ($data['stream']): ?> checked="checked"<?php endif; ?> />
					</label>
				</td>
				<td class="activity_select_group" data-select-group="<?php p($activity) ?>">
					<?php echo $data['desc']; ?>
				</td>
			</tr>
		<?php endforeach; ?>
		</tbody>
	</table>

	<br />
	<input id="notify_setting_self" name="notify_setting_self" type="checkbox"
		value="1" <?php if ($_['notify_self']): ?> checked="checked"<?php endif; ?> />
	<label for="notify_setting_self"><?php p($l->t('List your own actions in the stream')); ?></label>
	<br />
	<input id="notify_setting_selfemail" name="notify_setting_selfemail" type="checkbox"
		value="1" <?php if ($_['notify_selfemail']): ?> checked="checked"<?php endif; ?> />
	<label for="notify_setting_selfemail"><?php p($l->t('Notify about your own actions via email')); ?></label>
	<br />

	<?php if (empty($_['activity_email'])): ?>
		<br />
		<strong><?php p($l->t('You need to set up your email address before you can receive notification emails.')); ?></strong>
	<?php endif; ?>

	<br />
	<?php p($l->t('Send emails:')); ?>
	<select id="notify_setting_batchtime" name="notify_setting_batchtime">
		<option value="0"<?php if ($_['setting_batchtime'] === \OCA\Activity\UserSettings::EMAIL_SEND_HOURLY): ?> selected="selected"<?php endif; ?>><?php p($l->t('Hourly')); ?></option>
		<option value="1"<?php if ($_['setting_batchtime'] === \OCA\Activity\UserSettings::EMAIL_SEND_DAILY): ?> selected="selected"<?php endif; ?>><?php p($l->t('Daily')); ?></option>
		<option value="2"<?php if ($_['setting_batchtime'] === \OCA\Activity\UserSettings::EMAIL_SEND_WEEKLY): ?> selected="selected"<?php endif; ?>><?php p($l->t('Weekly')); ?></option>
	</select>
</form>
