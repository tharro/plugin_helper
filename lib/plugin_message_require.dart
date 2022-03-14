class PluginMessageRequire {
  static String messNoConnection = 'No internet connection';
  static String messService503 = 'Service Unavailable server error';
  static String messNotAuthorizedException =
      'Incorrect authentication credentials, please try again.';
  static String messUnHandleError = 'Unhandled error has occurred';
  static String messCanNotLaunchURL = 'Can not launch URL';
  static String messRefreshingText = '...Refreshing"';
  static String messCompleteText = 'Refresh completed';
  static String messReleaseText = 'Release to refresh';
  static String messIdleText = 'Pull down Refresh';

  static messageRequire({
    required String messageNoConnection,
    required String messageService503,
    required String messageNotAuthorizedException,
    required String messageUnHandleError,
    required String messageCanNotLaunchURL,
    String? messageRefreshingText,
    String? messageCompleteText,
    String? messageReleaseText,
    String? messageIdleText,
  }) {
    messNoConnection = messageNoConnection;
    messService503 = messageService503;
    messNotAuthorizedException = messageNotAuthorizedException;
    messUnHandleError = messageUnHandleError;
    messCanNotLaunchURL = messageCanNotLaunchURL;
    messRefreshingText = messageRefreshingText!;
    messCompleteText = messageCompleteText!;
    messReleaseText = messageReleaseText!;
    messIdleText = messageIdleText!;
  }
}
