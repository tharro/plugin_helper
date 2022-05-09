// import '../../blocs/auth/auth_bloc.dart';
// import '../../configs/app_constrains.dart';
// import '../../screens/auth/get_started.dart';
// import '../../utils/helper.dart';
// import '../../widgets/button_custom.dart';
// import '../../widgets/overlay_loading_custom.dart';
// import '../../widgets/pin_put_custom.dart';
// import '../../widgets/text_field_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:plugin_helper/plugin_navigator.dart';
// import 'package:plugin_helper/widgets/widget_text_field.dart';

// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({Key? key}) : super(key: key);

//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _passwordFocusNode = FocusNode();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final FocusNode _confirmPasswordFocusNode = FocusNode();
//   final TextEditingController _codeController = TextEditingController();
//   bool _obscureText = true, _obscureTextConfirm = true;
//   String? _errorConfirmPassword;
//   _submit() {
//     if (_codeController.text.length == 6 &&
//         _passwordController.text == _confirmPasswordController.text) {
//       BlocProvider.of<AuthBloc>(context).add(AuthResetPassword(
//           code: _codeController.text,
//           password: _passwordController.text,
//           onError: (code, message) {
//             Helper.showErrorDialog(
//                 context: context,
//                 message: message,
//                 onPressPrimaryButton: () {
//                   Navigator.pop(context);
//                 },
//                 code: code);
//           },
//           onSuccess: () {
//             //TODO: go to home
//           },
//           userName: BlocProvider.of<AuthBloc>(context)
//               .state
//               .getStartedModel!
//               .userId!));
//     }
//   }

//   _resendCode() {
//     BlocProvider.of<AuthBloc>(context).add(AuthForgotPassword(
//         userName:
//             BlocProvider.of<AuthBloc>(context).state.getStartedModel!.userId!,
//         onError: (code, message) {
//           Helper.showErrorDialog(
//               context: context,
//               message: message,
//               code: code,
//               onPressPrimaryButton: () {
//                 Navigator.pop(context);
//               });
//         },
//         onSuccess: () {
//           Helper.showSuccessDialog(
//               context: context,
//               message: 'key_resend_code_success'.tr(),
//               onPressPrimaryButton: () {
//                 Navigator.pop(context);
//               });
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
//       return OverlayLoadingCustom(
//           isLoading: state.resetPasswordLoading!,
//           child: Scaffold(
//               bottomNavigationBar: Padding(
//                 padding: EdgeInsets.only(
//                     bottom: AppConstrains.paddingVertical,
//                     left: AppConstrains.paddingHorizontal,
//                     right: AppConstrains.paddingHorizontal,
//                     top: 5),
//                 child: ButtonCustom(
//                   onPressed: () {
//                     _submit();
//                   },
//                   title: 'key_reset_password'.tr(),
//                 ),
//               ),
//               body: SingleChildScrollView(
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: AppConstrains.paddingVertical,
//                           horizontal: AppConstrains.paddingHorizontal),
//                       child: Column(
//                         children: [
//                           PinPutCustom(
//                             controller: _codeController,
//                             onChange: (val) {},
//                             onCompleted: (code) {},
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFieldCustom(
//                             controller: _passwordController,
//                             focusNode: _passwordFocusNode,
//                             validType: ValidType.password,
//                             hintText: 'key_password'.tr(),
//                             obscureText: _obscureText,
//                             maxLines: 1,
//                             suffixIcon: Icon(
//                               Icons.remove_red_eye,
//                               color: _obscureText
//                                   ? Colors.grey[400]
//                                   : Colors.yellow,
//                             ),
//                             onSuffixIconTap: () {
//                               setState(() {
//                                 _obscureText = !_obscureText;
//                               });
//                             },
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFieldCustom(
//                             controller: _confirmPasswordController,
//                             focusNode: _confirmPasswordFocusNode,
//                             validType: ValidType.password,
//                             hintText: 'key_confirm_password'.tr(),
//                             obscureText: _obscureTextConfirm,
//                             maxLines: 1,
//                             textError: _errorConfirmPassword,
//                             suffixIcon: Icon(
//                               Icons.remove_red_eye,
//                               color: _obscureTextConfirm
//                                   ? Colors.grey[400]
//                                   : Colors.yellow,
//                             ),
//                             onSuffixIconTap: () {
//                               setState(() {
//                                 _obscureTextConfirm = !_obscureTextConfirm;
//                               });
//                             },
//                             onChanged: (String pass) {
//                               if (pass != _passwordController.text) {
//                                 setState(() {
//                                   _errorConfirmPassword =
//                                       'key_confirm_password_not_match'.tr();
//                                 });
//                               } else {
//                                 setState(() {
//                                   _errorConfirmPassword = null;
//                                 });
//                               }
//                             },
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 MyPluginNavigation.instance
//                                     .replace(const GetStarted());
//                               },
//                               child: Text('key_use_another_account'.tr())),
//                           GestureDetector(
//                               onTap: () {
//                                 _resendCode();
//                               },
//                               child: Text('key_resend_code'.tr())),
//                         ],
//                       )))));
//     });
//   }
// }
