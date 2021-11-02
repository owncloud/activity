/*
 * Copyright (c) 2015
 *
 * This file is licensed under the Affero General Public License version 3
 * or later.
 *
 * See the COPYING-README file.
 *
 */
$(function(){
	OCA.Activity = OCA.Activity || {};

	OCA.Activity.Filter = {
		filter: undefined,
		$navigation: $('#app-navigation'),


		_onPopState: function(params) {
			params = _.extend({
				filter: 'all'
			}, params);

			this.setFilter(params.filter);
		},

		setFilter: function (filter) {
			if (filter === this.filter) {
				return;
			}

			this.$navigation.find('a[data-navigation=' + this.filter + ']').parent().removeClass('active');
			OCA.Activity.InfinitScrolling.firstKnownId = 0;
			OCA.Activity.InfinitScrolling.lastGivenId = 0;

			this.filter = filter;

			OCA.Activity.InfinitScrolling.$container.animate({ scrollTop: 0 }, 'slow');
			OCA.Activity.InfinitScrolling.$container.children().remove();
			$('#emptycontent').addClass('hidden');
			$('#no_more_activities').addClass('hidden');
			$('#loading_activities').removeClass('hidden');
			OCA.Activity.InfinitScrolling.ignoreScroll = 0;

			this.$navigation.find('a[data-navigation=' + filter + ']').parent().addClass('active');

			OCA.Activity.InfinitScrolling.prefill();
		}
	};

	OCA.Activity.InfinitScrolling = {
		ignoreScroll: 0,
		$container: $('#container'),
		lastDateGroup: null,
		$content: $('#app-content'),
		firstKnownId: 0,
		lastGivenId: 0,
		activities: {},

		prefill: function () {
			this.ignoreScroll += 1;
			if (this.$content.scrollTop() + this.$content.height() > this.$container.height() - 100) {
				this.ignoreScroll += 1;
				this.loadMoreActivities();
			}
			this.ignoreScroll -= 1;
		},

		onScroll: function () {
			if (this.ignoreScroll <= 0 && this.$content.scrollTop() +
				this.$content.height() > this.$container.height() - 100) {
				this.ignoreScroll = 1;
				this.loadMoreActivities();
			}
		},

		/**
		 * Request a new bunch of activities from the server
		 */
		loadMoreActivities: function () {
			var self = this;

			$.ajax({
				//url: OC.linkToOCS('apps/activity/api/v2/activity', 2) + OCA.Activity.Filter.filter + '?format=json&previews=true&since=' + self.lastGivenId,
				url: OC.generateUrl('/apps/activity/api/v2/activity') + '/' + OCA.Activity.Filter.filter + '?format=json&previews=true&since=' + self.lastGivenId,
				type: 'GET',
				beforeSend: function(xhr) {
					xhr.setRequestHeader("Accept-Language", OC.getLocale());
				},
				success: function(response, status, xhr) {
					if (status === 'notmodified') {
						self.handleActivitiesCallback([]);
						self.saveHeaders(xhr.getAllResponseHeaders());
						return;
					}

					self.saveHeaders(xhr.getAllResponseHeaders());
					if (typeof response != 'undefined') {
						self.handleActivitiesCallback(response.ocs.data);
						self.ignoreScroll -= 1;
					}
				}
			});
		},

		/**
		 * Read the X-Activity-First-Known and X-Activity-Last-Given headers
		 * @param headers
		 */
		saveHeaders: function(headers) {
			var self = this;

			headers = headers.split("\n");
			_.each(headers, function (header) {
				var parts = header.split(':');
				if (parts[0].toLowerCase() === 'x-activity-first-known') {
					self.firstKnownId = parseInt(parts[1].trim(), 10);
				} else if (parts[0].toLowerCase() === 'x-activity-last-given') {
					self.lastGivenId = parseInt(parts[1].trim(), 10);
				}
			});
		},

		/**
		 * Append activities to the view or display end/no content
		 * @param data
		 */
		handleActivitiesCallback: function (data) {
			var numActivities = data.length;

			if (numActivities > 0) {
				for (var i = 0; i < data.length; i++) {
					var activity = data[i];
					this.appendActivityToContainer(activity);
				}

				// Continue prefill
				this.prefill();

			} else if (this.$container.children().length === 0) {
				// First page is empty - No activities :(
				var $emptyContent = $('#emptycontent');
				$emptyContent.removeClass('hidden');
				if (OCA.Activity.Filter.filter == 'all') {
					$emptyContent.find('p').text(t('activity', 'This stream will show events like additions, changes & shares'));
				} else {
					$emptyContent.find('p').text(t('activity', 'There are no events for this filter'));
				}
				$('#loading_activities').addClass('hidden');
				this.ignoreScroll = 1;

			} else {
				// Page is empty - No more activities :(
				$('#no_more_activities').removeClass('hidden');
				$('#loading_activities').addClass('hidden');
				this.ignoreScroll = 1;
			}
		},

		appendActivityToContainer: function (activity) {
			activity.timestamp = moment(activity.datetime).valueOf();
			this.makeSureDateGroupExists(activity.timestamp);

			this.activities[activity.activity_id] = activity;
			this.addActivity(activity);
		},

		makeSureDateGroupExists: function(timestamp) {
			var dayOfYear = OC.Util.formatDate(timestamp, 'YYYY-DDD');
			var $lastGroup = this.$container.children().last();

			if ($lastGroup.data('date') !== dayOfYear) {
				var dateOfDay = OC.Util.formatDate(timestamp, 'LL'),
					displayDate = dateOfDay;

				var today = OC.Util.formatDate(moment(), 'YYYY-DDD');
				if (dayOfYear === today) {
					displayDate = t('activity', 'Today');
				} else {
					var yesterday = OC.Util.formatDate(moment().subtract(1, 'd'), 'YYYY-DDD');

					if (dayOfYear === yesterday) {
						displayDate = t('activity', 'Yesterday');
					}
				}

				var content = '<div class="section activity-section group" data-date="' + escapeHTML(dayOfYear) + '">' + "\n"
					+'	<h2>'+"\n"
					+'		<span class="has-tooltip" title="' + escapeHTML(dateOfDay) + '">' + escapeHTML(displayDate) + '</span>' + "\n"
					+'	</h2>' + "\n"
					+'	<div class="boxcontainer">' + "\n"
					+'	</div>' + "\n"
					+'</div>';
				var $content = $(content);
				this.processElements($content);
				this.$container.append($content);
				this.lastDateGroup = $content;
			}
		},

		addActivity: function(activity) {
			subject = activity.subject_prepared;
			var displayFullPath = activity.type === 'file_moved';
			var parsedSubject = OCA.Activity.Formatter.parseMessage(subject, false, displayFullPath);

			if (parsedSubject.indexOf('<a') >= 0) {
				activity.link = '';
			}

			var content = ''
				+ '<div class="box" data-activity-id="' + activity.activity_id + '">' + "\n"
				+ '	<div class="messagecontainer">' + "\n"

				+ '		<div class="activity-icon ' + ((activity.typeicon) ? escapeHTML(activity.typeicon) + ' svg' : '') + '"></div>' + "\n"

				+ '		<div class="activitysubject">' + "\n"
				+ ((activity.link) ? '			<a href="' + activity.link + '">' + "\n" : '')
				+ '			' + parsedSubject + "\n"
				+ ((activity.link) ? '			</a>' + "\n" : '')
				+ '		</div>' + "\n"

				+'		<span class="activitytime has-tooltip" title="' + escapeHTML(OC.Util.formatDate(activity.timestamp)) + '">' + "\n"
				+ '			' + escapeHTML(OC.Util.relativeModifiedDate(activity.timestamp)) + "\n"
				+'		</span>' + "\n";

			if (activity.message_prepared) {
				content += '<div class="activitymessage">' + "\n"
					+ OCA.Activity.Formatter.parseMessage(activity.message_prepared) + "\n"
					+'</div>' + "\n";
			}

			if (activity.previews && activity.previews.length) {
				content += '<br />';
				for (var i = 0; i < activity.previews.length; i++) {
					var preview = activity.previews[i];
					content += ((preview.link) ? '<a href="' + preview.link + '">' + "\n" : '')
						+ '<img class="preview' + ((preview.isMimeTypeIcon) ? ' preview-mimetype-icon' : '') + '" src="' + preview.source + '" alt=""/>' + "\n"
						+ ((preview.link) ? '</a>' + "\n" : '')
				}
			}

			content += '	</div>' + "\n"
				+'</div>';

			var $content = $(content);
			this.processElements($content);
			this.lastDateGroup.append($content);
		},

		processElements: function ($element) {
			var self = this;

			$element.find('.avatar').each(function() {
				var element = $(this);
				if (element.data('user-display-name')) {
					element.avatar(element.data('user'), 28, undefined, false, undefined, element.data('user-display-name'));
				} else {
					element.avatar(element.data('user'), 28);
				}
			});

			$element.find('.activity-more-link').on('click', function() {
				var $moreElement = $(this),
					activityId = $moreElement.closest('.box').data('activity-id'),
					$subject = $moreElement.closest('.activitysubject');

				var activity = self.activities[activityId];
				$subject.html(self.parseMessage(activity.subject_prepared, true));
				self.processElements($subject);
			});

			$element.find('.has-tooltip').tooltip({
				placement: 'bottom'
			});
		}
	};

	OCA.Activity.Formatter.setAvatarStatus(OCA.Activity.InfinitScrolling.$container.data('avatars-enabled') === 'yes');
	OC.Util.History.addOnPopStateHandler(_.bind(OCA.Activity.Filter._onPopState, OCA.Activity.Filter));
	OCA.Activity.Filter.setFilter(OCA.Activity.InfinitScrolling.$container.attr('data-activity-filter'));
	OCA.Activity.InfinitScrolling.$content.on('scroll', _.bind(OCA.Activity.InfinitScrolling.onScroll, OCA.Activity.InfinitScrolling));

	OCA.Activity.Filter.$navigation.find('a[data-navigation]').on('click', function (event) {
		var filter = $(this).attr('data-navigation');
		if (filter !== OCA.Activity.Filter.filter) {
			OC.Util.History.pushState({
				filter: filter
			});
		}
		OCA.Activity.Filter.setFilter(filter);
		event.preventDefault();
	});

	$('#enable_rss').change(function () {
		if (this.checked) {
			$('#rssurl').removeClass('hidden');
		} else {
			$('#rssurl').addClass('hidden');
		}
		$.post(OC.generateUrl('/apps/activity/settings/feed'), 'enable=' + this.checked, function(response) {
			$('#rssurl').val(response.data.rsslink);
		});
	});

	$('#rssurl').on('click', function () {
		$('#rssurl').select();
	});
});

