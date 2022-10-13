import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class MyPluginDeepLinkWithFirebase {
  static Future<void> initDynamicLinks(
      {required Function(Uri url) handleDynamicLink,
      Function(dynamic)? onError}) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deepLink = data.link;
      handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) async {
      if (dynamicLinkData != null) {
        final Uri deepLink = dynamicLinkData.link;
        handleDynamicLink(deepLink);
      }
    }).onError((e) {
      if (onError != null) {
        onError(e);
      }
    });
  }
}
