import 'package:flutter/material.dart';

/// The MyWidgetButtonCustom widget is a customize button that triggers an action.
class MyWidgetButtonCustom extends StatelessWidget {
  /// A callback to be called when the user clicks on the button.
  final VoidCallback onPressed;

  /// Title of the button.
  final String title;

  /// Type of the button. Default is false.
  final bool isSecondary, isOutLine;

  /// Color of the secondary button.
  final Color? secondaryColor;

  /// Color of the primary button.
  final Color? primaryColor;

  /// Color of the outline button.
  final Color? outLineColor;

  /// Border color of the secondary button.
  final Color? secondaryBorderColor;

  /// Border color of the primary button.
  final Color? primaryBorderColor;

  /// Border color of the outline button.
  final Color? outLineBorderColor;

  /// Border color of the button.
  final Color? borderColor;

  /// Background color button.
  final Color? backgroundColor;

  /// Disable background color button.
  final Color? disableBackgroundColor;

  /// Disable text color of the button.
  final Color? disableTextColor;

  /// Disable border color button.
  final Color? disableBorderColor;

  /// Text Color of the button.
  final Color? textColor;

  /// Text color of the primary button.
  final Color? textPrimaryColor;

  /// Text color of the secondary button.
  final Color? textSecondaryColor;

  /// Text color of the outline button.
  final Color? textOutLineColor;

  /// The style of the text in the button.
  final TextStyle? textStyle;

  /// Applies only to boxes with rectangular shapes. Default is 0.
  final double borderRadius;

  /// Set margins of the button.
  final EdgeInsetsGeometry? padding;

  /// This property indicates whether users can click the button or not.
  final bool enabled;

  /// The width and height button
  final double? width, height;

  /// The elevation controls the shadow effect displayed below the button.
  final double? elevation;

  /// A widget display on the left [title]
  final Widget? icon;

  /// A 2D gradient.
  final Gradient? gradient;

  /// Change [title] to another widget.
  final Widget? customTitle;

  /// Shadow color of the button.
  final Color? shadowColor;

  const MyWidgetButtonCustom({
    Key? key,
    required this.onPressed,
    required this.title,
    this.isSecondary = false,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.isOutLine = false,
    this.textStyle = const TextStyle(fontSize: 18),
    this.borderRadius = 0,
    this.padding,
    this.enabled = true,
    this.secondaryColor = const Color(0xffF1F1F2),
    this.primaryColor = const Color(0xffffb41d),
    this.outLineColor = Colors.transparent,
    this.textPrimaryColor = Colors.black,
    this.textSecondaryColor = const Color(0xff9A9A9A),
    this.textOutLineColor = Colors.black,
    this.secondaryBorderColor = const Color(0xffdbdbdb),
    this.primaryBorderColor = const Color(0xffffb41d),
    this.outLineBorderColor = Colors.white,
    this.width,
    this.height,
    this.elevation,
    this.icon,
    this.gradient,
    this.disableBackgroundColor = const Color(0xfff1f1f2),
    this.disableTextColor = const Color(0xff9a9a9a),
    this.disableBorderColor = const Color(0xfff1f1f2),
    this.customTitle,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: ElevatedButton(
        onPressed: enabled
            ? () {
                onPressed();
              }
            : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: _checkBackgroundColor() == Colors.white
              ? Colors.grey
              : const Color.fromRGBO(255, 255, 255, 1),
          elevation: elevation,
          padding: padding,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          backgroundColor: enabled == false
              ? disableBackgroundColor
              : _checkBackgroundColor(), // foreground text
          side: enabled == false
              ? BorderSide(color: disableBorderColor!)
              : BorderSide(
                  color: _checkBorderColor(),
                ), // foreground border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (customTitle != null)
              customTitle!
            else
              Text(
                title,
                style: _checkTextColor(textStyle!),
                maxLines: 1,
              )
          ],
        ),
      ),
    );
  }

  Color _checkBackgroundColor() {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    if (isSecondary) {
      return secondaryColor!;
    } else if (isOutLine) {
      return outLineColor!;
    } else {
      return primaryColor!;
    }
  }

  Color _checkBorderColor() {
    if (borderColor != null) {
      return borderColor!;
    } else {
      if (isSecondary) {
        return secondaryBorderColor!;
      } else if (isOutLine) {
        return outLineBorderColor!;
      } else {
        return primaryBorderColor!;
      }
    }
  }

  TextStyle _checkTextColor(TextStyle textStyle) {
    if (!enabled) {
      return textStyle.copyWith(color: disableTextColor);
    } else {
      if (textColor != null) {
        return textStyle.copyWith(color: textColor);
      } else {
        if (isSecondary) {
          return textStyle.copyWith(color: textSecondaryColor);
        } else if (isOutLine) {
          return textStyle.copyWith(color: textOutLineColor ?? Colors.black);
        } else {
          return textStyle.copyWith(color: textPrimaryColor);
        }
      }
    }
  }
}
