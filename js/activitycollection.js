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
		_objectId: null,

		/**
		 * Type of the object to filter by
		 *
		 * @var string
		 */
		_objectType: null,

		model: OCA.Activity.ActivityModel,

		initialize: function(options) {
			if (options && options.fileId) {
				this._fileId = options.fileId;
			}
		},

		/**
		 * Sets the object id to filter by or null for all.
		 * 
		 * @param {int} objectId file id or null
		 */
		setObjectId: function(objectId) {
			this._objectId = objectId;
		},

		/**
		 * Sets the object type to filter by or null for all.
		 * 
		 * @param {int} objectType file id or null
		 */
		setObjectType: function(objectType) {
			this._objectType = objectType;
		},

		url: function() {
			var query = {
				page: 1,
				filter: 'all'
			};
			var url = OC.generateUrl('apps/activity/activities/fetch');
			if (this._objectId) {
				query.objectid = this._objectId;
			}
			if (this._objectType) {
				query.objecttype = this._objectType;
			}
			url += '?' + OC.buildQueryString(query);
			return url;
		}
	});

	OCA.Activity = OCA.Activity || {};
	OCA.Activity.ActivityCollection = ActivityCollection;
})();

