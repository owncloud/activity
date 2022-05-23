<?php
if (!\defined('PHPUNIT_RUN')) {
	\define('PHPUNIT_RUN', 1);
}

require_once __DIR__ . '/../../../../lib/base.php';

// especially with code coverage it will require some more time
\set_time_limit(0);

\OC::$composerAutoloader->addPsr4('Test\\', OC::$SERVERROOT . '/tests/lib/', true);
\OC::$composerAutoloader->addPsr4('TestHelpers\\', OC::$SERVERROOT . '/tests/TestHelpers/', true);
// load activity unit test classes
\OC::$composerAutoloader->addPsr4('OCA\\Activity\\Tests\\Unit\\', __DIR__, true);
