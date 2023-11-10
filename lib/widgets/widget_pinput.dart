import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// A widget which will help you to generate pin code fields.
class MyWidgetPinPut extends StatelessWidget {
  /// Trigger when the user fills in all the information
  final Function(String value)? onCompleted;

  /// A controller for an editable text field.
  final TextEditingController controller;

  /// Responsive width and height of the TextField with padding
  final double paddingHorizontal;

  /// Border radius of each pin code field. Default is 5
  final double radius;

  /// You already know what it does I guess. Default is false
  final bool obscureText;

  /// Widget used to obscure text.
  /// It overrides the obscuringCharacter.
  final Widget? obscuringWidget;

  /// Character used for obscuring text if obscureText is true.
  final String obscuringCharacter;

  /// Customize box shadows of the fields
  final List<BoxShadow>? boxShadows;

  /// Returns the current typed text in the fields.
  final void Function(String value) onChanged;

  /// Colors of the input fields which have inputs. Default is [Colors.white]
  final Color? activeFillColor;

  /// Colors of the input fields which don't have inputs. Default is [Colors.white]
  final Color? inactiveColor;

  /// Colors of the input fields which have inputs. Default is [Color(0xffffb41d)]
  final Color? activeColor;

  /// Colors of the input fields which don't have inputs. Default is [Colors.white]
  final Color? inactiveFillColor;

  /// Color of the input field which is currently selected. Default is [Colors.white]
  final Color? selectedFillColor;

  /// Color of the input field which is currently selected. Default is [Color(0xffffb41d)]
  final Color? selectedColor;

  /// The style of the text, default is [ fontSize: 20, fontWeight: FontWeight.bold]
  final TextStyle textStyle;

  /// Border width for the each input fields. Default is [1.0]
  final double? borderWidth;

  /// This defines the shape of the input fields. Default is underlined
  final PinCodeFieldShape? shape;

  ///  [widthPinput] for the pin code field.
  final double? widthPinput;

  /// [heightPinput] for the pin code field.
  final double? heightPinput;

  /// Length of how many cells there should be.
  /// 3{super.key}{super.key}{super.key}{super.key}-8 is recommended by me.
  /// Default is 6
  final int? length;

  /// If the pin code field should be autofocused or not. Default is [false]
  final bool autoFocus;

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
      this.autoFocus = false,
      this.length})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthItem = (width - paddingHorizontal) / 8.3;
    return PinCodeTextField(
      appContext: context,
      length: length ?? 6,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      obscuringWidget: obscuringWidget,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: (v) {
        return null;
      },
      autoFocus: autoFocus,
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
