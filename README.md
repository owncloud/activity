# ownCloud Activity App

The activity app for ownCloud

Provides an activity feed showing your file changes and other interesting things
going on in your ownCloud.

## QA metrics on master branch:

[![Build Status](https://travis-ci.org/owncloud/activity.svg?branch=master)](https://travis-ci.org/owncloud/activity/branches)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/owncloud/activity/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=master)
[![Code Coverage](https://scrutinizer-ci.com/g/owncloud/activity/badges/coverage.png?b=master)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=master)

## QA metrics on stable9.1 branch:

[![Build Status](https://travis-ci.org/owncloud/activity.svg?branch=stable9.1)](https://travis-ci.org/owncloud/activity/branches)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/owncloud/activity/badges/quality-score.png?b=stable9.1)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=stable9.1)
[![Code Coverage](https://scrutinizer-ci.com/g/owncloud/activity/badges/coverage.png?b=stable9.1)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=stable9.1)

## QA metrics on stable9 branch:

[![Build Status](https://travis-ci.org/owncloud/activity.svg?branch=stable9)](https://travis-ci.org/owncloud/activity/branches)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/owncloud/activity/badges/quality-score.png?b=stable9)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=stable9)
[![Code Coverage](https://scrutinizer-ci.com/g/owncloud/activity/badges/coverage.png?b=stable9)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=stable9)

## QA metrics on stable8.2 branch:

[![Build Status](https://travis-ci.org/owncloud/activity.svg?branch=stable8.2)](https://travis-ci.org/owncloud/activity/branches)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/owncloud/activity/badges/quality-score.png?b=stable8.2)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=stable8.2)
[![Code Coverage](https://scrutinizer-ci.com/g/owncloud/activity/badges/coverage.png?b=stable8.2)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=stable8.2)

# Add new activities / types for other apps

With the activity manager extensions can be registered which allow any app to extend the activity behavior.

In order to implement an extension create a class which implements the interface `\OCP\Activity\IExtension`.

The PHPDoc comments on each method should give enough information to the developer on how to implement them.
