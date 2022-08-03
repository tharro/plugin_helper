import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyWidgetPinPut extends StatelessWidget {
  final Function(String value)? onCompleted;
  final TextEditingController controller;
  final double paddingHorizontal;
  final double radius;
  final bool? obscureText;
  final Widget? obscuringWidget;
  final String? obscuringCharacter;
  final List<BoxShadow>? boxShadows;
  final Function(String value) onChanged;
  final Color? activeFillColor,
      inactiveColor,
      activeColor,
      inactiveFillColor,
      selectedFillColor,
      selectedColor;
  final TextStyle textStyle;
  final double? borderWidth;
  final PinCodeFieldShape? shape;
  final double? widthPinput, heightPinput;
  final int? length;
  const MyWidgetPinPut(
      {Key? key,
      this.onCompleted,
      required this.controller,
      required this.paddingHorizontal,
      this.radius = 5.0,
      this.obscureText = false,
      this.obscuringCharacter = '*',
      this.obscuringWidget,
      this.boxShadows,
      required this.onChanged,
      this.activeFillColor,
      this.inactiveColor,
      this.activeColor,
      this.inactiveFillColor,
      this.selectedFillColor,
      this.selectedColor,
      this.borderWidth,
      this.shape,
      this.widthPinput,
      this.heightPinput,
      required this.textStyle,
      this.length})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthItem = (width - paddingHorizontal) / 8.3;
    return PinCodeTextField(
      appContext: context,
      length: length ?? 6,
      obscureText: obscureText!,
      obscuringCharacter: obscuringCharacter!,
      obscuringWidget: obscuringWidget,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: (v) {
        return null;
      },
      pinTheme: PinTheme(
        shape: shape ?? PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(radius),
        fieldHeight: heightPinput ?? widthItem * 1.3,
        fieldWidth: widthPinput ?? widthItem,
        activeFillColor: activeFillColor ?? Colors.white,
        inactiveColor: inactiveColor ?? Colors.white,
        activeColor: activeColor ?? const Color(0xffffb41d),
        inactiveFillColor: inactiveFillColor ?? Colors.white,
        selectedFillColor: selectedFillColor ?? Colors.white,
        selectedColor: selectedColor ?? const Color(0xffffb41d),
        borderWidth: borderWidth ?? 1,
      ),
      textStyle: textStyle,
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: controller,
      keyboardType: TextInputType.number,
      autoDisposeControllers: false,
      boxShadows: boxShadows ??
          const [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
      onCompleted: (v) {
        if (onCompleted != null) onCompleted!(v);
      },
      onChanged: (value) {
        onChanged(value);
      },
      beforeTextPaste: (text) {
        return false;
      },
    );
  }
}
