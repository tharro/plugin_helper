import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_helper/plugin_helper.dart';
import 'package:plugin_helper/plugin_message_require.dart';

enum ValidType { none, password, email, notEmpty }

class WidgetTextField extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool showSuffix;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final ValidType validType;
  final bool enabled;
  final Function(bool)? onValid;
  final TextCapitalization textCapitalization;
  final String Function(String?)? validator;
  final String? hintText;
  final Color? colorDisable;
  final int? maxLength;
  final String? textError;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;
  final double textSize;
  final int? maxLines;
  final int? minLines;
  final FocusNode focus;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final int? maxCounter;
  final BoxConstraints? constraints;
  final PasswordValidType passwordValidType;
  final TextStyle textStyle, labelStyle, errorStyle;
  final TextStyle? textStyleCounter;
  final InputBorder? errorBorder, border, focusBorder;
  final Color? focusColor;

  const WidgetTextField({
    Key? key,
    this.prefix,
    this.prefixIcon,
    this.label,
    this.onSuffixIconTap,
    this.inputFormatters,
    required this.controller,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.validType = ValidType.none,
    this.showSuffix = true,
    this.obscureText = false,
    this.enabled = true,
    this.onValid,
    this.validator,
    this.hintText,
    this.colorDisable,
    this.maxLength,
    this.width,
    this.textCapitalization = TextCapitalization.none,
    this.textError,
    this.onTap,
    this.contentPadding,
    this.textSize = 17,
    this.maxLines = 1,
    this.minLines,
    required this.focus,
    this.onFieldSubmitted,
    this.textInputAction,
    this.maxCounter,
    this.constraints,
    this.passwordValidType = PasswordValidType.atLeast8Characters,
    required this.textStyle,
    this.textStyleCounter,
    required this.labelStyle,
    this.errorBorder,
    this.border,
    this.focusBorder,
    required this.errorStyle,
    this.focusColor,
  }) : super(key: key);

  @override
  _WidgetTextFieldState createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  bool hasFocus = false;
  bool valid = false;
  @override
  void initState() {
    super.initState();
    widget.focus.addListener(() {
      if (widget.focus.hasFocus) {
        setState(() {
          hasFocus = true;
        });
      } else {
        setState(() {
          hasFocus = false;
        });
      }
    });
    checkValidate();
    widget.controller.addListener(checkValidate);
  }

  checkValidate() {
    switch (widget.validType) {
      case ValidType.none:
        setInValid();
        break;
      case ValidType.password:
        if (PluginHelper.isValidPassword(
            password: widget.controller.text,
            passwordValidType: widget.passwordValidType)) {
          setValid();
        } else {
          setInValid();
        }
        break;
      case ValidType.email:
        if (PluginHelper.isValidateEmail(email: widget.controller.text)) {
          setValid();
        } else {
          setInValid();
        }
        break;
      case ValidType.notEmpty:
        if (widget.controller.text.isNotEmpty) {
          setValid();
        } else {
          setInValid();
        }
    }
  }

  setValid() {
    if (mounted) {
      if (!valid) {
        setState(() {
          valid = true;
        });
      }
    }
  }

  setInValid() {
    if (mounted) {
      if (valid) {
        setState(() {
          valid = false;
        });
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
        return PluginMessageRequire.messWeakPassword;
      case ValidType.email:
        return PluginMessageRequire.messInvalidEmail;
      case ValidType.notEmpty:
        return PluginMessageRequire.messCanNotEmpty;
    }
  }

  OutlineInputBorder errorBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red[400]!,
        ),
      );
  OutlineInputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.grey[400]!,
        ),
      );
  OutlineInputBorder focusBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Colors.yellow,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      focusNode: widget.focus,
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled,
      onTap: widget.onTap,
      onChanged: (value) {
        checkValidate();
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        if (widget.onValid != null) {
          widget.onValid!(valid);
        }
      },
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      style: widget.textStyle,
      scrollPadding: EdgeInsets.zero,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        constraints: widget.constraints,
        hintText: widget.hintText,
        counter: widget.maxLength != null && hasFocus
            ? Text(
                "${widget.controller.text.characters.length} /${widget.maxLength}",
                style: widget.textStyleCounter ?? const TextStyle(fontSize: 13))
            : null,
        errorMaxLines: 2,
        labelStyle: widget.labelStyle,
        errorText: ((!valid && widget.controller.text.isNotEmpty) ||
                widget.textError != null)
            ? getError()
            : null,
        errorBorder: widget.errorBorder ?? errorBorder(),
        focusedErrorBorder: widget.errorBorder ?? errorBorder(),
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
        border: widget.border ?? border(),
        enabledBorder: widget.border ?? border(),
        focusedBorder: widget.focusBorder ?? focusBorder(),
        labelText: widget.label,
        counterText: '',
        focusColor: widget.focusColor ?? Colors.yellow,
        errorStyle: widget.errorStyle,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.suffixIcon != null)
                      GestureDetector(
                        onTap: widget.onSuffixIconTap,
                        child: widget.suffixIcon,
                      ),
                    if (widget.validType != ValidType.none &&
                        widget.suffixIcon == null)
                      GestureDetector(
                        onTap: widget.onSuffixIconTap,
                        child: valid ? const Icon(Icons.check) : Container(),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
