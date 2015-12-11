<?php

/**
 * ownCloud
 *
 * @author Joas Schilling
 * @copyright 2015 Joas Schilling nickvergessen@owncloud.com
 *
 * This file is licensed under the Affero General Public License version 3 or
 * later.
 * See the COPYING-README file.
 */

namespace OCA\Activity\Tests\Controller;

use OCA\Activity\Controller\OCSEndPoint;
use OCA\Activity\Tests\TestCase;

/**
 * Class OCSEndPointTest
 *
 * @group DB
 * @package OCA\Activity\Tests\Controller
 */
class OCSEndPointTest extends TestCase {
	/** @var \OCP\IRequest|\PHPUnit_Framework_MockObject_MockObject */
	protected $request;

	/** @var \OCA\Activity\Data|\PHPUnit_Framework_MockObject_MockObject */
	protected $data;

	/** @var \OCA\Activity\GroupHelper|\PHPUnit_Framework_MockObject_MockObject */
	protected $helper;

	/** @var \OCA\Activity\UserSettings|\PHPUnit_Framework_MockObject_MockObject */
	protected $userSettings;

	/** @var \OCP\IPreview|\PHPUnit_Framework_MockObject_MockObject */
	protected $preview;

	/** @var \OCP\IURLGenerator|\PHPUnit_Framework_MockObject_MockObject */
	protected $urlGenerator;

	/** @var \OCP\IUserSession|\PHPUnit_Framework_MockObject_MockObject */
	protected $userSession;

	/** @var \OCP\Files\IMimeTypeDetector|\PHPUnit_Framework_MockObject_MockObject */
	protected $mimeTypeDetector;

	/** @var \OC\Files\View|\PHPUnit_Framework_MockObject_MockObject */
	protected $view;

	/** @var \OCA\Activity\ViewInfoCache|\PHPUnit_Framework_MockObject_MockObject */
	protected $infoCache;

	/** @var \OCP\IAvatarManager|\PHPUnit_Framework_MockObject_MockObject */
	protected $avatarManager;

	/** @var \OCP\IL10N */
	protected $l10n;

	/** @var OCSEndPoint */
	protected $controller;

	protected function setUp() {
		parent::setUp();

		$this->data = $this->getMockBuilder('OCA\Activity\Data')
			->disableOriginalConstructor()
			->getMock();
		$this->helper = $this->getMockBuilder('OCA\Activity\GroupHelper')
			->disableOriginalConstructor()
			->getMock();
		$this->userSettings = $this->getMockBuilder('OCA\Activity\UserSettings')
			->disableOriginalConstructor()
			->getMock();
		$this->preview = $this->getMockBuilder('OCP\IPreview')
			->disableOriginalConstructor()
			->getMock();
		$this->urlGenerator = $this->getMockBuilder('OCP\IURLGenerator')
			->disableOriginalConstructor()
			->getMock();
		$this->userSession = $this->getMockBuilder('OCP\IUserSession')
			->disableOriginalConstructor()
			->getMock();
		$this->mimeTypeDetector = $this->getMockBuilder('OCP\Files\IMimeTypeDetector')
			->disableOriginalConstructor()
			->getMock();
		$this->view = $this->getMockBuilder('OC\Files\View')
			->disableOriginalConstructor()
			->getMock();
		$this->infoCache = $this->getMockBuilder('OCA\Activity\ViewInfoCache')
			->disableOriginalConstructor()
			->getMock();
		$this->avatarManager = $this->getMockBuilder('OCP\IAvatarManager')
			->disableOriginalConstructor()
			->getMock();

		$this->request = $this->getMock('OCP\IRequest');

		$this->controller = $this->getController();

		$this->overwriteService('AvatarManager', $this->avatarManager);
	}

	public function tearDown() {

		$this->restoreService('AvatarManager');
		parent::tearDown();
	}

	protected function getController(array $methods = []) {
		if (empty($methods)) {
			return new OCSEndPoint(
				$this->data,
				$this->helper,
				$this->userSettings,
				$this->request,
				$this->urlGenerator,
				$this->userSession,
				$this->preview,
				$this->mimeTypeDetector,
				$this->view,
				$this->infoCache
			);
		} else {
			return $this->getMockBuilder('OCA\Activity\Controller\OCSEndPoint')
				->setConstructorArgs([
					$this->data,
					$this->helper,
					$this->userSettings,
					$this->request,
					$this->urlGenerator,
					$this->userSession,
					$this->preview,
					$this->mimeTypeDetector,
					$this->view,
					$this->infoCache,
				])
				->setMethods($methods)
				->getMock();
		}
	}

	public function dataGetPreviewInvalidPaths() {
		return [
			['author', 42, '/path', null, null],
			['author', 42, '/path', '', null],
			['author', 42, '/path', '/currentPath', false],
		];
	}

	/**
	 * @dataProvider dataGetPreviewInvalidPaths
	 *
	 * @param string $author
	 * @param int $fileId
	 * @param string $path
	 * @param string $returnedPath
	 * @param null|bool $exists
	 */
	public function testGetPreviewInvalidPaths($author, $fileId, $path, $returnedPath, $exists) {
		$this->infoCache->expects($this->once())
			->method('getInfoById')
			->with($author, $fileId, $path)
			->willReturn([
				'path'		=> $returnedPath,
				'exists'	=> $exists,
				'is_dir'	=> false,
				'view'		=> '',
			]);

		$controller = $this->getController([
			'getPreviewFromPath'
		]);
		$controller->expects($this->any())
			->method('getPreviewFromPath')
			->with($path)
			->willReturn(['getPreviewFromPath']);

		$this->assertSame(['getPreviewFromPath'], $this->invokePrivate($controller, 'getPreview', [$author, $fileId, $path]));
	}

	public function dataGetPreview() {
		return [
			['author', 42, '/path', '/currentPath', true, false, '/preview/dir', true],
			['author', 42, '/file.txt', '/currentFile.txt', false, false, '/preview/mpeg', true],
			['author', 42, '/file.txt', '/currentFile.txt', false, true, '/preview/currentFile.txt', false],
		];
	}

	/**
	 * @dataProvider dataGetPreview
	 *
	 * @param string $author
	 * @param int $fileId
	 * @param string $path
	 * @param string $returnedPath
	 * @param bool $isDir
	 * @param bool $isMimeSup
	 * @param string $source
	 * @param bool $isMimeTypeIcon
	 */
	public function testGetPreview($author, $fileId, $path, $returnedPath, $isDir, $isMimeSup, $source, $isMimeTypeIcon) {

		$controller = $this->getController([
			'getPreviewLink',
			'getPreviewPathFromMimeType',
		]);

		$this->infoCache->expects($this->once())
			->method('getInfoById')
			->with($author, $fileId, $path)
			->willReturn([
				'path'		=> $returnedPath,
				'exists'	=> true,
				'is_dir'	=> $isDir,
				'view'		=> '',
			]);

		$controller->expects($this->once())
			->method('getPreviewLink')
			->with($returnedPath, $isDir)
			->willReturnCallback(function($path) {
				return '/preview' . $path;
			});

		if ($isDir) {
			$controller->expects($this->once())
				->method('getPreviewPathFromMimeType')
				->with('dir')
				->willReturn('/preview/dir');
		} else {
			$fileInfo = $this->getMockBuilder('OCP\Files\FileInfo')
				->disableOriginalConstructor()
				->getMock();

			$this->view->expects($this->once())
				->method('chroot')
				->with('/' . $author . '/files');
			$this->view->expects($this->once())
				->method('getFileInfo')
				->with($returnedPath)
				->willReturn($fileInfo);

			$this->preview->expects($this->once())
				->method('isAvailable')
				->with($fileInfo)
				->willReturn($isMimeSup);

			if (!$isMimeSup) {
				$fileInfo->expects($this->once())
					->method('getMimetype')
					->willReturn('audio/mp3');

				$controller->expects($this->once())
					->method('getPreviewPathFromMimeType')
					->with('audio/mp3')
					->willReturn('/preview/mpeg');
			} else {
				$this->urlGenerator->expects($this->once())
					->method('linkToRoute')
					->with('core_ajax_preview', $this->anything())
					->willReturnCallback(function() use ($returnedPath) {
						return '/preview' . $returnedPath;
					});
			}
		}

		$this->assertSame([
			'link' => '/preview' . $returnedPath,
			'source' => $source,
			'isMimeTypeIcon' => $isMimeTypeIcon,
		], $this->invokePrivate($controller, 'getPreview', [$author, $fileId, $path]));
	}

	public function dataGetPreviewFromPath() {
		return [
			['dir', 'dir', '/core/img/filetypes/folder.svg'],
			['test.txt', 'text/plain', '/core/img/filetypes/text.svg'],
			['test.mp3', 'audio/mpeg', '/core/img/filetypes/audio.svg'],
		];
	}

	/**
	 * @dataProvider dataGetPreviewFromPath
	 * @param string $filePath
	 * @param string $mimeType
	 */
	public function testGetPreviewFromPath($filePath, $mimeType) {
		$controller = $this->getController([
			'getPreviewPathFromMimeType',
			'getPreviewLink',
		]);

		$controller->expects($this->once())
			->method('getPreviewPathFromMimeType')
			->with($mimeType)
			->willReturn('mime-type-icon');
		$controller->expects($this->once())
			->method('getPreviewLink')
			->with($filePath, false)
			->willReturn('target-link');
		$this->mimeTypeDetector->expects($this->once())
			->method('detectPath')
			->willReturn($mimeType);

		$this->assertSame(
			[
				'link' => 'target-link',
				'source' => 'mime-type-icon',
				'isMimeTypeIcon' => true,
			],
			$this->invokePrivate($controller, 'getPreviewFromPath', [$filePath])
		);
	}

	public function dataGetPreviewPathFromMimeType() {
		return [
			['dir', '/core/img/filetypes/folder.png', '/core/img/filetypes/folder.svg'],
			['text/plain', '/core/img/filetypes/text.svg', '/core/img/filetypes/text.svg'],
			['text/plain', '/core/img/filetypes/text.jpg', '/core/img/filetypes/text.jpg'],
		];
	}

	/**
	 * @dataProvider dataGetPreviewPathFromMimeType
	 * @param string $mimeType
	 * @param string $icon
	 * @param string $expected
	 */
	public function testGetPreviewPathFromMimeType($mimeType, $icon, $expected) {
		$this->mimeTypeDetector->expects($this->once())
			->method('mimeTypeIcon')
			->with($mimeType)
			->willReturn($icon);

		$this->assertSame(
			$expected,
			$this->invokePrivate($this->controller, 'getPreviewPathFromMimeType', [$mimeType])
		);
	}

	public function dataGetPreviewLink() {
		return [
			['/folder', true, ['dir' => '/folder']],
			['/folder/sub1', true, ['dir' => '/folder/sub1']],
			['/folder/sub1/sub2', true, ['dir' => '/folder/sub1/sub2']],
			['/file.txt', false, ['dir' => '/', 'scrollto' => 'file.txt']],
			['/folder/file.txt', false, ['dir' => '/folder', 'scrollto' => 'file.txt']],
			['/folder/sub1/file.txt', false, ['dir' => '/folder/sub1', 'scrollto' => 'file.txt']],
		];
	}

	/**
	 * @dataProvider dataGetPreviewLink
	 *
	 * @param string $path
	 * @param bool $isDir
	 * @param array $expected
	 */
	public function testGetPreviewLink($path, $isDir, $expected) {
		$this->urlGenerator->expects($this->once())
			->method('linkTo')
			->with('files', 'index.php', $expected);

		$this->invokePrivate($this->controller, 'getPreviewLink', [$path, $isDir]);
	}
}