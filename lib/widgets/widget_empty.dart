import 'package:flutter/material.dart';
import 'package:plugin_helper/index.dart';

class MyWidgetEmpty extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String? message;
  final TextStyle textStyle;
  final Widget? icon;
  final VoidCallback? onRefresh;
  final RefreshController? refreshController;
  const MyWidgetEmpty(
      {Key? key,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.message,
      required this.textStyle,
      this.icon,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.onRefresh,
      this.refreshController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var child = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (icon != null) icon!,
        if (icon != null) const SizedBox(height: 14),
        Text(
          message ?? MyPluginMessageRequire.emptyData,
          style: textStyle,
          textAlign: TextAlign.center,
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
