var Store = require("flux/utils").Store;
var AppDispatcher = require("../dispatcher/dispatcher");
var AppConstants = require("../constants/app_constants");
var ActionTypes = AppConstants.ActionTypes;

var _user = {};
var _errors = [];

var ProfileStore = new Store(AppDispatcher);

ProfileStore.__onDispatch = function (payload) {
  var actionType = payload.actionType;
  var response = payload.response;

  switch (actionType) {

    case ActionTypes.LOGIN_RESPONSE:
      if (response.errors) {
        setErrors(response.errors);
      } else {
        setUser(response);
      }

      break;

    case ActionTypes.LOGOUT_RESPONSE:
      _user = null;
      break;

    // case ActionTypes.USER_RECEIVED:
    //   if (response.errors) {
    //     setErrors(response.errors);
    //   } else {
    //     setUser(response);
    //   }
    //
    //   break;

    case ActionTypes.PLAYLISTS_RECEIVED:
      updatePlaylists(response);
      break;
  };
};

ProfileStore.getProfile = function () {
  var userCopy = jQuery.extend({}, _user);

  return userCopy;
};

ProfileStore.getTracks = function () {
  var tracks = (_user.tracks ? _user.tracks : []);

  return tracks.slice();
},

ProfileStore.getPlaylists = function () {
  var playlists = (_user.playlists ? _user.playlists : []);

  return playlists.slice();
},

ProfileStore.getErrors = function () {
  return _errors.slice();
};

var setUser = function (user) {
  _user = user;

  ProfileStore.__emitChange();
};

var setErrors = function (errors) {
  _errors = errors;

  ProfileStore.__emitChange();
};

var updatePlaylists = function (playlists) {
  _user.playlists = playlists;

  ProfileStore.__emitChange();
};

module.exports = ProfileStore;
