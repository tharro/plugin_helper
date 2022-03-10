import 'package:flutter/material.dart';

class WidgetEmpty extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String? message;
  final TextStyle textStyle;
  final Widget? icon;
  const WidgetEmpty(
      {Key? key,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.message,
      required this.textStyle,
      this.icon,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (icon != null) icon!,
        if (icon != null)
          const SizedBox(
            height: 14,
          ),
        Text(
          message ?? "Empty Data",
          style: textStyle,
        )
      ],
    );
  }
}
