<?php

namespace OCA\Activity\Tests\Unit\Parsers;

use OCA\Activity\HtmlTextParser;
use OCP\IL10N;
use OCP\IURLGenerator;
use Test\TestCase;

class HtmlTextParserTest extends TestCase {
	/**
	 * @dataProvider providesMessages
	 * @param string $expected
	 * @param string $message
	 */
	public function test(string $expected, string $message): void {
		$l = $this->createMock(IL10N::class);
		$g = $this->createMock(IURLGenerator::class);
		$g->method('getAbsoluteURL')->willReturnCallback(static function ($url) {
			return 'https://cloud.example.net' . $url;
		});
		$p = new HtmlTextParser($l, $g);
		$parsed = $p->parseMessage($message);
		self::assertEquals($expected, $parsed);
	}

	public function providesMessages(): array {
		return [
			['You deleted <a href="https://cloud.example.net/index.php/f/123456">bar.txt</a>', 'You deleted <file link="https://cloud.example.net/foo/bar.txt" id="123456">bar.txt</file>']
		];
	}
}
