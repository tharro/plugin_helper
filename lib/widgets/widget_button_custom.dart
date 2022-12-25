import 'package:flutter/material.dart';

class MyWidgetButtonCustom extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final bool isSecondary, isOutLine;
  final Color? secondaryColor, primaryColor;
  final Color? outLineColor;
  final Color? secondaryBorderColor, primaryBorderColor;
  final Color? outLineBorderColor;
  final Color? borderColor,
      backgroundColor,
      disableBackgroundColor,
      disableTextColor,
      disableBorderColor,
      textColor;
  final Color? textPrimaryColor, textSecondaryColor;
  final Color? textOutLineColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final double? width, height, elevation;
  final Widget? icon;
  final Gradient? gradient;
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
          foregroundColor: checkBackgroundColor() == Colors.white
              ? Colors.grey
              : Colors.white,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          backgroundColor: enabled == false
              ? disableBackgroundColor
              : checkBackgroundColor(), // foreground text
          side: enabled == false
              ? BorderSide(color: disableBorderColor!)
              : BorderSide(
                  color: checkBorderColor(),
                ), // foreground border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            Text(
              title,
              style: checkTextColor(textStyle!),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  Color checkBackgroundColor() {
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

  Color checkBorderColor() {
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

  TextStyle checkTextColor(TextStyle textStyle) {
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
