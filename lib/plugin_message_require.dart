import 'package:flutter/material.dart';

class MyPluginMessageRequire {
  static String noConnection = 'No internet connection';
  static String canNotLaunchURL = 'Can not launch URL';
  static String refreshingText = "...Refreshing";
  static String completeText = 'Refresh completed';
  static String releaseText = 'Release to refresh';
  static String idleText = 'Pull down Refresh';
  static String emptyData = 'Empty Data';
  static String reconnecting = 'Reconnecting...';
  static String weakPassword = 'Weak password';
  static String invalidEmail = 'Invalid email address';
  static String canNotEmpty = 'This field cannot be empty';
  static String cancel = 'Cancel';
  static TextStyle textStyleCancelDownload = const TextStyle(fontSize: 12);
  static String downloading = 'Downloading';
  static String downloadingFile = 'Downloading File';
  static TextStyle textStyleTitleDownload = const TextStyle(fontSize: 14);
  static String permissionDenied = 'Permission Denied';
  static String linkEmpty = 'Link is empty';
  static String requiredFullName =
      'Please enter a valid first name and last name';

  static messageRequire({
    required String messageNoConnection,
    required String messageCanNotLaunchURL,
    required String messageRefreshingText,
    required String messageCompleteText,
    required String messageReleaseText,
    required String messageIdleText,
    required String messageEmptyData,
    required String messageReconnecting,
    required String messageWeakPassword,
    required String messageInvalidEmail,
    required String messageCanNotEmpty,
    required String messageCancel,
    String? messageDownloading,
    String? messageDownloadingFile,
    String? messagePermissionDenied,
    TextStyle? textStyleCancelDownloads,
    textStyleTitleDownloads,
    String? messageLinkEmpty,
    String? messageRequiredFullName,
  }) {
    noConnection = messageNoConnection;
    canNotLaunchURL = messageCanNotLaunchURL;
    refreshingText = messageRefreshingText;
    completeText = messageCompleteText;
    releaseText = messageReleaseText;
    idleText = messageIdleText;
    emptyData = messageEmptyData;
    reconnecting = messageReconnecting;
    weakPassword = messageWeakPassword;
    invalidEmail = messageInvalidEmail;
    canNotEmpty = messageCanNotEmpty;
    canNotEmpty = messageCancel;
    downloading = messageDownloading ?? downloading;
    downloadingFile = messageDownloadingFile ?? downloadingFile;
    permissionDenied = messagePermissionDenied ?? permissionDenied;
    textStyleCancelDownload =
        textStyleCancelDownloads ?? textStyleCancelDownload;
    textStyleTitleDownload = textStyleTitleDownloads ?? textStyleTitleDownload;
    linkEmpty = messageLinkEmpty ?? linkEmpty;
    requiredFullName = messageRequiredFullName ?? requiredFullName;
  }
}
