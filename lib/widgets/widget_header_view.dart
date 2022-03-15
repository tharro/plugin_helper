import 'package:flutter/material.dart';

class WidgetHeader {
  static AppBar header({
    required final BuildContext context,
    final List<Widget>? actions,
    final Widget? iconLeft,
    required final Text title,
    final bool? centerTitle,
    final double? elevation,
    final Function? onPressLeftIcon,
    final bool? isShowLeftIcon,
    final double? toolbarHeight,
    final Color? backgroundColor,
    backgroundColorIconLeft,
  }) =>
      AppBar(
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
