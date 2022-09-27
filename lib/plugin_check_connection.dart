import 'dart:async';
import 'package:plugin_helper/index.dart';

//This plugin had used to check internet connection
class MyPluginConnectivity {
  static ConnectivityResult _connectionStatus = ConnectivityResult.none;
  static final Connectivity _connectivity = Connectivity();
  static late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  static bool isChecking = true;
  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initConnectivity({Function? onReconnect}) async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      _connectionStatus = result;
      isChecking = false;
    } catch (e) {
      print(e);
      isChecking = false;
      return;
    }
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((result) => _updateConnectionStatus(result, onReconnect));
    return _updateConnectionStatus(result, onReconnect);
  }

  static Future<void> _updateConnectionStatus(
      ConnectivityResult result, Function? onReconnect) async {
    if (isChecking == false) {
      if (result == ConnectivityResult.none) {
        toast(MyPluginMessageRequire.noConnection);
      }
      if ([ConnectivityResult.mobile, ConnectivityResult.wifi]
              .contains(result) &&
          _connectionStatus == ConnectivityResult.none) {
        toast(MyPluginMessageRequire.reconnecting);
        if (onReconnect != null) {
          onReconnect();
        }
      }
    }
    _connectionStatus = result;
  }

  static dispose() {
    _connectivitySubscription.cancel();
  }
}
