<?php

// Backends
$authBackend = new OC_Connector_Sabre_Auth();
$requestBackend = new OC_Connector_Sabre_Request();

// Fire up server
$server = new \Sabre\DAV\Server(new \OCA\Activity\Sabre\Collection());
$server->httpRequest = $requestBackend;
$server->setBaseUri($baseuri);

// Load plugins
$defaults = new OC_Defaults();
$server->addPlugin(new \Sabre\DAV\Auth\Plugin($authBackend, $defaults->getName()));
$server->addPlugin(new OC_Connector_Sabre_MaintenancePlugin());
$server->addPlugin(new \Sabre\DAV\Browser\Plugin(false, false)); // Show something in the Browser, but no upload

// And off we go!
$server->exec();
