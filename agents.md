# AI Agent Guidelines for Activity

This file provides context for AI coding agents (Claude Code, GitHub Copilot, Cursor, etc.) working in this repository.

## Repository Overview
- **Product family:** Classic (OC10)
- **Primary language(s):** PHP, JavaScript
- **Build system:** Composer, Make, npm/Yarn
- **Test framework:** PHPUnit, JavaScript tests
- **CI system:** GitHub Actions

## Architecture & Key Paths
- `lib/` - PHP application logic
- `appinfo/` - ownCloud app metadata and registration
- `templates/` - Server-side templates
- `js/` - Frontend JavaScript
- `css/` - Stylesheets
- `l10n/` - Translations
- `tests/` - PHPUnit tests
- `docs/` - Documentation and screenshots
- `img/` - App icons and images
- `Makefile` - Build and test automation
- `composer.json` - PHP dependencies
- `package.json` - JavaScript dependencies
- `phpcs.xml` - PHP_CodeSniffer configuration
- `phpstan.neon` - PHPStan static analysis configuration
- `phpunit.xml` - PHPUnit configuration

## Development Conventions
- **Branching:** master
- **Commit messages:** DCO sign-off required (`git commit -s`)
- **Code style:** PHP_CodeSniffer (phpcs.xml), ownCloud coding standard
- **PR process:** Open a PR against master. All CI checks must pass.

## Build & Test Commands
```bash
# Build
make

# Test (PHP)
make test-php-unit

# Test (JavaScript)
make test-js

# Lint
make test-php-style

# Fix code style
make test-php-style-fix

# Static analysis
make test-php-phpstan
```

## Important Constraints
- All code contributions must be compatible with the project's license
- Do not introduce new **copyleft-licensed dependencies** (GPL, AGPL, LGPL, MPL) without explicit discussion in an issue first. This is especially important for repos migrating to Apache 2.0.
- Do not introduce new dependencies without discussion in an issue first
- This app requires ownCloud Server (Classic) to run


## OSPO Policy Constraints

### GitHub Actions
- **Only** use actions owned by `owncloud`, created by GitHub (`actions/*`), verified on the GitHub Marketplace, or verified by the ownCloud Maintainers.
- Pin all actions to their full commit SHA (not tags): `uses: actions/checkout@<SHA> # vX.Y.Z`
- Never introduce actions from unverified third parties.

### Dependency Management
- Dependabot is configured for automated dependency updates.
- Review and merge Dependabot PRs as part of regular maintenance.
- Do not introduce new dependencies without discussion in an issue first.

### Git Workflow
- **Rebase policy**: Always rebase; never create merge commits. Use `git pull --rebase` and `git rebase` before pushing.
- **Signed commits**: All commits **must** be PGP/GPG signed (`git commit -S -s`).
- **DCO sign-off**: Every commit needs a `Signed-off-by` line (`git commit -s`).
- **Conventional Commits & Squash Merge**: Use the [Conventional Commits](https://www.conventionalcommits.org/) format where the repository enforces it. Many repos use squash merge, where the PR title becomes the commit message on the default branch — apply Conventional Commits format to PR titles as well. A reusable GitHub Actions workflow enforces this.

## Context for AI Agents
- Match existing code style
- Do not refactor unrelated code in the same PR
- Write tests for new functionality
- Keep PRs focused and atomic
- The app uses the ownCloud `\OCP\Activity\IExtension` interface for extensibility
