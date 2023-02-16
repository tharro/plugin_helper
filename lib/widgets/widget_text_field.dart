import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_helper/index.dart';

enum ValidType {
  none,
  password,
  email,
  fullName,
  notEmpty,
  cardNumber,
  expired,
  cvv,
}

enum TextFieldType { normal, animation }

enum AlignmentPasswordIcon { left, right }

class MyWidgetTextField extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final Widget? suffixActiveIcon, suffixDisableIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final ValidType validType;
  final bool enabled;
  final Function(bool)? onValid;
  final TextCapitalization textCapitalization;
  final String? hintText;
  final int? maxLength;
  final String? textError;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focus;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final BoxConstraints? constraints;
  final PasswordValidType passwordValidType;
  final TextStyle textStyle, labelStyle, errorStyle;
  final TextStyle? textStyleCounter, textStyleHint;
  final InputBorder? errorBorder, border, focusBorder, disabledBorder;
  final Function? onListenFocus, onListenController;
  final bool? showError;
  final double? paddingLeftPrefixIcon,
      paddingRightPrefixIcon,
      paddingLeftSuffixIcon,
      paddingRightSuffixIcon,
      borderRadius,
      spaceBetweenLabelAndTextField;
  final TextFieldType? textFieldType;
  final Color? borderColor,
      focusBorderColor,
      errorBorderColor,
      fillColor,
      disabledBorderColor;
  final Widget? customLabelOfTextFieldNormal;
  final Widget eyeActiveIcon, eyeDisableIcon;
  final bool autoFocus;
  final bool Function()? isValidCustomPassword;
  final bool Function()? isValidNotEmpty;
  final AlignmentPasswordIcon alignmentPasswordIcon;
  final Brightness? keyboardAppearance;
  const MyWidgetTextField({
    Key? key,
    this.prefixIcon,
    this.label,
    this.onSuffixIconTap,
    this.inputFormatters,
    required this.controller,
    this.suffixActiveIcon,
    this.suffixDisableIcon,
    this.keyboardType,
    this.validType = ValidType.none,
    this.obscureText = false,
    this.enabled = true,
    this.onValid,
    this.hintText,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textError,
    this.onTap,
    this.contentPadding,
    this.maxLines = 1,
    this.minLines,
    required this.focus,
    this.onFieldSubmitted,
    this.textInputAction,
    this.constraints,
    this.passwordValidType = PasswordValidType.atLeast8Characters,
    required this.textStyle,
    this.textStyleCounter,
    required this.labelStyle,
    this.errorBorder,
    this.border,
    this.focusBorder,
    required this.errorStyle,
    this.onListenFocus,
    this.onListenController,
    this.showError = true,
    this.paddingLeftPrefixIcon = 15,
    this.paddingRightPrefixIcon = 11,
    this.paddingLeftSuffixIcon = 15,
    this.paddingRightSuffixIcon = 11,
    this.borderRadius = 4,
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.textFieldType = TextFieldType.normal,
    this.spaceBetweenLabelAndTextField = 8,
    this.customLabelOfTextFieldNormal,
    required this.eyeActiveIcon,
    required this.eyeDisableIcon,
    this.autoFocus = false,
    this.fillColor = Colors.transparent,
    this.textStyleHint,
    this.isValidCustomPassword,
    this.isValidNotEmpty,
    this.alignmentPasswordIcon = AlignmentPasswordIcon.right,
    this.disabledBorder,
    this.disabledBorderColor,
    this.keyboardAppearance,
  }) : super(key: key);

  @override
  _WidgetTextFieldState createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<MyWidgetTextField> {
  bool hasFocus = false;
  bool valid = false;
  bool hasChanged = false;
  late bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    if (widget.focus != null) {
      widget.focus!.addListener(() {
        if (widget.onListenFocus != null) {
          widget.onListenFocus!();
        }

        if (widget.focus!.hasFocus != hasFocus) {
          if (mounted) {
            setState(() {
              hasFocus = widget.focus!.hasFocus;
            });
          }
        }
      });
    }
    if (widget.controller.text.isNotEmpty) {
      hasChanged = true;
    }
    checkValidate();
    widget.controller.addListener(checkValidate);
  }

  checkValidate() async {
    await Future.delayed(const Duration(milliseconds: 100));
    switch (widget.validType) {
      case ValidType.none:
        setValid();
        break;
      case ValidType.password:
        if (widget.isValidCustomPassword != null) {
          if (widget.isValidCustomPassword!()) {
            setValid();
          } else {
            setInValid();
          }
        } else {
          if (MyPluginHelper.isValidPassword(
              password: widget.controller.text,
              passwordValidType: widget.passwordValidType)) {
            setValid();
          } else {
            setInValid();
          }
        }

        break;
      case ValidType.email:
        if (MyPluginHelper.isValidateEmail(email: widget.controller.text)) {
          setValid();
        } else {
          setInValid();
        }
        break;
      case ValidType.notEmpty:
        if (widget.isValidNotEmpty != null) {
          if (widget.isValidNotEmpty!()) {
            setValid();
          } else {
            setInValid();
          }
        } else {
          if (widget.controller.text.isNotEmpty) {
            setValid();
          } else {
            setInValid();
          }
        }
        break;
      case ValidType.fullName:
        if (MyPluginHelper.isValidFullName(text: widget.controller.text)) {
          setValid();
        } else {
          setInValid();
        }
        break;
      case ValidType.cardNumber:
        if (widget.controller.text.isEmpty ||
            widget.controller.text.length < 16) {
          setInValid();
          return;
        }
        setValid();
        break;
      case ValidType.expired:
        if (widget.controller.text.isEmpty) {
          setInValid();
          return;
        }

        final DateTime now = DateTime.now();
        final List<String> date = widget.controller.text.split(RegExp(r'/'));
        final int month = int.parse(date.first);
        final int year = int.parse('20${date.last}');
        final DateTime cardDate = DateTime(year, month);

        if (cardDate.isBefore(now) || month > 12 || month == 0) {
          setInValid();
          return;
        }

        setValid();
        break;
      case ValidType.cvv:
        if (widget.controller.text.isEmpty ||
            widget.controller.text.length < 3) {
          setInValid();
          return;
        }
        setValid();
        break;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (widget.onListenController != null) {
      widget.onListenController!();
    }
    if (hasChanged == false && widget.controller.text.isNotEmpty) {
      if (mounted) {
        setState(() {
          hasChanged = true;
        });
      }
    }
  }

  setValid() {
    if (mounted) {
      if (!valid) {
        setState(() {
          valid = true;
        });
        if (widget.onValid != null) {
          widget.onValid!(valid);
        }
      }
    }
  }

  setInValid() {
    if (mounted) {
      if (valid) {
        setState(() {
          valid = false;
        });
        if (widget.onValid != null) {
          widget.onValid!(valid);
        }
      }
    }
  }

  String getError() {
    if (widget.textError != null) {
      return '${widget.textError}';
    }
    switch (widget.validType) {
      case ValidType.none:
        return '';
      case ValidType.password:
        if (widget.passwordValidType == PasswordValidType.notEmpty) {
          return MyPluginMessageRequire.canNotEmpty;
        }
        return MyPluginMessageRequire.weakPassword;
      case ValidType.email:
        return MyPluginMessageRequire.invalidEmail;
      case ValidType.notEmpty:
        return MyPluginMessageRequire.canNotEmpty;
      case ValidType.fullName:
        return MyPluginMessageRequire.requiredFullName;
      case ValidType.cardNumber:
        return MyPluginMessageRequire.invalidCardNumber;
      case ValidType.expired:
        return MyPluginMessageRequire.invalidExpired;
      case ValidType.cvv:
        return MyPluginMessageRequire.invalidCvv;
      default:
        return '';
    }
  }

  OutlineInputBorder get errorBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        borderSide: BorderSide(
          color: widget.errorBorderColor ?? Colors.red[400]!,
        ),
      );
  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        borderSide: BorderSide(
          color: widget.borderColor ?? Colors.grey[400]!,
        ),
      );
  OutlineInputBorder get focusBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        borderSide: BorderSide(
          color: widget.focusBorderColor ?? Colors.green,
        ),
      );
  OutlineInputBorder get disableBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        borderSide: BorderSide(
          color: widget.disabledBorderColor ?? Colors.green,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.textFieldType == TextFieldType.normal &&
            widget.label != null)
          Padding(
            padding:
                EdgeInsets.only(bottom: widget.spaceBetweenLabelAndTextField!),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: widget.labelStyle,
                ),
                if (widget.customLabelOfTextFieldNormal != null)
                  widget.customLabelOfTextFieldNormal!,
              ],
            ),
          ),
        TextFormField(
          autofocus: widget.autoFocus,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focus,
          textCapitalization: widget.textCapitalization,
          enabled: widget.enabled,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: widget.validType == ValidType.password
              ? _obscureText
              : widget.obscureText,
          inputFormatters: widget.inputFormatters,
          style: widget.textStyle,
          scrollPadding: EdgeInsets.zero,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
          textAlignVertical: TextAlignVertical.center,
          keyboardAppearance: widget.keyboardAppearance,
          decoration: InputDecoration(
            isDense: true,
            constraints: widget.constraints,
            hintText: widget.hintText,
            hintStyle: widget.textStyleHint,
            counter: widget.maxLength != null && hasFocus
                ? Text(
                    "${widget.controller.text.characters.length} /${widget.maxLength}",
                    style: widget.textStyleCounter ??
                        const TextStyle(fontSize: 13))
                : null,
            errorMaxLines: 2,
            labelStyle: widget.textFieldType == TextFieldType.animation
                ? widget.labelStyle
                : null,
            errorText: ((!valid && hasChanged) || widget.textError != null) &&
                    widget.showError!
                ? getError()
                : null,
            errorBorder: widget.errorBorder ?? errorBorder,
            focusedErrorBorder: widget.errorBorder ?? errorBorder,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            border: widget.border ?? border,
            enabledBorder: widget.border ?? border,
            focusedBorder: widget.focusBorder ?? focusBorder,
            labelText: widget.textFieldType == TextFieldType.animation
                ? widget.label
                : null,
            counterText: '',
            fillColor: widget.fillColor,
            filled: true,
            disabledBorder: widget.disabledBorder ?? disableBorder,
            errorStyle: widget.errorStyle,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: widget.validType == ValidType.password &&
                    widget.alignmentPasswordIcon == AlignmentPasswordIcon.left
                ? _suffixIcon
                : widget.prefixIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: widget.paddingLeftPrefixIcon!,
                            right: widget.paddingRightPrefixIcon!),
                        child: widget.prefixIcon,
                      )
                    : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.validType == ValidType.password &&
                    widget.alignmentPasswordIcon == AlignmentPasswordIcon.left
                ? null
                : _suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget? get _suffixIcon {
    return (widget.validType != ValidType.password &&
            widget.suffixDisableIcon == null &&
            widget.suffixDisableIcon == null)
        ? null
        : Padding(
            padding: EdgeInsets.only(
                left: widget.paddingLeftSuffixIcon!,
                right: widget.paddingRightSuffixIcon!),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.validType == ValidType.password) {
                      if (mounted) {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }
                    }
                    if (widget.onSuffixIconTap != null) {
                      widget.onSuffixIconTap!();
                    }
                  },
                  child: _checkIcon(),
                ),
              ],
            ),
          );
  }

  Widget _checkIcon() {
    if (widget.validType == ValidType.password) {
      if (_obscureText) {
        return widget.eyeActiveIcon;
      } else {
        return widget.eyeDisableIcon;
      }
    }
    if (hasFocus) {
      return widget.suffixActiveIcon!;
    } else {
      return widget.suffixDisableIcon!;
    }
  }
}
