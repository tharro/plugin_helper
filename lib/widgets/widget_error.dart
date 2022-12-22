import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWidgetError extends StatelessWidget {
  final String error;
  final VoidCallback? onRefresh;
  final RefreshController? refreshController;
  final Widget? iconError;
  final TextStyle textStyle;
  const MyWidgetError({
    Key? key,
    required this.error,
    required this.textStyle,
    this.onRefresh,
    this.refreshController,
    this.iconError,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconError ?? const Icon(Icons.error_outline, size: 20),
        const SizedBox(height: 5),
        Text(
          error,
          textAlign: TextAlign.center,
          style: textStyle,
        )
      ],
    );
    if (refreshController != null) {
      return SmartRefresher(
        onRefresh: onRefresh,
        controller: refreshController!,
        child: child,
      );
    }
    return child;
  }
}
