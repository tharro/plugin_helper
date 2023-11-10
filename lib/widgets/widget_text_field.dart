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
  /// Set label above the TextField.
  final String? label;

  /// A controller for an editable text field.
  final TextEditingController controller;

  /// An icon that appears after the editable part of the text field and after
  /// the [suffix] or [suffixText], within the decoration's container.
  /// [suffixActiveIcon] will show when the user focuses on the TextField.
  /// [suffixDisableIcon] will show when the user unfocuses on the TextField.
  final Widget? suffixActiveIcon, suffixDisableIcon;

  /// An icon that appears before the [prefix] or [prefixText] and before the editable part
  /// of the text field, within the decoration's container.
  final Widget? prefixIcon;

  /// List [TextInputFormatter] can be optionally injected into an [EditableText] to
  /// provide as-you-type validation and formatting of the text being edited.
  final List<TextInputFormatter>? inputFormatters;

  /// The type of information for which to optimize the text input control.
  final TextInputType? keyboardType;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// Trigger when the user clicks the suffix icon
  /// if [suffixActiveIcon] and [suffixDisableIcon] not null.
  final VoidCallback? onSuffixIconTap;

  /// Set a valid type for the input. When the user enters a character,
  /// the TextField automatically checks against that valid type.
  /// The Textfield will automatically show errors corresponding to a valid type.
  final ValidType validType;

  /// This property indicates whether users can enter character.
  final bool enabled;

  /// Trigger when user enters character. Check whether input is valid or not.
  /// If true, valid input.
  /// If false, invalid input.
  /// You use this value to prevent the user from performing further operations until it is valid.
  final Function(bool)? onValid;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  final TextCapitalization textCapitalization;

  /// Set hint text for the TextField.
  final String? hintText;

  /// Limit the length of the text field.
  final int? maxLength;

  /// You can set an error message when the default message doesn't like what you want.
  /// It needs to be combined with the [onValid] function before setting a value for it.
  final String? textError;

  /// A callback to be called when user taps on the TextField.
  final VoidCallback? onTap;

  /// The padding for the input decoration's container.
  final EdgeInsets? contentPadding;

  /// The maximum number of lines to show at one time.
  final int? maxLines;

  /// The minimum number of lines to show at one time.
  final int? minLines;

  /// An object that can be used by a stateful widget to obtain the keyboard
  /// focus and to handle keyboard events.
  final FocusNode? focus;

  /// Trigger when the user clicks the submit button on the keyboard.
  final Function(String)? onFieldSubmitted;

  /// An action the user has requested the text input control to perform.
  final TextInputAction? textInputAction;

  /// Defines minimum and maximum sizes for the [InputDecorator].
  final BoxConstraints? constraints;

  /// If the textfield type [ValidType] is password,
  /// you can choose the secure type for the password. Default is [PasswordValidType.atLeast8Characters]
  final PasswordValidType passwordValidType;

  /// The style of the text field.
  final TextStyle textStyle;

  /// The style of the label.
  final TextStyle labelStyle;

  /// The style of the error text.
  final TextStyle errorStyle;

  /// The style of the counter text.
  final TextStyle? textStyleCounter;

  /// The style of the hint text.
  final TextStyle? textStyleHint;

  /// The border to display when the [InputDecorator] does not have the focus and is showing an error.
  final InputBorder? errorBorder;

  /// The shape of the border to draw around the decoration's container.
  final InputBorder? border;

  /// The border to display when the [InputDecorator] has the focus and is not showing an error.
  final InputBorder? focusBorder;

  /// The border to display when the [InputDecorator] is disabled and is not showing an error.
  final InputBorder? disabledBorder;

  /// A callback to be called when the user focuses on the text field.
  final Function? onListenFocus;

  /// A callback to be called whenever the text changes.
  final Function? onListenController;

  /// This property indicates whether an error message is displayed or not.
  final bool? showError;

  /// Set margins for prefix icon when [prefixIcon] is not null.
  final double? paddingLeftPrefixIcon,
      paddingRightPrefixIcon,
      paddingLeftSuffixIcon,
      paddingRightSuffixIcon;

  /// Border radius of the text field.
  final double? borderRadius;

  /// Space between the [label] and [TextField] when the [TextFieldType] is `normal` and label is not null.
  final double? spaceBetweenLabelAndTextField;

  /// Type of the text field.
  final TextFieldType? textFieldType;

  /// Set border color of the text field.
  final Color? borderColor,
      focusBorderColor,
      errorBorderColor,
      fillColor,
      disabledBorderColor;

  final Widget? customLabelOfTextFieldNormal, prefixIconLabel;

  /// Customize widget for the text field when [ValidType] is `password`.
  final Widget eyeActiveIcon, eyeDisableIcon;

  /// Auto-focus the TextField.
  final bool autoFocus;

  /// Custom validation logic for password text field.
  final bool Function()? isValidCustomPassword;

  /// Custom validation logic for empty text field.
  final bool Function()? isValidNotEmpty;

  /// Alignment password icon in the text field. Only for [ValidType] is `password`.
  final AlignmentPasswordIcon alignmentPasswordIcon;

  /// Describes the contrast of a theme or color palette when the keyboard appears.
  final Brightness? keyboardAppearance;

  /// Customize a decoration for the text field.
  final Decoration? boxDecorationTextField;

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
    this.prefixIconLabel,
    this.boxDecorationTextField,
  }) : super(key: key);

  @override
  _WidgetTextFieldState createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<MyWidgetTextField> {
  bool _hasFocus = false;
  bool _valid = false;
  bool _hasChanged = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.focus != null) {
      widget.focus!.addListener(() {
        if (widget.onListenFocus != null) {
          widget.onListenFocus!();
        }

        if (widget.focus!.hasFocus != _hasFocus) {
          if (!mounted) return;
          setState(() {
            _hasFocus = widget.focus!.hasFocus;
          });
        }
      });
    }
    if (widget.controller.text.isNotEmpty) {
      _hasChanged = true;
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
          if (widget.controller.text.trim().isNotEmpty) {
            setValid();
          } else {
            setInValid();
          }
        }
        break;
      case ValidType.fullName:
        if (MyPluginHelper.isValidFullName(
            text: widget.controller.text.trim())) {
          setValid();
        } else {
          setInValid();
        }
        break;
      case ValidType.cardNumber:
        if (widget.controller.text.isEmpty ||
            widget.controller.text.length < 16) {
          setInValid();
          break;
        }
        setValid();
        break;
      case ValidType.expired:
        if (widget.controller.text.isEmpty) {
          setInValid();
          return;
        }

        final DateTime now = DateTime.now();
        if (widget.controller.text.length == 5) {
          final List<String> date = widget.controller.text.split(RegExp(r'/'));
          final int month = int.parse(date.first);
          final int year = int.parse('20${date.last}');
          final DateTime cardDate = DateTime(year, month);

          if (cardDate.isBefore(now) || month > 12 || month == 0) {
            setInValid();
            break;
          }

          setValid();
          break;
        }

        setInValid();
        break;
      case ValidType.cvv:
        if (widget.controller.text.isEmpty ||
            widget.controller.text.length < 3) {
          setInValid();
          break;
        }
        setValid();
        break;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    if (widget.onListenController != null) {
      widget.onListenController!();
    }
    if (_hasChanged == false && widget.controller.text.isNotEmpty) {
      if (!mounted) return;
      _hasChanged = true;
      setState(() {});
    }
  }

  setValid() {
    if (!mounted) return;
    _valid = true;
    setState(() {});
    if (widget.onValid != null) {
      widget.onValid!(_valid);
    }
  }

  setInValid() {
    if (!mounted) return;
    _valid = false;
    setState(() {});
    if (widget.onValid != null) {
      widget.onValid!(_valid);
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
          color: widget.disabledBorderColor ?? Colors.grey[400]!,
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
                if (widget.prefixIconLabel != null) widget.prefixIconLabel!,
                Text(
                  widget.label!,
                  style: widget.labelStyle,
                ),
                if (widget.customLabelOfTextFieldNormal != null)
                  widget.customLabelOfTextFieldNormal!,
              ],
            ),
          ),
        Container(
          decoration: widget.boxDecorationTextField,
          child: TextFormField(
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
              counter: widget.maxLength != null && _hasFocus
                  ? Text(
                      "${widget.controller.text.characters.length} /${widget.maxLength}",
                      style: widget.textStyleCounter ??
                          const TextStyle(fontSize: 13))
                  : null,
              errorMaxLines: 3,
              labelStyle: widget.textFieldType == TextFieldType.animation
                  ? widget.labelStyle
                  : null,
              errorText:
                  ((!_valid && _hasChanged) || widget.textError != null) &&
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
                      if (!mounted) return;
                      setState(() {
                        _obscureText = !_obscureText;
                      });
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
    if (_hasFocus) {
      return widget.suffixActiveIcon!;
    } else {
      return widget.suffixDisableIcon!;
    }
  }
}
