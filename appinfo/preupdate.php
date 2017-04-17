<?php

$installedVersion = \OC::$server->getConfig()
				->getAppValue('activity', 'installed_version');

if (version_compare($installedVersion, '1.1.1', '>=') && version_compare($installedVersion, '1.1.2', '<=')) {
	$connection = \OC::$server->getDatabaseConnection();
	$platform = $connection->getDatabasePlatform();
	if ($platform->getName() === 'oracle') {
		try {
			$connection->beginTransaction();
			$sql1 = 'ALTER TABLE `*PREFIX*activity` ADD `type_text` VARCHAR2(255) DEFAULT NULL';
			$connection->executeQuery($sql1);
			$sql2 = 'UPDATE `*PREFIX*activity` SET `type_text` = to_char(`type`)';
			$connection->executeQuery($sql2);
			$sql3 = 'ALTER TABLE `*PREFIX*activity` DROP COLUMN `type` cascade constraints';
			$connection->executeQuery($sql3);
			$sql4 = 'ALTER TABLE `*PREFIX*activity` RENAME COLUMN `type_text` TO `type`';
			$connection->executeQuery($sql4);
			$connection->commit();
		} catch (\Doctrine\DBAL\DBALException $e) {
			\OC::$server->getLogger()->warning(
				"Oracle upgrade fixup failed: " . $e->getMessage(), 
				['app' => 'activity']
			);
		}
	}
}
