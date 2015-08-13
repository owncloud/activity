/*
 * Copyright (c) 2015
 *
 * This file is licensed under the Affero General Public License version 3
 * or later.
 *
 * See the COPYING-README file.
 *
 */

(function() {
	var TEMPLATE =
		'<div>' +
		'{{#if loading}}' +
		'<div class="loading" style="height: 50px"></div>' +
		'{{end}}' +
		'{{else}}' +
		'<ul>' +
		'{{#each activities}}' +
		'    <li>' +
		'        <div class="subject">{{subject}}</div>' +
		'        <div class="message">{{message}}</div>' +
		'        <div class="user">{{user}}</div>' +
		'        <div class="timestamp">{{formattedTime}}</div>' +
	    '    </li>' +
		'{{/each}}' +
		'</ul>' +
		'{{/if}}' +
		'</div>';

	/**
	 * Format an activity model for display
	 *
	 * @param {OCA.Activity.ActivityModel} activity
	 * @return {Object}
	 */
	function formatActivity(activity) {
		return {
			subject: activity.get('subject'),
			message: activity.get('message'),
			user: activity.get('user'),
			formattedTime: OC.Util.formatDate(activity.get('timestamp'))
		};
	}

	/**
	 * @class OCA.Activity.ActivityTabView
	 * @classdesc
	 *
	 * Displays activity information for a given file
	 *
	 */
	var ActivityTabView = OC.Backbone.View.extend(
		/** @lends OCA.Activity.ActivityTabView.prototype */ {
		id: 'activityTabView',
		className: 'activityTabView tab',

		_loading: false,

		/**
		 * @type {OCA.Activity.ActivityCollection}
		 */
		_activities: null,

		initialize: function() {
			this._activities = new OCA.Activity.ActivityCollection();
			this._activities.on('request', this._onRequest, this);
			this._activities.on('reset', this._onChange, this);
		},

		template: function(data) {
			if (!this._template) {
				this._template = Handlebars.compile(TEMPLATE);
			}
			return this._template(data);
		},

		get$: function() {
			return this.$el;
		},

		getLabel: function() {
			return t('activity', 'Activities');
		},

		setFileInfo: function(fileInfo) {
			var self = this;
			this._fileInfo = fileInfo;
			if (this._fileInfo) {
				self._loading = true;
				this._activities.fetch();
			} else {
				this._activities.reset();
			}
			this.render();
		},

		_onRequest: function() {
			this._loading = true;
			this.render();
		},

		_onChange: function() {
			this._loading = false;
			this.render();
		},

		/**
		 * Renders this details view
		 */
		render: function() {
			if (this._fileInfo) {
				this.$el.html(this.template({
					loading: this._loading,
					activities: this._activities.map(formatActivity)
				}));
			} else {
				// TODO: render placeholder text?
			}
		}
	});

	OCA.Activity = OCA.Activity || {};
	OCA.Activity.ActivityTabView = ActivityTabView;
})();

