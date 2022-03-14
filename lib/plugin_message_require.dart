class PluginMessageRequire {
  static String messNoConnection = 'No internet connection';
  static String messService503 = 'Service Unavailable server error';
  static String messNotAuthorizedException =
      'Incorrect authentication credentials, please try again.';
  static String messUnHandleError = 'Unhandled error has occurred';
  static String messCanNotLaunchURL = 'Can not launch URL';

  static messageRequire({
    required String messageNoConnection,
    required String messageService503,
    required String messageNotAuthorizedException,
    required String messageUnHandleError,
    required String messageCanNotLaunchURL,
  }) {
    messNoConnection = messageNoConnection;
    messService503 = messageService503;
    messNotAuthorizedException = messageNotAuthorizedException;
    messUnHandleError = messageUnHandleError;
    messCanNotLaunchURL = messageCanNotLaunchURL;
  }
}
