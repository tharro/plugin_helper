import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

/// Only Android.
/// Handles double-tapping the back button to exit the app.
class MyWidgetDoubleCheckToCloseApp extends StatefulWidget {
  final Widget child;
  final String message;
  const MyWidgetDoubleCheckToCloseApp(
      {Key? key, required this.child, required this.message})
      : super(key: key);
  @override
  _DoubleCheckToCloseAppState createState() => _DoubleCheckToCloseAppState();
}

class _DoubleCheckToCloseAppState extends State<MyWidgetDoubleCheckToCloseApp> {
  DateTime? _currentBackPressTime;

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        (_currentBackPressTime != null &&
            now.difference(_currentBackPressTime!) >
                const Duration(seconds: 2))) {
      _currentBackPressTime = now;
      toast(widget.message);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}
