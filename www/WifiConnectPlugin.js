var exec = require('cordova/exec');

exports.connectToWifi = function (ssid, password, success, error) {
    exec(success, error, 'WifiConnectPlugin', 'connectToWifi', [ssid, password]);
};

exports.getConnectedSSID = function (success, error) {
    exec(success, error, 'WifiConnectPlugin', 'getConnectedSSID');
};