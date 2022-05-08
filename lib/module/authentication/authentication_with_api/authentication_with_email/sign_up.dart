// import '../../blocs/auth/auth_bloc.dart';
// import '../../configs/app_constrains.dart';
// import '../../screens/auth/get_started.dart';
// import '../../screens/auth/verify.dart';
// import '../../utils/helper.dart';
// import '../../widgets/button_custom.dart';
// import '../../widgets/overlay_loading_custom.dart';
// import '../../widgets/text_field_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:plugin_helper/plugin_helper.dart';
// import 'package:plugin_helper/plugin_navigator.dart';
// import 'package:plugin_helper/widgets/widget_text_field.dart';
// import 'package:easy_localization/easy_localization.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key, required this.email}) : super(key: key);
//   final String email;
//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final TextEditingController _emailController = TextEditingController();
//   final FocusNode _emailFocusNode = FocusNode();
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _passwordFocusNode = FocusNode();
//   final TextEditingController _firstNameController = TextEditingController();
//   final FocusNode _firstNameFocusNode = FocusNode();
//   final TextEditingController _lastNameController = TextEditingController();
//   final FocusNode _lastNameFocusNode = FocusNode();
//   bool _obscureText = true;
//   bool _isValidPassword = false,
//       _isValidFirstName = false,
//       _isValidLastName = false;

//   _submit() {
//     if (!_isValidPassword || !_isValidFirstName || !_isValidLastName) {
//       return;
//     }
//     List<AttributeArg> attr = [
//       AttributeArg(name: 'email', value: widget.email),
//       AttributeArg(
//           name: 'name',
//           value: _firstNameController.text + ' ' + _lastNameController.text),
//     ];
//     BlocProvider.of<AuthBloc>(context).add(AuthSignUp(
//         onError: (code, message) {
//           Helper.showErrorDialog(
//               code: code,
//               context: context,
//               message: message,
//               onPressPrimaryButton: () {
//                 Navigator.pop(context);
//               });
//         },
//         body: {
//           'id':
//               BlocProvider.of<AuthBloc>(context).state.getStartedModel!.userId!,
//           'attr': attr,
//           'password': _passwordController.text,
//         },
//         onSuccess: () {
//           MyPluginNavigation.instance.replace(Verify(
//             isResend: false,
//             password: _passwordController.text,
//             email: widget.email,
//           ));
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
//       return OverlayLoadingCustom(
//           isLoading: state.signUpLoading!,
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
//                   title: 'key_sign_up'.tr(),
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
//                             onValid: (bool val) {
//                               _isValidPassword = val;
//                             },
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFieldCustom(
//                             controller: _firstNameController,
//                             focusNode: _firstNameFocusNode,
//                             validType: ValidType.notEmpty,
//                             hintText: 'key_first_name'.tr(),
//                             onValid: (bool val) {
//                               _isValidFirstName = val;
//                             },
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           TextFieldCustom(
//                             controller: _lastNameController,
//                             focusNode: _lastNameFocusNode,
//                             validType: ValidType.notEmpty,
//                             hintText: 'key_last_name'.tr(),
//                             onValid: (bool val) {
//                               _isValidLastName = val;
//                             },
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 MyPluginNavigation.instance
//                                     .replace(const GetStarted());
//                               },
//                               child: Text('key_use_another_account'.tr())),
//                         ],
//                       )))));
//     });
//   }
// }
