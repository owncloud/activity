<?php
$finder = PhpCsFixer\Finder::create()
	->notPath('templates/html.notification.php')
	->in(__DIR__);

$config = new OC\CodingStandard\Config();
$config->setFinder($finder);
return $config;
