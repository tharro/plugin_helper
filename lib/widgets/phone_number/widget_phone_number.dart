import 'package:flutter/material.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';

class MyWidgetPhoneNumber extends StatefulWidget {
  final String? label;
  final String? labelSearch;
  final TextEditingController? controller;
  final PhoneNumber? initialValue;
  final bool isEnabled;
  final Function(PhoneNumber)? onInputChanged;
  final Function(bool)? onInputValidated;
  final Function()? onFieldSubmitted;
  final Function(PhoneNumber)? onSaved;
  final bool autoFocus;
  final FocusNode? focusNode;
  final bool? hasError;
  final List<String>? countries;
  final bool isLTR;
  final Widget? iconError, iconCorrect;
  final TextStyle textStyle, labelStyle, hintStyle, selectorTextStyle;
  final String locale;
  final EdgeInsets? padding, contentPaddingInputPhoneNumber;
  final double height;
  final String hintText;
  final SelectorConfig selectorConfig;
  final BoxDecoration? boxDecorationPhoneNumber;
  final BoxDecoration? boxDecorationAll;
  final double spaceBetweenSelectorAndTextField;
  final double paddingIconRight, spaceBetweenLabelAndPhoneNumber;
  const MyWidgetPhoneNumber(
      {Key? key,
      this.label,
      this.controller,
      this.initialValue,
      this.isEnabled = true,
      this.onInputChanged,
      this.onInputValidated,
      this.onFieldSubmitted,
      this.onSaved,
      this.autoFocus = false,
      this.focusNode,
      this.hasError = false,
      this.countries,
      this.isLTR = true,
      this.iconError,
      this.iconCorrect,
      required this.textStyle,
      required this.locale,
      this.padding,
      this.selectorConfig = const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      this.boxDecorationPhoneNumber,
      this.boxDecorationAll,
      this.spaceBetweenSelectorAndTextField = 12,
      this.paddingIconRight = 25,
      this.labelSearch,
      this.spaceBetweenLabelAndPhoneNumber = 8,
      this.hintText = '',
      required this.labelStyle,
      required this.hintStyle,
      required this.selectorTextStyle,
      this.contentPaddingInputPhoneNumber,
      this.height = 44})
      : super(key: key);
  @override
  _WidgetPhoneNumberState createState() => _WidgetPhoneNumberState();
}

class _WidgetPhoneNumberState extends State<MyWidgetPhoneNumber> {
  bool _showIcon = false;
  bool _hasFocus = false;
  bool _isValidate = true;
  @override
  void initState() {
    widget.controller!.addListener(() {
      if (widget.controller!.text != '') {
        if (mounted) {
          setState(() {
            _showIcon = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _showIcon = false;
          });
        }
      }
    });
    widget.focusNode!.addListener(() {
      if (mounted) {
        setState(() {
          _hasFocus = widget.focusNode!.hasFocus;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLTR = widget.isLTR;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: widget.labelStyle,
          ),
        SizedBox(
          height: widget.spaceBetweenLabelAndPhoneNumber,
        ),
        Stack(
          children: [
            Container(
              decoration: widget.boxDecorationAll ??
                  BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: _hasFocus
                            ? const Color(0xffFEC02D)
                            : const Color(0xffdddddd)),
                    borderRadius: BorderRadius.circular(34),
                  ),
              height: widget.height,
              padding: widget.padding ?? EdgeInsets.zero,
              child: InternationalPhoneNumberInput(
                countries: widget.countries,
                initialValue: widget.initialValue ??
                    PhoneNumber(isoCode: 'AU', dialCode: '+61'),
                searchBoxDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    labelText: widget.labelSearch,
                    labelStyle: widget.labelStyle),
                onInputChanged: (PhoneNumber number) {
                  if (widget.onInputChanged != null) {
                    widget.onInputChanged!(number);
                  }
                },
                focusNode: widget.focusNode,
                onInputValidated: (bool value) {
                  setState(() {
                    _isValidate = value;
                  });
                  if (widget.onInputValidated != null) {
                    widget.onInputValidated!(value);
                  }
                },
                cursorColor: Colors.black,
                spaceBetweenSelectorAndTextField:
                    widget.spaceBetweenSelectorAndTextField,
                textAlignVertical: TextAlignVertical.top,
                selectorConfig: widget.selectorConfig,
                ignoreBlank: true,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: widget.selectorTextStyle,
                textFieldController: widget.controller,
                textStyle: widget.textStyle,
                locale: widget.locale,
                isEnabled: widget.isEnabled,
                inputDecoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: widget.contentPaddingInputPhoneNumber,
                ),
                onFieldSubmitted: (text) {
                  if (widget.onFieldSubmitted != null) {
                    widget.onFieldSubmitted!();
                  }
                },
                autoFocus: widget.autoFocus,
                formatInput: false,
                keyboardType: TextInputType.number,
                inputBorder: const OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  if (widget.onSaved != null) {
                    widget.onSaved!(number);
                  }
                },
                isLTR: isLTR,
                boxDecorationPhoneNumber: widget.boxDecorationPhoneNumber,
              ),
            ),
            if (_showIcon)
              PositionedDirectional(
                end: widget.paddingIconRight,
                bottom: 0,
                top: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _isValidate ? widget.iconCorrect : widget.iconError,
                ),
              )
          ],
        ),
      ],
    );
  }
}
