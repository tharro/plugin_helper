import 'package:flutter/widgets.dart';

/// Holds information about our app's flows.
class MyWidgetAppFlow {
  const MyWidgetAppFlow({
    this.title,
    required this.iconData,
    required this.activeIconData,
    required this.navigatorKey,
    required this.child,
  });

  final String? title;
  final Widget iconData;
  final Widget activeIconData;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  MyWidgetAppFlow copyWith({Widget? iconData, activeIconData}) {
    return MyWidgetAppFlow(
      activeIconData: activeIconData ?? this.activeIconData,
      child: child,
      iconData: iconData ?? this.iconData,
      navigatorKey: navigatorKey,
      title: title,
    );
  }
}
