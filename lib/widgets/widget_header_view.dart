import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyWidgetHeader extends StatelessWidget implements PreferredSizeWidget {
  const MyWidgetHeader(
      {Key? key,
      required this.context,
      this.actions,
      this.iconLeft,
      this.title,
      this.onPressLeftIcon,
      this.toolbarHeight,
      this.backgroundColor,
      this.backgroundColorIconLeft,
      this.centerTitle = true,
      this.elevation = 0,
      this.isShowLeftIcon = true,
      this.titleTextStyle,
      this.systemUiOverlayStyle,
      this.onPrimaryColorIconLeft,
      this.titleSpacing = 16,
      this.leadingWidth = 48})
      : super(key: key);
  final BuildContext context;
  final List<Widget>? actions;
  final Widget? iconLeft;
  final Widget? title;
  final bool? centerTitle;
  final double? elevation;
  final Function? onPressLeftIcon;
  final bool isShowLeftIcon;
  final double? toolbarHeight, titleSpacing;
  final Color? backgroundColor;
  final Color? backgroundColorIconLeft, onPrimaryColorIconLeft;
  final TextStyle? titleTextStyle;
  final double? leadingWidth;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: systemUiOverlayStyle,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      elevation: elevation,
      actions: actions,
      backgroundColor: backgroundColor,
      leadingWidth: leadingWidth,
      leading: isShowLeftIcon
          ? GestureDetector(
              onTap: () {
                onPressLeftIcon ?? Navigator.pop(context);
              },
              child: iconLeft ??
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).appBarTheme.iconTheme!.color,
                  ))
          : null,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title: title,
      titleTextStyle: titleTextStyle,
    );
  }

  @override
  Size get preferredSize => Size(0, toolbarHeight ?? kToolbarHeight);
}
