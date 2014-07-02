# ownCloud Activity App

The activity app for ownCloud

Provides an activity feed showing your file changes and other interesting things
going on in your ownCloud.

[![Build Status](https://travis-ci.org/owncloud/activity.svg?branch=master)](https://travis-ci.org/owncloud/activity)

[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/owncloud/activity/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=master)

[![Code Coverage](https://scrutinizer-ci.com/g/owncloud/activity/badges/coverage.png?b=master)](https://scrutinizer-ci.com/g/owncloud/activity/?branch=master)

# Add new activities / types for other apps

## Adding a new activity type

In order to add a new activity type (and personal setting), you need to add
a new entry to the types array via the `OC_Activity/notification_types` hook.

If you want to enable the new type by default, you need to add the type to the
settings array via the `OC_Activity/default_types` hook aswell.

## Adding a new filter

To add a new filter to the sidebar, you need to add an entry to the
`OC_Activity/get_navigation` event. In order for the filter to actually filter
the activites, you also need to modify the types array in `OC_Activity/filter_types`.

If your filter is more complicated and does not only depend on the type,
`OC_Activity/get_filter` can be used to further modify the query.

*Note:* This hook is not called for predefined filters.
