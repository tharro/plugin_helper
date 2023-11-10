import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Customize a Material Design app bar.
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
      this.centerTitle = true,
      this.elevation = 0,
      this.isShowLeftIcon = true,
      this.systemUiOverlayStyle,
      this.titleSpacing = 0,
      this.leadingWidth = 48,
      this.automaticallyImplyLeading = true,
      this.bottom,
      this.foregroundColor})
      : super(key: key);

  final BuildContext context;

  /// A list of Widgets to display in a row after the [title] widget.
  final List<Widget>? actions;

  /// Customize a widget to display before the toolbar's [title].
  final Widget? iconLeft;

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// Whether the title should be centered.
  /// If this property is null, then [AppBarTheme.centerTitle] of [ThemeData.appBarTheme] is used.
  /// If that is also null, then value is adapted to the current [TargetPlatform].
  final bool? centerTitle;

  /// This property controls the size of the shadow below the app bar if [shadowColor] is not null.
  final double? elevation;

  /// A callback to be called when the user clicks the back button.
  final Function? onPressLeftIcon;

  /// Controls display the back icon.
  final bool isShowLeftIcon;

  /// Defines the height of the toolbar component of an [AppBar].
  /// By default, the value of [toolbarHeight] is [kToolbarHeight].
  final double? toolbarHeight;

  /// The spacing around [title] content on the horizontal axis.
  /// This spacing is applied even if there is no [leading] content or [actions].
  ///
  /// If you want [title] to take all the space available, set this value to 0.0.
  ///
  /// If this property is null, then [AppBarTheme.titleSpacing] of [ThemeData.appBarTheme] is used.
  ///
  /// If that is also null, then the default value is [NavigationToolbar.kMiddleSpacing].
  final double? titleSpacing;

  /// The fill color to use for an app bar's [Material].
  /// If null, then the [AppBarTheme.backgroundColor] is used.
  ///
  /// If that value is also null, then [AppBar] uses the overall theme's [ColorScheme.primary]
  /// if the overall theme's brightness is [Brightness.light], and [ColorScheme.surface]
  /// if the overall theme's [brightness] is [Brightness.dark].
  ///
  /// If this color is a [MaterialStateColor] it will be resolved against
  /// [MaterialState.scrolledUnder{super.key}{super.key}{super.key}{super.key}]
  /// when the content of the app's primary scrollable overlaps the app bar.
  final Color? backgroundColor;

  /// Defines the width of [leading] widget.
  ///
  /// By default, the value of [leadingWidth] is 48.0.
  final double? leadingWidth;

  /// Specifies the style to use for the system overlays that overlap the AppBar.
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can be used at the bottom of an app bar
  final PreferredSizeWidget? bottom;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the leading widget should be.
  /// If false and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// The default color for [Text] and [Icon]s within the app bar.
  ///
  /// If null, then [AppBarTheme.foregroundColor] is used.
  /// If that value is also null, then [AppBar] uses the overall theme's [ColorScheme.onPrimary]
  /// if the overall theme's brightness is [Brightness.light],
  /// and [ColorScheme.onSurface] if the overall theme's [brightness] is [Brightness.dark].
  ///
  /// This color is used to configure [DefaultTextStyle] that contains the toolbar's children,
  /// and the default [IconTheme] widgets that are created if [iconTheme] and [actionsIconTheme] are null.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      systemOverlayStyle: systemUiOverlayStyle,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      elevation: elevation,
      actions: actions,
      bottom: bottom,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      leadingWidth: leadingWidth,
      leading: isShowLeftIcon
          ? GestureDetector(
              onTap: () {
                if (onPressLeftIcon != null) {
                  onPressLeftIcon!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: iconLeft ??
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).appBarTheme.iconTheme!.color,
                      )))
          : null,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title: title,
    );
  }

  @override
  Size get preferredSize => Size(0, toolbarHeight ?? kToolbarHeight);
}
