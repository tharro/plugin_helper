// import '../../blocs/auth/auth_bloc.dart';
// import '../../configs/app_constrains.dart';
// import '../../screens/auth/forgot_password.dart';
// import '../../screens/auth/get_started.dart';
// import '../../utils/helper.dart';
// import '../../widgets/button_custom.dart';
// import '../../widgets/overlay_loading_custom.dart';
// import '../../widgets/text_field_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:plugin_helper/plugin_navigator.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:plugin_helper/widgets/widget_text_field.dart';

// class Login extends StatefulWidget {
//   const Login({Key? key, required this.email}) : super(key: key);
//   final String email;
//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final TextEditingController _emailController = TextEditingController();
//   final FocusNode _emailFocusNode = FocusNode();
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _passwordFocusNode = FocusNode();
//   bool _obscureText = true;
//   _submit() {
//     BlocProvider.of<AuthBloc>(context).add(AuthLogin(
//         onError: (code, message) {
//           Helper.showErrorDialog(
//               context: context,
//               code: code,
//               message: message,
//               onPressPrimaryButton: () {
//                 Navigator.pop(context);
//               });
//         },
//         userName:
//             BlocProvider.of<AuthBloc>(context).state.getStartedModel!.userId!,
//         password: _passwordController.text,
//         onSuccess: () {
//           //TODO: go to home
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
//       return OverlayLoadingCustom(
//           isLoading: state.loginLoading!,
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
//                   title: 'key_login'.tr(),
//                 ),
//               ),
//               body: SingleChildScrollView(
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: AppConstrains.paddingVertical,
//                           horizontal: AppConstrains.paddingHorizontal),
//                       child: Column(
//                         children: [
//                           TextFieldCustom(
//                             controller: _emailController,
//                             focusNode: _emailFocusNode,
//                             validType: ValidType.email,
//                             hintText: widget.email,
//                             enabled: false,
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
//                             showError: false,
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
//                           GestureDetector(
//                               onTap: () {
//                                 MyPluginNavigation.instance
//                                     .replace(const GetStarted());
//                               },
//                               child: Text('key_use_another_account'.tr())),
//                           GestureDetector(
//                               onTap: () {
//                                 BlocProvider.of<AuthBloc>(context).add(
//                                     AuthForgotPassword(
//                                         userName:
//                                             BlocProvider.of<AuthBloc>(context)
//                                                 .state
//                                                 .getStartedModel!
//                                                 .userId!,
//                                         onError: (code, message) {
//                                           Helper.showErrorDialog(
//                                               code: code,
//                                               context: context,
//                                               message: message,
//                                               onPressPrimaryButton: () {
//                                                 Navigator.pop(context);
//                                               });
//                                         },
//                                         onSuccess: () {
//                                           MyPluginNavigation.instance
//                                               .replace(const ForgotPassword());
//                                         }));
//                               },
//                               child: Text('key_forgot_password'.tr())),
//                         ],
//                       )))));
//     });
//   }
// }
