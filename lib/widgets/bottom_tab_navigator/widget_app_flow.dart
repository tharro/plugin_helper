import 'package:flutter/widgets.dart';

/// Holds information about our app's flows.
class WidgetAppFlow {
  const WidgetAppFlow({
    required this.title,
    required this.iconData,
    required this.activeIconData,
    required this.navigatorKey,
    required this.child,
  });

  final String title;
  final Widget iconData;
  final Widget activeIconData;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;
}
