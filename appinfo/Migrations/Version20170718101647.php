<?php
namespace OCA\activity\Migrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\DBAL\Types\Type;
use OCP\Migration\ISchemaMigration;

/**
 * Moves activity id to bigint
 */
class Version20170718101647 implements ISchemaMigration {

	public function changeSchema(Schema $schema, array $options) {
		$prefix = $options['tablePrefix'];
		if ($schema->hasTable("${prefix}activity")) {
			$table = $schema->getTable("{$prefix}activity");
			$idColumn = $table->getColumn('activity_id');
			if ($idColumn){
				$idColumn->setType(Type::getType(Type::BIGINT));
				$idColumn->setOptions(['length' => 20]);
			}

		}
    }
}
