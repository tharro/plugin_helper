import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin_helper/widgets/phone_number/src/models/country_list.dart';
import 'package:plugin_helper/widgets/phone_number/src/utils/phone_number/phone_number_util.dart';
import './index.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
var dio = Dio();

enum PasswordValidType {
  atLeast8Characters,
  strongPassword,
  notEmpty,
}

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}

enum RegExpType {
  numberWithDecimal,
  onlyNumber,
  onlyCharacter,
  numberWithDecimalWithNegative,
  onlyNumberWithNegative,
}

class MyPluginHelper {
  static const MethodChannel _channel = MethodChannel('plugin_helper');

  static bool isValidateEmail({required String email}) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email.trim());
  }

  static String parsePhoneWithCountry({required String phone}) {
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String? isoCountryCode = systemLocales.first.countryCode;
    String? dial = '+61';
    for (var e in Countries.countryList) {
      if (isoCountryCode == e['alpha_2_code']) {
        dial = e['dial_code'];
      }
    }
    if (phone.isNotEmpty) {
      if (!phone.startsWith('+', 0)) {
        if (phone.startsWith('0', 0)) {
          phone = phone.replaceFirst('0', dial!);
        } else {
          phone = dial! + phone;
        }
      }
    }
    return phone;
  }

  static Future<String> getMeIdDevice() async {
    String meId = '';
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo? androidDevice = await deviceInfoPlugin.androidInfo;
        meId = androidDevice.id;
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
      case PasswordValidType.notEmpty:
        return password.isNotEmpty;
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

  static String formatCurrency(
      {String locale = 'en-US', required double number}) {
    NumberFormat formatCurrency =
        NumberFormat.currency(locale: locale, symbol: '\$');
    try {
      return formatCurrency.format(number);
    } catch (e) {
      return '\$0.00';
    }
  }

  static bool isValidFullName({required String text}) {
    bool isValid = false;
    if (text.trim().split(' ').length >= 2) {
      isValid = true;
    }
    return isValid;
  }

  static FullName getFirstNameLastName({required String text}) {
    var fullNames = text.trim().split(' ');
    var firstName = "";
    var lastName = "";
    fullNames.removeWhere((element) => element.trim() == '');
    firstName = fullNames.first.toString();
    if (fullNames.length > 1) {
      fullNames.removeAt(0);
      lastName = fullNames.reduce((a, b) => a + " " + b);
    }
    return FullName(firstName: firstName, lastName: lastName);
  }

  static Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
      return directory;
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

  Future<String> downloadFiles({
    required BuildContext context,
    required List<String> links,
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      if (links == []) {
        toast(MyPluginMessageRequire.linkEmpty);
        return '';
      }
      final isPermissionStatusGranted = await requestPermissions();
      Directory? dir = await _getDownloadDirectory();
      if (isPermissionStatusGranted) {
        toast(MyPluginMessageRequire.downloading);
        String saveFileDir = '';
        for (int i = 0; i < links.length; i++) {
          String time = DateTime.now().microsecondsSinceEpoch.toString();
          String name = time + links[i].split('/').last;
          saveFileDir = path.join(dir!.path, name);
          await dio.download(links[i] + '?$time', saveFileDir);
        }
        onSuccess();
        return saveFileDir;
      } else {
        toast(MyPluginMessageRequire.permissionDenied);
        return '';
      }
    } catch (e) {
      Navigator.pop(context);
      onError(e);
      return '';
    }
  }

  static launchFromUrl({required String url, String? error}) async {
    if (url.contains('https://') == false || url.contains('http://') == false) {
      url = 'https://$url';
    }
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        toast(error ?? MyPluginMessageRequire.canNotLaunchURL);
      }
    } catch (e) {
      toast(error ?? MyPluginMessageRequire.canNotLaunchURL);
    }
  }

  static String formatUtcTime(
      {required String dateUtc,
      String? format = 'dd/MM/yyyy HH:mm:ss',
      String languageCode = 'en'}) {
    try {
      String date = dateUtc;
      if (!date.contains("Z")) {
        date = date + "Z";
      }
      var dateLocal = DateTime.parse(date).toLocal();
      return DateFormat(format, languageCode).format(dateLocal);
    } catch (e) {
      return '-:--';
    }
  }

  static String convertLocalTimeToUtcTime({String? dateTime}) {
    try {
      if (dateTime != null) {
        var dateUTC = DateTime.parse(dateTime).toUtc().toString();
        return dateUTC.replaceAll(' ', 'T');
      } else {
        return DateTime.now().toUtc().toString().replaceAll(' ', 'T');
      }
    } catch (e) {
      return '-:--';
    }
  }

  static String convertTimeToHourOrDay(
      {required String dateTime, String? format = 'dd/MM/yyyy HH:mm:ss'}) {
    try {
      var date = DateFormat(format).parse(dateTime);
      final dateNow = DateTime.now();
      final day = dateNow.difference(date).inDays.abs();
      if (day == 0) {
        final hours = dateNow.difference(date).inHours.abs();
        if (hours == 0) {
          final minutes = dateNow.difference(date).inMinutes.abs();
          if (minutes == 0) {
            final sec = dateNow.difference(date).inSeconds.abs();
            return "$sec ${MyPluginMessageRequire.second}${sec > 1 ? 's' : ''}";
          } else {
            return "$minutes ${MyPluginMessageRequire.minute}${minutes > 1 ? 's' : ''}";
          }
        } else {
          return "$hours ${MyPluginMessageRequire.hour}${hours > 1 ? 's' : ''}";
        }
      }
      if (day > 7) {
        return DateFormat(format).format(date);
      }
      return "$day ${MyPluginMessageRequire.day}${day > 1 ? 's' : ''}";
    } catch (e) {
      return "-:--";
    }
  }

  static checkUpdateApp(
      {required String iOSId,
      required String androidId,
      String? iOSAppStoreCountry,
      required Function(VersionStatus) onUpdate,
      required Function() onError}) async {
    final newVersion = NewVersionPlus(
        androidId: androidId,
        iOSId: iOSId,
        iOSAppStoreCountry: iOSAppStoreCountry);
    try {
      final status = await newVersion.getVersionStatus();
      onUpdate(status!);
    } catch (e) {
      onError();
    }
  }

  static bool isTablet(BuildContext context) {
    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      return true;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      return true;
    } else {
      return false;
    }
  }

  static Future setLanguage({required String language}) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: MyPluginAppConstraints.language, value: language);
  }

  static Future<String> getLanguage() async {
    const storage = FlutterSecureStorage();
    String? language = await storage.read(key: MyPluginAppConstraints.language);
    return language ?? 'en';
  }

  static Future<bool> isFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(MyPluginAppConstraints.firstRun) ?? true;
  }

  static Future<void> setFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(MyPluginAppConstraints.firstRun, false);
  }

  static Future<T> showModalBottom<T>({
    required BuildContext context,
    double radiusShape = 16,
    bool isDismissible = true,
    ShapeBorder? shape,
    Color? backgroundColor,
    required Widget child,
    double? maxHeight,
  }) async {
    return await showModalBottomSheet(
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
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                  maxHeight:
                      maxHeight ?? MediaQuery.of(context).size.height * 0.8),
              child: child,
            )));
  }

  static setOrientation({bool isPortrait = true}) {
    if (!isPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  static Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  static CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  static WidgetsBinding? _widgetsBinding;
  // Prevents app from closing splash screen, app layout will be build but not displayed
  static void preserve({required WidgetsBinding widgetsBinding}) {
    _widgetsBinding = widgetsBinding;
    _widgetsBinding?.deferFirstFrame();
  }

  static Future<void> remove() async {
    await Future.delayed(const Duration(seconds: 1));
    _widgetsBinding?.allowFirstFrame();
    _widgetsBinding = null;
  }

  static String getLinkImage(
      {required String key,
      double? width,
      double? height,
      BoxFit fit = BoxFit.cover}) {
    Map<String, dynamic> data = {
      "bucket": MyPluginAppEnvironment().bucket,
      "key": key,
    };

    if (width != null && height != null) {
      data["edits"] = {
        "resize": {
          "width": width,
          "height": height,
          "fit": fit.toString().replaceAll('BoxFit.', '')
        }
      };
    }
    var json = jsonEncode(data);
    Codec<String, dynamic> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(json);
    return MyPluginAppEnvironment().linkCloudfront! + encoded;
  }

  static List<TextInputFormatter> checkRegExt({required RegExpType type}) {
    switch (type) {
      case RegExpType.numberWithDecimal:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
        ];
      case RegExpType.numberWithDecimalWithNegative:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?\.?\d{0,2}'))
        ];
      case RegExpType.onlyNumber:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
      case RegExpType.onlyNumberWithNegative:
        return [FilteringTextInputFormatter.allow(RegExp(r'[-0-9]'))];
      case RegExpType.onlyCharacter:
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))];
      default:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
    }
  }

  static Future<String?> getTimeZone() async {
    return await _channel.invokeMethod('getLocalTimezone');
  }

  static Future<File> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }
}

class FullName {
  final String? firstName, lastName;

  FullName({this.firstName, this.lastName});
}
