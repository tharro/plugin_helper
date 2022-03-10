import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetOverlayLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Widget? loadingWidget;
  const WidgetOverlayLoading(
      {Key? key,
      required this.child,
      this.isLoading = false,
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
          if (loadingWidget == null)
            Positioned.fill(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor ?? const Color(0xff262626),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const CupertinoActivityIndicator(
                    radius: 12,
                  ),
                ),
              ),
            )
          else
            loadingWidget!
      ],
    );
  }
}
