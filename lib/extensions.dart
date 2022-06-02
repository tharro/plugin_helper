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

Future<dynamic> replacementInTab(
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
