class PluginMessageRequire {
  static String messNoConnection = 'No internet connection';
  static String messCanNotLaunchURL = 'Can not launch URL';
  static String messRefreshingText = "...Refreshing";
  static String messCompleteText = 'Refresh completed';
  static String messReleaseText = 'Release to refresh';
  static String messIdleText = 'Pull down Refresh';

  static messageRequire({
    required String messageNoConnection,
    required String messageCanNotLaunchURL,
    required String messageRefreshingText,
    required String messageCompleteText,
    required String messageReleaseText,
    required String messageIdleText,
  }) {
    messNoConnection = messageNoConnection;
    messCanNotLaunchURL = messageCanNotLaunchURL;
    messRefreshingText = messageRefreshingText;
    messCompleteText = messageCompleteText;
    messReleaseText = messageReleaseText;
    messIdleText = messageIdleText;
  }
}
