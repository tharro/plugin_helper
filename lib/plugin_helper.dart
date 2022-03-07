import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:plugin_helper/widgets/custom_dialog.dart';

DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

class PluginHelper {
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
        AndroidDeviceInfo androidDevice = await deviceInfoPlugin.androidInfo;
        meId = androidDevice.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDevice = await deviceInfoPlugin.iosInfo;
        meId = iosDevice.identifierForVendor;
      }
    } on PlatformException {
      print('Error:' 'Failed to get platform version.');
    }
    return meId;
  }

  static bool isValidPassword(
      {required String password, bool isStrong = false}) {
    if (isStrong) {
      //require min 8 characters, include uppercase Characters, numbers, symbol
      var regexPassword =
          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\^$*.\[\]{}\(\)?\-“!@#%&/,><\’:;|_~`])\S{8,99}";
      return RegExp(regexPassword).hasMatch(password);
    }
    return password.length >= 8;
  }

  // static Widget dialogWidget({
  //   required BuildContext context,
  //   required String title,
  //   String message = '',
  //   Function? onClose,
  //   bool isShowSecondButton = false,
  //   Function? onPressPrimaryButton,
  //   onPressSecondButton,
  //   String? labelPrimary,
  //   labelSecondary,
  //   required Widget buttonPrimary,
  //   required TextStyle textStyleTitle,
  // }) {
  //   return CustomDialog(
  //     title: title,
  //     descriptions: message,
  //     onClose: onClose,
  //     isShowSecondButton: isShowSecondButton,
  //     onPressPrimaryButton: onPressPrimaryButton,
  //     onPressSecondButton: onPressSecondButton,
  //     labelPrimary: labelPrimary,
  //     labelSecondary: labelSecondary,
  //     buttonPrimary: buttonPrimary,
  //     textStyleTitle: textStyleTitle,
  //   );
  // }
}
