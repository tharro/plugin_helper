import 'package:flutter/material.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';

class WidgetPhoneNumber extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final PhoneNumber? initialValue;
  final bool? isEnabled;
  final Function? onInputChanged;
  final Function? onInputValidated;
  final Function? onFieldSubmitted;
  final Function? onSaved;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final bool? hasError;
  final List<String>? countries;
  final bool isLTR;
  final Widget? iconError, iconCorrect;
  final TextStyle textStyle;
  final String locale;
  final EdgeInsets? padding;
  final SelectorConfig? selectorConfig;
  final BoxDecoration? boxDecorationPhoneNumber;
  final BoxDecoration? boxDecorationAll;
  final double spaceBetweenSelectorAndTextField;
  const WidgetPhoneNumber({
    Key? key,
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
    this.selectorConfig,
    this.boxDecorationPhoneNumber,
    this.boxDecorationAll,
    this.spaceBetweenSelectorAndTextField = 12,
  }) : super(key: key);
  @override
  _WidgetPhoneNumberState createState() => _WidgetPhoneNumberState();
}

class _WidgetPhoneNumberState extends State<WidgetPhoneNumber> {
  bool _showIcon = false;
  bool _hasFocus = false;
  bool _isValidate = true;
  PhoneNumber? _initPhoneNumber;
  @override
  void initState() {
    _initPhoneNumber = widget.initialValue;
    widget.controller!.addListener(() {
      if (widget.controller!.text != '') {
        setState(() {
          _showIcon = true;
        });
      } else {
        setState(() {
          _showIcon = false;
        });
      }
    });
    widget.focusNode!.addListener(() {
      setState(() {
        _hasFocus = widget.focusNode!.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLTR = widget.isLTR;
    return Stack(
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
          padding: widget.padding ?? EdgeInsets.zero,
          child: InternationalPhoneNumberInput(
            countries: widget.countries,
            initialValue:
                _initPhoneNumber ?? PhoneNumber(isoCode: 'AU', dialCode: '+61'),
            searchBoxDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                labelText: widget.label,
                labelStyle: widget.textStyle),
            onInputChanged: (PhoneNumber number) {
              if (_initPhoneNumber?.dialCode != number.dialCode) {
                _initPhoneNumber = number;
              }
              if (widget.onInputChanged != null) {
                if (number.phoneNumber!.replaceAll('${number.dialCode}', '') !=
                    '0') {
                  widget.onInputChanged!(number);
                } else {
                  widget.controller!.text = '';
                }
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
            selectorConfig: widget.selectorConfig ??
                const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
            ignoreBlank: true,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: widget.textStyle,
            textFieldController: widget.controller,
            textStyle: widget.textStyle,
            locale: widget.locale,
            isEnabled: widget.isEnabled!,
            inputDecoration: InputDecoration(
              hintText: '',
              hintStyle: widget.textStyle,
              border: InputBorder.none,
            ),
            onFieldSubmitted: (text) {
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!();
              }
            },
            autoFocus: widget.autoFocus!,
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
            end: 25,
            bottom: 0,
            top: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: _isValidate ? widget.iconCorrect : widget.iconError,
            ),
          )
      ],
    );
  }
}
