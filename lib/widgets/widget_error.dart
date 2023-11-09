import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

/// Show error message
class MyWidgetError extends StatelessWidget {
  final String error;
  final VoidCallback? onRefresh;
  final RefreshController? refreshController;
  final Widget? iconError;
  final TextStyle textStyle;
  final bool enablePullDown;
  final Widget? customHeaderRefresh;
  const MyWidgetError({
    Key? key,
    required this.error,
    required this.textStyle,
    this.onRefresh,
    this.refreshController,
    this.iconError,
    this.enablePullDown = true,
    this.customHeaderRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconError ?? const Icon(Icons.error_outline, size: 20),
        5.h,
        Text(
          error,
          textAlign: TextAlign.center,
          style: textStyle,
        )
      ],
    );

    if (refreshController != null) {
      return SmartRefresher(
        enablePullDown: enablePullDown,
        header: kIsWeb
            ? null
            : customHeaderRefresh ??
                (Platform.isIOS
                    ? const ClassHeaderGridIndicator()
                    : const MaterialClassicHeader()),
        onRefresh: onRefresh,
        controller: refreshController!,
        child: child,
      );
    }

    return child;
  }
}
