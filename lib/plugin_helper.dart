export 'package:firebase_analytics/firebase_analytics.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:device_info_plus/device_info_plus.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:intl/intl.dart';
export 'package:dio/dio.dart';
export 'package:path_provider/path_provider.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
export 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:firebase_analytics/firebase_analytics.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_crashlytics/firebase_crashlytics.dart';
export 'package:image_picker/image_picker.dart';
export 'package:file_picker/file_picker.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:new_version/new_version.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:pull_to_refresh/pull_to_refresh.dart';
export 'package:pin_code_fields/pin_code_fields.dart';
export 'package:mime_type/mime_type.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:amazon_cognito_identity_dart_2/cognito.dart';
export 'package:flutter_stripe/flutter_stripe.dart';
export 'package:collection/collection.dart';
export 'package:equatable/equatable.dart';
export 'package:mime_type/mime_type.dart';
export 'package:meta/meta.dart';
export 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:new_version/new_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:plugin_helper/plugin_authentication.dart';
import 'package:plugin_helper/plugin_message_require.dart';
import 'package:plugin_helper/widgets/phone_number/src/utils/phone_number/phone_number_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
enum PasswordValidType {
  atLeast8Characters,
  strongPassword,
}

class MyPluginHelper {
  static bool isValidateEmail({required String email}) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email.trim());
  }

  static Future<String> getMeIdDevice() async {
    String meId = '';
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo? androidDevice = await deviceInfoPlugin.androidInfo;
        meId = androidDevice.id!;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDevice = await deviceInfoPlugin.iosInfo;
        meId = iosDevice.identifierForVendor!;
      }
    } on PlatformException {
      print('Error:' 'Failed to get platform version.');
    }
    return meId;
  }

  static bool isValidPassword(
      {required String password,
      PasswordValidType passwordValidType =
          PasswordValidType.atLeast8Characters}) {
    switch (passwordValidType) {
      case PasswordValidType.atLeast8Characters:
        return password.length >= 8;
      case PasswordValidType.strongPassword:
        var regexPassword =
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\^$*.\[\]{}\(\)?\-“!@#%&/,><\’:;|_~`])\S{8,99}";
        return RegExp(regexPassword).hasMatch(password);
    }
  }

  static Future<String?> getParsedPhoneNumber(
      {required String phoneNumber, String? isoCode}) async {
    if (phoneNumber.isNotEmpty && isoCode != null) {
      try {
        bool? isValidPhoneNumber = await PhoneNumberUtil.isValidNumber(
            phoneNumber: phoneNumber, isoCode: isoCode);

        if (isValidPhoneNumber!) {
          return await PhoneNumberUtil.normalizePhoneNumber(
              phoneNumber: phoneNumber, isoCode: isoCode);
        }
      } on Exception {
        return null;
      }
    }
    return null;
  }

  static String formatCurrency(double number) {
    NumberFormat formatCurrency =
        NumberFormat.currency(locale: 'en-US', symbol: '\$');
    try {
      return formatCurrency.format(number);
    } catch (e) {
      return '\$0.00';
    }
  }

  static var dio = Dio();

  static Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  static Future<bool> requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      permission = await Permission.storage.status;
    }

    return permission == PermissionStatus.granted;
  }

  static void _onReceiveProgress({int? received, int? total}) {
    if (total != -1) {
      if ((received! / total! * 100).toStringAsFixed(0) == '100') {}
    }
  }

  static Future<void> _startDownload(
      {required String savePath,
      required String url,
      required Function() onComplete,
      required Function(String error) onError,
      CancelToken? cancelToken}) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    try {
      var response = await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: (int received, int total) {
        _onReceiveProgress(received: received, total: total);
      });
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      onComplete();
    } catch (ex) {
      result['error'] = ex.toString();
      onError(ex.toString());
    }
  }

  static Future<void> download({
    required String url,
    required Function() onComplete,
    required Function(String error) onError,
    required Function() onCancel,
    required CancelToken cancelToken,
  }) async {
    var isPermissionStatusGranted = await requestPermissions();
    if (isPermissionStatusGranted) {
      var dir = await _getDownloadDirectory();
      var savePath = path.join(dir?.path ?? '', url.split('/').last);
      await _startDownload(
          savePath: savePath,
          url: url,
          onComplete: onComplete,
          onError: onError,
          cancelToken: cancelToken);
    } else {
      onCancel();
    }
  }

  static launchUrl({required String url, String? error}) async {
    if (url.contains('https://') == false || url.contains('http://') == false) {
      url = 'https://$url';
    }
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Fluttertoast.showToast(
            msg: error ?? MyPluginMessageRequire.messCanNotLaunchURL,
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: error ?? MyPluginMessageRequire.messCanNotLaunchURL,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  static String formatUtcTime(
      {required String dateUtc,
      required String format,
      String languageCode = 'en',
      String? newPattern}) {
    try {
      var dateTime = DateFormat(
        newPattern ?? "yyyy-MM-dd'T'HH:mm:ss",
      ).parseUtc(dateUtc);
      var dateLocal = dateTime.toLocal();

      return DateFormat(format, languageCode).format(dateLocal);
    } catch (e) {
      return '-:--';
    }
  }

  static String convertTimeToHourOrDay(
      {required String dateTime, required String format}) {
    try {
      var date = DateFormat(format).parse(dateTime);
      final x = DateFormat(format).format(DateTime.now());
      final dateNow = DateFormat(format).parse(x);
      final day = dateNow.difference(date).inDays;
      if (day == 0) {
        final hours = dateNow.difference(date).inHours;
        if (hours == 0) {
          final minutes = dateNow.difference(date).inMinutes;
          if (minutes == 0) {
            return "${dateNow.difference(date).inSeconds}sec";
          } else {
            return "${minutes}min";
          }
        } else {
          return "${hours.abs()}h";
        }
      }
      return "${dateNow.difference(date).inDays}d";
    } catch (e) {
      return "-:--";
    }
  }

  static checkUpdateApp(
      {required BuildContext context,
      required String androidId,
      required String iOSId}) {
    final newVersion = NewVersion(
      iOSId: androidId,
      androidId: iOSId,
    );
    newVersion.showAlertIfNecessary(context: context);
  }

  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var diagonal = sqrt((width * width) + (height * height));

    if (Platform.isAndroid) {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static showToast({required String message}) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
  }

  static Future<bool> isFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(MyPluginAppConstraints.firstRun) ?? true;
  }

  static Future<void> setFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(MyPluginAppConstraints.firstRun, false);
  }

  static void showModalBottom({
    required BuildContext context,
    double radiusShape = 16,
    bool isDismissible = true,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isShowLine = true,
    Widget? customLine,
    required Widget child,
    double? height,
  }) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: isDismissible,
        backgroundColor: backgroundColor,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.98),
        shape: shape ??
            RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(radiusShape))),
        builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                constraints: BoxConstraints(
                    maxHeight:
                        height ?? MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isShowLine)
                      const SizedBox(
                        height: 10,
                      ),
                    if (isShowLine)
                      customLine ??
                          Container(
                            width: 60,
                            height: 6,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(17)),
                          ),
                    if (isShowLine)
                      const SizedBox(
                        height: 10,
                      ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        child,
                      ],
                    ))),
                  ],
                ))));
  }
}
