import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class MyPluginDeepLinkWithFirebase {
  static Future<void> initDynamicLinks(
      {required Function(Uri url) handleDynamicLink,
      Function(OnLinkErrorException e)? onError}) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deepLink = data.link;
      handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri deepLink = dynamicLink!.link;
      handleDynamicLink(deepLink);
    }, onError: (OnLinkErrorException e) async {
      if (onError != null) {
        onError(e);
      }
    });
  }
}
