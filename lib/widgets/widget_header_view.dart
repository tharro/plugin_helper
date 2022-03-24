import 'package:flutter/material.dart';

class MyWidgetHeader extends StatelessWidget implements PreferredSizeWidget {
  const MyWidgetHeader(
      {Key? key,
      required this.context,
      this.actions,
      this.iconLeft,
      required this.title,
      this.onPressLeftIcon,
      this.toolbarHeight,
      this.backgroundColor,
      this.backgroundColorIconLeft,
      this.centerTitle = true,
      this.elevation = 0,
      this.isShowLeftIcon = true})
      : super(key: key);
  final BuildContext context;
  final List<Widget>? actions;
  final Widget? iconLeft;
  final Text title;
  final bool? centerTitle;
  final double? elevation;
  final Function? onPressLeftIcon;
  final bool isShowLeftIcon;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final Color? backgroundColorIconLeft;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      elevation: elevation,
      actions: actions,
      backgroundColor: backgroundColor,
      leading: isShowLeftIcon
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

  @override
  Size get preferredSize => const Size(0, kToolbarHeight);
}
