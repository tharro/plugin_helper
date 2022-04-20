// import '../../blocs/auth/auth_bloc.dart';
// import '../../screens/auth/get_started.dart';
// import '../../utils/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:plugin_helper/plugin_message_require.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:plugin_helper/plugin_navigator.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     BlocProvider.of<AuthBloc>(context)
//         .add(AuthResumeSession(onError: (String code, message) {
//       Helper.showErrorDialog(
//           context: context,
//           code: code,
//           message: message,
//           barrierDismissible: false,
//           onPressPrimaryButton: () {
//             MyPluginNavigation.instance.replace(const GetStarted());
//           });
//     }, onSuccess: (bool isResume) {
//       if (isResume) {
//         //TODO: navigate to home screen
//       } else {
//         MyPluginNavigation.instance.replace(const GetStarted());
//       }
//     }));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(),
//     );
//   }
// }
