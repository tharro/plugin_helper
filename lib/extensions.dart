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
    String str = toString();
    if (str.split('.').length > 2) {
      if (int.parse(str.split('.')[1]) > 0 &&
          int.parse(str.split('.')[1]) != 0) {
        return toString();
      }
      return str.split('.')[0];
    }
    return str;
  }
}

extension StringX on String {
  bool get isPhoneNumber {
    return this.startsWith('+', 0) || RegExp(r'^-?[0-9]+$').hasMatch(this);
  }
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

Future<dynamic> pushAnimation(Widget page) {
  return MyPluginNavigation.instance.pushAnimationRoute(page);
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

goBack(Widget page) {
  return MyPluginNavigation.instance.goBack();
}
