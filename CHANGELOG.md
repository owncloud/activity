# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [2.4.1] - 2018-11-30

- Set max version to 10 because core platform switches to Semver

## [2.4.0] - 2018-11-13

### Fixed

- Add missing migrations for longtext and indices - [#654](https://github.com/owncloud/activity/issues/654)

## [2.3.8] - 2018-09-25
### Added

- New mail footers to template files. - [#639](https://github.com/owncloud/activity/issues/639)

### Fixed

- Prepare for jquery 2 update - [#638](https://github.com/owncloud/activity/issues/638)

## [2.3.7] - 2018-07-11

### Fixed

- Adjust preview URL generation based on new endpiont - [#631](https://github.com/owncloud/activity/pull/631)
- Fix grouping for share messages - [#626](https://github.com/owncloud/activity/issues/626)
- Add missing HTML template to activity email notification - [#620](https://github.com/owncloud/activity/issues/620)
- Don't try to delete items when no users in context - [#604](https://github.com/owncloud/activity/issues/604)
- Chunk deleting of rows from the activity table for cluster environments - [#610](https://github.com/owncloud/activity/issues/610)
- Fix for when avatars are disabled - [#600](https://github.com/owncloud/activity/issues/600)

## [2.3.6]

### Fixed

- Don't package vendor folder - [#588](https://github.com/owncloud/activity/issues/588)
- Migrate to bigint - [#584](https://github.com/owncloud/activity/issues/584)
- Show displayName instead of group id - [#582](https://github.com/owncloud/activity/issues/582)
- Catch mail exceptions and still remove sent emails from queue - [#574](https://github.com/owncloud/activity/issues/574)

[Unreleased]: https://github.com/owncloud/activity/compare/v2.4.1...master
[2.4.1]: https://github.com/owncloud/activity/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/owncloud/activity/compare/v2.3.8...v2.4.0
[2.3.8]: https://github.com/owncloud/activity/compare/v2.3.7...v2.3.8
[2.3.7]: https://github.com/owncloud/activity/compare/v2.3.6...v2.3.7
[2.3.6]: https://github.com/owncloud/activity/compare/v10.0.2...v2.3.6

