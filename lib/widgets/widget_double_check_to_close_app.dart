import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

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
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        (currentBackPressTime != null &&
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2))) {
      currentBackPressTime = now;
      toast(widget.message);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: widget.child,
    );
  }
}
