import 'package:flutter/material.dart';
import 'package:plugin_helper/plugin_helper.dart';
import 'package:plugin_helper/plugin_message_require.dart';

class WidgetEmpty extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String? message;
  final TextStyle textStyle;
  final Widget? icon;
  final VoidCallback? onRefresh;
  final RefreshController? refreshController;
  const WidgetEmpty(
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
        if (icon != null)
          const SizedBox(
            height: 14,
          ),
        Text(
          message ?? PluginMessageRequire.messEmptyData,
          style: textStyle,
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
