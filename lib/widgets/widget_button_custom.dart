import 'package:flutter/material.dart';

class WidgetButtonCustom extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final bool isSecondary, isOutLine;
  final Color? secondaryColor, primaryColor;
  final Color? outLineColor;
  final Color? secondaryBorderColor, primaryBorderColor;
  final Color? outLineBorderColor;
  final Color? borderColor, backgroundColor, textColor;
  final Color? textPrimaryColor, textSecondaryColor;
  final Color? textOutLineColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  const WidgetButtonCustom({
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
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled
          ? () {
              onPressed();
            }
          : null,
      style: OutlinedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        backgroundColor: enabled == false
            ? const Color(0xfff1f1f2)
            : checkBackgroundColor(), // background
        primary: checkBackgroundColor() == Colors.white
            ? Colors.grey
            : Colors.white, // foreground text
        side: enabled == false
            ? const BorderSide(color: Color(0xfff1f1f2))
            : BorderSide(
                color: checkBorderColor(),
              ), // foreground border
      ),
      child: Center(
          child: Text(
        title,
        style: checkTextColor(textStyle!),
      )),
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
      return textStyle.copyWith(color: const Color(0xff9a9a9a));
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
