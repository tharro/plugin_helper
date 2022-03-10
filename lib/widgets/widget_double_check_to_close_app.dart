import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetDoubleCheckToCloseApp extends StatefulWidget {
  final Widget child;
  final String message;
  const WidgetDoubleCheckToCloseApp(
      {Key? key, required this.child, required this.message})
      : super(key: key);
  @override
  _DoubleCheckToCloseAppState createState() => _DoubleCheckToCloseAppState();
}

class _DoubleCheckToCloseAppState extends State<WidgetDoubleCheckToCloseApp> {
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        (currentBackPressTime != null &&
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2))) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: widget.message);
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
