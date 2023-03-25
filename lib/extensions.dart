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
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Future<T?> push<T>(Widget page) {
  return MyPluginNavigation.instance.navigationKey!.currentState!
      .push(MaterialPageRoute(builder: (_) => page));
}

Future<T?> replace<T>(Widget page, {bool isFadeRoute = false}) {
  return MyPluginNavigation.instance.navigationKey!.currentState!
      .pushReplacement(isFadeRoute
          ? FadePageRoute(child: page)
          : MaterialPageRoute(builder: (_) => page));
}

Future<T?> popUtil<T>(Widget page) {
  MyPluginNavigation.instance.navigationKey!.currentState!
      .popUntil((route) => route.isFirst);
  return replace(page);
}

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

void goBack<T>({BuildContext? context, T? callback}) {
  if (context != null) {
    Navigator.pop(context, callback);
    return;
  }
  MyPluginNavigation.instance.navigationKey!.currentState!.pop(callback);
}
