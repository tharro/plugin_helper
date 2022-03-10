import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class WidgetPinPut extends StatelessWidget {
  final Function(String)? onSubmit;
  final TextEditingController controller;
  final double paddingHorizontal;
  final TextStyle textStyle;
  final double radius;
  final Color colorSubmitBorder, colorDefaultBorder;
  final Color? submitBackgroundColor, defaultBackgroundColor;
  const WidgetPinPut(
      {Key? key,
      this.onSubmit,
      required this.controller,
      required this.paddingHorizontal,
      required this.textStyle,
      this.radius = 5.0,
      required this.colorSubmitBorder,
      required this.colorDefaultBorder,
      required this.submitBackgroundColor,
      this.defaultBackgroundColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthItem = (width - paddingHorizontal) / 8.3;
    return Pinput(
      length: 6,
      submittedPinTheme: PinTheme(
          width: widthItem,
          height: widthItem * 1.5,
          textStyle: textStyle,
          decoration: BoxDecoration(
              color: submitBackgroundColor ?? Colors.white,
              border: Border.all(width: 1, color: colorSubmitBorder),
              borderRadius: BorderRadius.circular(radius))),
      defaultPinTheme: PinTheme(
          width: widthItem,
          height: widthItem * 1.5,
          textStyle: textStyle,
          decoration: BoxDecoration(
              color: defaultBackgroundColor ?? Colors.white,
              border: Border.all(width: 1, color: colorDefaultBorder),
              borderRadius: BorderRadius.circular(radius))),
      controller: controller,
      onSubmitted: onSubmit,
    );
  }
}
