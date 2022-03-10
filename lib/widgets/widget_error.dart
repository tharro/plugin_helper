import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WidgetError extends StatelessWidget {
  final String error;
  final VoidCallback? onTapRetry;
  final VoidCallback? onRefresh;
  final RefreshController? refreshController;
  const WidgetError(
      {Key? key,
      required this.error,
      this.onRefresh,
      this.refreshController,
      this.onTapRetry})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        onTapRetry != null
            ? IconButton(onPressed: onTapRetry, icon: const Icon(Icons.refresh))
            : const Icon(Icons.error_outline),
        const SizedBox(
          height: 5,
        ),
        Text(
          error,
          textAlign: TextAlign.center,
        )
      ],
    );
    if (onRefresh != null) {
      return SmartRefresher(
        onRefresh: onRefresh,
        controller: refreshController!,
        child: child,
      );
    }
    return child;
  }
}
