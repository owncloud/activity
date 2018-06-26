# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [2.3.7]
### Fixed
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

[Unreleased]: https://github.com/owncloud/activity/compare/v2.3.7...master
[2.3.7]: https://github.com/owncloud/activity/compare/v2.3.6...v2.3.7
[2.3.6]: https://github.com/owncloud/activity/compare/v10.0.2...v2.3.6

