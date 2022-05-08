// import '../../configs/app_text_styles.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';
// import 'package:plugin_helper/widgets/phone_number/widget_phone_number.dart';

// class PhoneNumberCustom extends StatefulWidget {
//   final bool? autoFocus;
//   final bool? hasError;
//   final PhoneNumber? initialValue;
//   final bool isEnabled;
//   final String? label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final Function? onFieldSubmitted, onInputChanged, onSaved;
//   final Function(bool)? onInputValidated;
//   const PhoneNumberCustom({
//     Key? key,
//     this.autoFocus,
//     this.hasError,
//     this.initialValue,
//     this.isEnabled = true,
//     this.label,
//     this.onFieldSubmitted,
//     this.onInputChanged,
//     this.onInputValidated,
//     this.onSaved,
//     required this.controller,
//     required this.focusNode,
//   }) : super(key: key);

//   @override
//   State<PhoneNumberCustom> createState() => _PhoneNumberCustomState();
// }

// class _PhoneNumberCustomState extends State<PhoneNumberCustom> {
//   @override
//   Widget build(BuildContext context) {
//     return MyWidgetPhoneNumber(
//       autoFocus: widget.autoFocus,
//       hasError: widget.hasError,
//       initialValue: widget.initialValue,
//       isEnabled: widget.isEnabled,
//       label: widget.label,
//       onFieldSubmitted: widget.onFieldSubmitted,
//       onInputChanged: widget.onInputChanged,
//       onInputValidated: widget.onInputValidated,
//       onSaved: widget.onSaved,
//       controller: widget.controller,
//       focusNode: widget.focusNode,
//       paddingIconRight: 25,
//       isLTR: EasyLocalization.of(context)!.currentLocale!.languageCode != 'ar',
//       textStyle: AppTextStyles.textSize12(),
//       locale: EasyLocalization.of(context)!.currentLocale!.languageCode,
//       boxDecorationPhoneNumber: const BoxDecoration(),
//       spaceBetweenSelectorAndTextField: 0,
//       iconCorrect: Icon(Icons.check, color: Colors.green[400]),
//       iconError: const Icon(Icons.error, color: Colors.red, size: 22),
//       selectorConfig: const SelectorConfig(
//           selectorType: PhoneInputSelectorType.DIALOG,
//           showFlags: true,
//           boxDecoration: BoxDecoration(),
//           trailingSpace: false),
//     );
//   }
// }
