import 'package:flutter/material.dart';
import 'index.dart';

extension DateTimeX on DateTime {
  bool isToday() {
    var now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameDay(DateTime dateTime) {
    return day == dateTime.day &&
        dateTime.month == month &&
        dateTime.year == year;
  }
}

extension SizedBoxX on int {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
}

extension ConvertDouble on double {
  String get showPerfectDouble {
    String str = toStringAsFixed(2);
    if (str.split('.').isNotEmpty) {
      if (int.parse(str.split('.')[1]) == 0) {
        return str.split('.')[0];
      }
    }
    return str;
  }
}

extension StringX on String {
  bool get isPhoneNumber {
    return startsWith('+', 0) ||
        startsWith('0', 0); // || RegExp(r'^-?[0-9]+$').hasMatch(this);
  }
}

// Convert hex to Color
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Future<dynamic> push(Widget page) {
  return MyPluginNavigation.instance.push(page);
}

Future<dynamic> replace(Widget page) {
  return MyPluginNavigation.instance.replace(page);
}

Future<dynamic> popUtil(Widget page) {
  return MyPluginNavigation.instance.navigatePopUtil(page);
}

Future<dynamic> replaceInTab(
    {required BuildContext context,
    required Widget page,
    bool isHoldTab = true}) {
  return MyPluginNavigation.instance.navigateToReplacementInTab(
      screen: page, isHoldTab: isHoldTab, context: context);
}

Future<dynamic> pushInTab(
    {required BuildContext context,
    required Widget page,
    bool isHoldTab = true}) {
  return MyPluginNavigation.instance
      .navigateToInTab(screen: page, isHoldTab: isHoldTab, context: context);
}

goBack<T>({T? callback}) {
  return MyPluginNavigation.instance.goBack(callback: callback);
}
