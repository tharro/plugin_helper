import 'package:flutter/material.dart';

class WidgetHeaderView extends StatelessWidget {
  final List<Widget>? actions;
  final Widget? iconLeft;
  final Text title;
  final bool? centerTitle;
  final double? elevation;
  final Function? onPressLeftIcon;
  final bool? isShowLeftIcon;
  final double? toolbarHeight;
  final Color? backgroundColor, backgroundColorIconLeft;
  const WidgetHeaderView(
      {Key? key,
      this.actions,
      this.iconLeft,
      required this.title,
      this.centerTitle = true,
      this.elevation = 0,
      this.onPressLeftIcon,
      this.isShowLeftIcon = true,
      this.toolbarHeight,
      this.backgroundColor,
      this.backgroundColorIconLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      elevation: elevation,
      actions: actions,
      backgroundColor: backgroundColor,
      leading: isShowLeftIcon!
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: backgroundColorIconLeft ?? Colors.transparent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder()),
              onPressed: () {
                onPressLeftIcon ?? Navigator.pop(context);
              },
              child: iconLeft ??
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ))
          : null,
      centerTitle: centerTitle,
      title: title,
    );
  }
}
