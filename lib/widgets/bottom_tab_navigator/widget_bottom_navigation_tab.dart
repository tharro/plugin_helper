import 'package:flutter/widgets.dart';

/// Contains the necessary parameters for building either a
/// [MaterialBottomNavigationScaffold] or [CupertinoBottomNavigationScaffold].
class WidgetBottomNavigationTab {
  const WidgetBottomNavigationTab({
    required this.bottomNavigationBarItem,
    required this.navigatorKey,
    required this.initialPageBuilder,
  });

  final BottomNavigationBarItem bottomNavigationBarItem;
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder initialPageBuilder;
}
