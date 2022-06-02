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

extension SizedBoxX on double {
  Widget get h => SizedBox(height: this);
  Widget get w => SizedBox(width: this);
}

myNavigatorPush(Widget page) {
  return MyPluginNavigation.instance.push(page);
}

myNavigatorReplace(Widget page) {
  return MyPluginNavigation.instance.replace(page);
}

myNavigatorNavigatePopUtil(Widget page) {
  return MyPluginNavigation.instance.navigatePopUtil(page);
}

myNavigatorPushAnimationRoute(Widget page) {
  return MyPluginNavigation.instance.replace(page);
}

myNavigatorReplacementInTab(
    {required BuildContext context,
    required Widget page,
    bool isHoldTab = true}) {
  return MyPluginNavigation.instance.navigateToReplacementInTab(
      screen: page, isHoldTab: isHoldTab, context: context);
}

myNavigatorInTab(
    {required BuildContext context,
    required Widget page,
    bool isHoldTab = true}) {
  return MyPluginNavigation.instance
      .navigateToInTab(screen: page, isHoldTab: isHoldTab, context: context);
}

myNavigatorGoBack(Widget page) {
  return MyPluginNavigation.instance.goBack();
}
