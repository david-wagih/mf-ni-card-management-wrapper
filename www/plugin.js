var exec = require("cordova/exec");

var PLUGIN_NAME = "MfNiWrapperPlugin";

var MfNiWrapperPlugin = {
  echo: function (message, successCallback, errorCallback) {
    exec(successCallback, errorCallback, PLUGIN_NAME, "echo", [message]);
  },
  sdkInit: function (
    rootUrl,
    cardIdentifierId,
    cardIdentifierType,
    bankCode,
    token,
    successCallback,
    errorCallback
  ) {
    exec(successCallback, errorCallback, PLUGIN_NAME, "initializeSDK", [
      rootUrl,
      cardIdentifierId,
      cardIdentifierType,
      bankCode,
      token,
    ]);
  },
  setPinForm: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, PLUGIN_NAME, "setPinForm", []);
  },
};

module.exports = MfNiWrapperPlugin;
