<?php

/**
 * ownCloud - Activity App
 *
 * @author Joas Schilling
 * @copyright 2014 Joas Schilling nickvergessen@owncloud.com
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU AFFERO GENERAL PUBLIC LICENSE for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace OCA\Activity\Parameter;

use OCA\Activity\Formatter\IFormatter;
use OCP\Activity\IEvent;
use OCP\Util;

class Parameter implements IParameter {
	/** @var IFormatter */
	protected $formatter;

	/** @var mixed */
	protected $parameter;

	/** @var IEvent */
	protected $event;

	/** @var string */
	protected $type;

	/**
	 * @param mixed $parameter
	 * @param IEvent $event
	 * @param IFormatter $formatter
	 * @param string $type
	 */
	public function __construct($parameter,
								IEvent $event,
								IFormatter $formatter,
								$type) {
		$this->parameter = $parameter;
		$this->event = $event;
		$this->formatter = $formatter;
		$this->type = $type;
	}

	/**
	 * @return mixed
	 */
	public function getParameter() {
		if ($this->event->getObjectType() && $this->event->getObjectId()) {
			return $this->event->getObjectType() . '#' . $this->event->getObjectId();
		}

		return $this->parameter;
	}

	/**
	 * @return array With two entries: value and type
	 */
	public function getParameterInfo() {
		return [
			'value' => $this->parameter,
			'type' => $this->type,
		];
	}

	/**
	 * @return string The formatted parameter
	 */
	public function format() {
		return $this->formatter->format($this->event, $this->parameter);
	}
}
