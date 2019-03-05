doc_files=README.md CHANGELOG.md CONTRIBUTING.md

include ../../build/rules/help.mk
include ../../build/rules/check-npm.mk
include ../../build/rules/dist.mk
include ../../build/rules/test-acceptance.mk
include ../../build/rules/test-js.mk
include ../../build/rules/test-php.mk
include ../../build/rules/clean.mk

all: build

# Fetches the PHP and JS dependencies and compiles the JS. If no composer.json
# is present, the composer step is skipped, if no package.json or js/package.json
# is present, the npm step is skipped
.PHONY: build
build:
ifneq (,$(wildcard $(CURDIR)/composer.json))
	make composer
endif
ifneq (,$(wildcard $(CURDIR)/package.json))
	make npm
endif
ifneq (,$(wildcard $(CURDIR)/js/package.json))
	make npm
endif

# Installs and updates the composer dependencies.
.PHONY: composer
composer:
	composer install --prefer-dist
	composer update --prefer-dist

# Installs npm dependencies
.PHONY: npm
npm:
ifeq (,$(wildcard $(CURDIR)/package.json))
	cd js && $(npm) run build
else
	npm run build
endif
