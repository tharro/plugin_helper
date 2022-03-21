import 'package:flutter/material.dart';

class MyWidgetHeader {
  static AppBar header({
    required BuildContext context,
    List<Widget>? actions,
    Widget? iconLeft,
    required Text title,
    bool? centerTitle = true,
    double? elevation = 0,
    Function? onPressLeftIcon,
    bool isShowLeftIcon = true,
    double? toolbarHeight,
    Color? backgroundColor,
    Color? backgroundColorIconLeft,
  }) =>
      AppBar(
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
