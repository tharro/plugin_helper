import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class MyPluginDeepLink {
  static StreamSubscription<Map>? streamSubscription;
  static init({required Function(Map<dynamic, dynamic> data) onDeepLink}) {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) async {
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        onDeepLink(data);
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  static dispose() {
    streamSubscription?.cancel();
  }
}
