import 'package:flutter/material.dart';
import 'package:plugin_helper/widgets/widget_loading.dart';

class WidgetOverlayLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Widget? loadingWidget;
  const WidgetOverlayLoading(
      {Key? key,
      required this.child,
      required this.isLoading,
      this.backgroundColor,
      this.loadingWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        if (isLoading)
          Positioned.fill(
            child: Center(
              child: loadingWidget ??
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundColor ?? const Color(0xff262626),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const WidgetLoading(),
                  ),
            ),
          )
      ],
    );
  }
}
