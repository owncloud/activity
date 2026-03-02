<?php

namespace OCA\activity\Migrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\DBAL\Types\Type;
use Doctrine\DBAL\Types\Types;
use OCP\Migration\ISchemaMigration;

/**
 * Updates column type from integer to bigint
 */

class Version20170724182159 implements ISchemaMigration {
	/**
	 * @param Schema $schema
	 * @param array $options
	 */
	public function changeSchema(Schema $schema, array $options) {
		$prefix = $options['tablePrefix'];
		
		$activityTable = $schema->getTable("{$prefix}activity");
		$activityIdColumn = $activityTable->getColumn('activity_id');
		/* @phan-suppress-next-line PhanDeprecatedFunction */
		if ($activityIdColumn->getType()->getName() !== Types::BIGINT) {
			$activityIdColumn->setType(Type::getType(Types::BIGINT));
			$activityIdColumn->setOptions(['length' => 20]);
		}
		
		$objectIdColumn = $activityTable->getColumn('object_id');
		/* @phan-suppress-next-line PhanDeprecatedFunction */
		if ($objectIdColumn->getType()->getName() !== Types::BIGINT) {
			/* @phan-suppress-next-line PhanDeprecatedFunction */
			$objectIdColumn->setType(Type::getType(Types::BIGINT));
			$objectIdColumn->setOptions(['length' => 20]);
		}
		
		$activityMqTable = $schema->getTable("{$prefix}activity_mq");
		$mailIdColumn = $activityMqTable->getColumn('mail_id');
		/* @phan-suppress-next-line PhanDeprecatedFunction */
		if ($mailIdColumn->getType()->getName() !== Types::BIGINT) {
			/* @phan-suppress-next-line PhanDeprecatedFunction */
			$mailIdColumn->setType(Type::getType(Types::BIGINT));
			$mailIdColumn->setOptions(['length' => 20]);
		}
	}
}
