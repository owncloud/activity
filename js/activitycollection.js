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
	/**
	 * @class OCA.Activity.ActivityCollection
	 * @classdesc
	 *
	 * Displays activity information for a given file
	 *
	 */
	var ActivityCollection = OC.Backbone.Collection.extend(
		/** @lends OCA.Activity.ActivityCollection.prototype */ {

		/**
		 * Id of the file for which to filter activities by
		 *
		 * @var int
		 */
		_fileId: undefined,

		model: OCA.Activity.ActivityModel,

		initialize: function(options) {
			if (options && options.fileId) {
				this._fileId = options.fileId;
			}
		},

		/**
		 * Sets the file id to filter by or null for all.
		 * 
		 * @param {int} fileId file id or null
		 */
		setFileId: function(fileId) {
			this._fileId = fileId;
		},

		url: function() {
			var query = {
				page: 1,
				filter: 'all'
			};
			var url = OC.generateUrl('apps/activity/activities/fetch');
			if (!_.isUndefined(this._fileId)) {
				query.fileid = this._fileId;
			}
			url += '?' + OC.buildQueryString(query);
			return url;
		},

		fetch: function() {
			var self = this;
			// FIXME: TEMP for testing the view, remove this method
			// once the backend is ready
			_.delay(function() {
				self.reset([
					{
						id: 1,
						subject: 'Test subject',
						message: 'Test message',
						file: 'test.txt',
						link: OC.generateUrl('apps/files'),
						user: OC.currentUser,
						affectedUsers: [OC.currentUser],
						timestamp: new Date(Date.UTC(2015, 8, 12, 10, 11, 12))
					}
				]);
			}, 1000);
		}
	});

	OCA.Activity = OCA.Activity || {};
	OCA.Activity.ActivityCollection = ActivityCollection;
})();

