import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

/// Show error message inline
class MyWidgetError extends StatelessWidget {
  /// Error message to show.
  final String error;

  /// A callback to be called when the user pull to refresh. If [refreshController] is active.
  final VoidCallback? onRefresh;

  /// A controller control header and footer state, it can trigger driving request Refresh, set the initialRefresh, status if needed.
  final RefreshController? refreshController;

  /// Change to a widget to show above [error]
  final Widget? iconError;

  /// The style of the text.
  final TextStyle textStyle;

  /// This bool will affect whether or not to have the function of drop-down refresh.
  final bool enablePullDown;

  /// Customize a header indicator displace before content. Only for Android/iOS.
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
