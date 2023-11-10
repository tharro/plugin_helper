import 'package:flutter/material.dart';

import 'index.dart';

extension DateTimeX on DateTime {
  /// Check if date time is today.
  ///
  /// Example
  /// ```
  /// bool isToday = DateTime().parse("2023-09-09").isToday();
  /// ```
  bool isToday() {
    var now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date time is same other date time
  ///
  /// Example
  /// ```
  /// bool isSameDay = DateTime().parse("2023-09-09").isSameDay(DateTime.now());
  /// ```
  bool isSameDay(DateTime dateTime) {
    return day == dateTime.day &&
        dateTime.month == month &&
        dateTime.year == year;
  }
}

extension SizedBoxX on int {
  /// Rendering height widget
  ///
  /// Example
  /// ```
  /// 12.h
  /// ```
  Widget get h => SizedBox(height: toDouble());

  /// Rendering width widget
  ///
  /// Example
  /// ```
  /// 12.w
  /// ```
  Widget get w => SizedBox(width: toDouble());
}

extension ConvertDouble on double {
  /// Format a double number to remove the decimal part if it is 0
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
  /// Check if phone number or not
  bool get isPhoneNumber {
    return startsWith('+', 0) ||
        startsWith('0', 0); // || RegExp(r'^-?[0-9]+$').hasMatch(this);
  }
}

/// Convert hex string to Color
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

/// Push the given route onto the navigator.
Future<T?> push<T>(Widget page, {BuildContext? context}) {
  if (context != null) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  return MyPluginNavigation.instance.navigationKey!.currentState!
      .push(MaterialPageRoute(builder: (_) => page));
}

/// Replace the current route of the navigator.
Future<T?> replace<T>(Widget page,
    {BuildContext? context, bool isFadeRoute = false}) {
  if (context != null) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => page));
  }

  return MyPluginNavigation.instance.navigationKey!.currentState!
      .pushReplacement(isFadeRoute
          ? FadePageRoute(child: page)
          : MaterialPageRoute(builder: (_) => page));
}

/// Pop to the first screen in the navigator.
Future<T?> popUtil<T>(
  Widget page, {
  BuildContext? context,
}) {
  if (context != null) {
    Navigator.popUntil(context, (route) => route.isFirst);
    return replace(page, context: context);
  }

  MyPluginNavigation.instance.navigationKey!.currentState!
      .popUntil((route) => route.isFirst);
  return replace(page);
}

/// Replace the current route of the navigator in the tab.
Future<T?> navigateToReplacementInTab<T>(
    {required BuildContext context,
    bool isHoldTab = true,
    required Widget screen,
    PageRoute<T>? pageRoute}) async {
  return await Navigator.of(context, rootNavigator: !isHoldTab).pushReplacement(
    pageRoute ??
        MyPluginNavigation.instance.buildAdaptivePageRoute(
          builder: (context) => screen,
        ),
  );
}

/// Push the given route onto the navigator in the tab.
Future<T?> navigateToInTab<T>(
    {required BuildContext context,
    bool isHoldTab = true,
    required Widget screen,
    PageRoute<T>? pageRoute}) async {
  return await Navigator.of(context, rootNavigator: !isHoldTab).push(
    pageRoute ??
        MyPluginNavigation.instance.buildAdaptivePageRoute(
          builder: (context) => screen,
        ),
  );
}

/// Pop the top-most route off the navigator that most tightly encloses the given context.
void goBack<T>({BuildContext? context, T? callback}) {
  if (context != null) {
    Navigator.pop(context, callback);
    return;
  }
  MyPluginNavigation.instance.navigationKey!.currentState!.pop(callback);
}

/// Check whether device is tablet or not.
bool get kIsTablet {
  final data = MediaQueryData.fromWindow(
      WidgetsBinding.instance.platformDispatcher.views.single);
  if (Orientation.portrait == data.orientation) {
    return data.size.shortestSide >= 600;
  }
  return data.size.longestSide >= 600;
}
