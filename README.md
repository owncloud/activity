# Activity

<!-- OSPO-managed README | Generated: 2026-04-16 | v2 -->

[![License](https://img.shields.io/badge/License-See%20Repository-blue.svg)](LICENSE) [![ownCloud OSPO](https://img.shields.io/badge/OSPO-ownCloud-blue)](https://kiteworks.com/opensource) [![Docker Hub](https://img.shields.io/docker/pulls/owncloud)](https://hub.docker.com/r/owncloud/server)

The ownCloud Activity app provides users with a comprehensive overview of all file and folder events in their ownCloud instance and supports email notifications for those events. Users can configure which actions appear in the Activity stream (accessible via the app launcher) and which trigger email notifications, with bulk emails sent hourly, daily, or weekly. The app tracks file creation, modification, restoration from trash, sharing, comments, tags, and public share link downloads, with a Favorites filter to reduce noise.

## Part of Classic (OC10)

Activity is a core app for [ownCloud Server (Classic)](https://github.com/owncloud/core). It is installed as part of the standard ownCloud Server deployment and provides the activity stream and notification features in the web interface. The app is available on [Docker Hub as part of the ownCloud Server image](https://hub.docker.com/r/owncloud/server).

## Getting Started

Activity is included by default in ownCloud Server. To install it separately in a development environment:

1. Clone this repository into the `apps/` directory of your ownCloud Server installation
2. Run `make` to build the app
3. Enable the app via the ownCloud admin panel or `occ app:enable activity`

## Documentation

- [ownCloud Server documentation](https://doc.owncloud.com)
- See the `docs/` directory for additional information
- The app provides an extension API via `\OCP\Activity\IExtension` for other apps to add custom activity types

## Community & Support

**[Star](https://github.com/owncloud/activity)** this repo and **Watch** for release notifications!

- [ownCloud Website](https://owncloud.com)
- [Community Discussions](https://github.com/orgs/owncloud/discussions)
- [Matrix Chat](https://app.element.io/#/room/#owncloud:matrix.org)
- [Documentation](https://doc.owncloud.com)
- [Enterprise Support](https://owncloud.com/contact-us/)
- [OSPO Home](https://kiteworks.com/opensource)

## Contributing

We welcome contributions! Please read the [Contributing Guidelines](CONTRIBUTING.md)
and our [Code of Conduct](CODE_OF_CONDUCT.md) before getting started.

### Workflow

- **Rebase Early, Rebase Often!** We use a rebase workflow. Always rebase on the target branch before submitting a PR.
- **Dependabot**: Automated dependency updates are managed via Dependabot. Review and merge dependency PRs promptly.
- **Signed Commits**: All commits **must** be PGP/GPG signed. See [GitHub's signing guide](https://docs.github.com/en/authentication/managing-commit-signature-verification).
- **DCO Sign-off**: Every commit must carry a `Signed-off-by` line:
  ```
  git commit -s -S -m "your commit message"
  ```
- **GitHub Actions Policy**: Workflows may only use actions that are (a) owned by `owncloud`, (b) created by GitHub (`actions/*`), or (c) verified in the GitHub Marketplace.

## Translations

Help translate this project on Transifex:
**<https://explore.transifex.com/owncloud-org/owncloud/>**

Please submit translations via Transifex -- do not open pull requests for translation changes.

## Security

**Do not open a public GitHub issue for security vulnerabilities.**

Report vulnerabilities at **<https://security.owncloud.com>** -- see [SECURITY.md](SECURITY.md).

Bug bounty: [YesWeHack ownCloud Program](https://yeswehack.com/programs/owncloud-bug-bounty-program)

## License

See [LICENSE](LICENSE) for license details.

## About the ownCloud OSPO

The [Kiteworks Open Source Program Office](https://kiteworks.com/opensource), operating under
the [ownCloud](https://owncloud.com) brand, launched on May 5, 2026, to steward the open source
ecosystem around ownCloud's products. The OSPO ensures transparent governance, license compliance,
community health, and sustainable collaboration between the open source community and
[Kiteworks](https://www.kiteworks.com), which acquired ownCloud in 2023.

- **OSPO Home**: <https://kiteworks.com/opensource>
- **GitHub**: <https://github.com/owncloud>
- **ownCloud**: <https://owncloud.com>

For questions about the OSPO or licensing, contact ospo@kiteworks.com.

### License Migration to Apache 2.0

The OSPO is driving a strategic relicensing of ownCloud repositories toward the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0), following
the [Apache Software Foundation's third-party license policy](https://www.apache.org/legal/resolved.html).

Individual repositories will migrate as their audit is completed. The LICENSE file
in each repo reflects its **current** license status (not the target).

**Current license: Not detected.** The OSPO will determine the current license status of this
repository before planning any migration steps. If you know the intended license, please open an
issue or contact ospo@kiteworks.com.
