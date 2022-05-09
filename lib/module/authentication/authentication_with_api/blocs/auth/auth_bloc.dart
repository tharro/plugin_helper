// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import '../../models/auth/token_model.dart';
// import '../../models/auth/get_started_model.dart';
// import '../../models/auth/profile_model.dart';
// import '../../repositories/auth/auth_repository.dart';
// import '../../utils/parse_error.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:plugin_helper/plugin_authentication.dart';
// import 'package:easy_localization/easy_localization.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepositories = AuthRepository();
//   AuthBloc() : super(AuthState.empty()) {
//     on<AuthResumeSession>(authResumeSession);
//     on<AuthGetStarted>(authGetStarted);
//     on<AuthLogin>(authLogin);
//     on<AuthSignUp>(authSignUp);
//     on<AuthResendCode>(authResendCode);
//     on<AuthVerifyCode>(authVerifyCode);
//     on<AuthUpdateProfile>(authUpdateProfile);
//     on<AuthForgotPassword>(authForgotPassword);
//     on<AuthResetPassword>(authResetPassword);
//     on<AuthFCM>(authFCM);
//   }

//   void authResumeSession(
//       AuthResumeSession event, Emitter<AuthState> emit) async {
//     try {
//       var hasToken = await MyPluginAuthentication.hasToken();
//       if (hasToken) {
//         final users = await MyPluginAuthentication.getUser();
//         if (!await MyPluginAuthentication.checkTokenValidity()) {
//           final TokenModel tokenModel = await authRepositories.refreshToken(
//               refreshToken: users.refreshToken!);
//           await MyPluginAuthentication.persistUser(
//               userId: users.userId!,
//               token: tokenModel.token,
//               refreshToken: tokenModel.refreshToken,
//               expiredToken: DateTime.now().toString());
//         }
//         final profile = await authRepositories.getProfile();
//         emit(state.copyWith(profileModel: profile));
//         event.onSuccess(true);
//       } else {
//         event.onSuccess(false);
//       }
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       event.onError(error.code, error.message);
//     }
//   }

//   void authLogin(AuthLogin event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(loginLoading: true));
//       final TokenModel tokenModel = await authRepositories.login(
//         password: event.password,
//         userName: event.userName,
//       );
//       await MyPluginAuthentication.persistUser(
//           userId: event.userName,
//           token: tokenModel.token,
//           refreshToken: tokenModel.refreshToken,
//           expiredToken: DateTime.now().toString());
//       ProfileModel profileModel = await authRepositories.getProfile();
//       emit(state.copyWith(profileModel: profileModel, loginLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(loginLoading: false));
//       event.onError(
//           error.code,
//           error.code == 'NotAuthorizedException'
//               ? 'key_wrong_password'.tr()
//               : error.message);
//     }
//   }

//   void authGetStarted(AuthGetStarted event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(getStartedRequesting: true));
//       GetStartedModel getStartedModel =
//           await authRepositories.getStarted(event.body);
//       emit(state.copyWith(
//           getStartedModel: getStartedModel, getStartedRequesting: false));
//       if (getStartedModel.userExist!) {
//         if (getStartedModel.isVerifiedUser!) {
//           event.onSuccess(MyPluginAppConstraints.login);
//         } else {
//           event.onSuccess(MyPluginAppConstraints.verify);
//         }
//       } else {
//         event.onSuccess(MyPluginAppConstraints.signUp);
//       }
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(getStartedRequesting: false));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authResendCode(AuthResendCode event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(verifyCodeLoading: true));
//       await authRepositories.resendCode(userName: event.userName);
//       emit(state.copyWith(verifyCodeLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(verifyCodeLoading: false));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(signUpLoading: true));
//       await authRepositories.signUp(event.body);
//       emit(state.copyWith(signUpLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(signUpLoading: false));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authVerifyCode(AuthVerifyCode event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(verifyCodeLoading: true));

//       await authRepositories.verify(userName: event.userName, code: event.code);
//       if (event.password != null) {
//         final TokenModel tokenModel = await authRepositories.login(
//           password: event.password!,
//           userName: event.userName,
//         );
//         await MyPluginAuthentication.persistUser(
//             userId: event.userName,
//             token: tokenModel.token,
//             refreshToken: tokenModel.refreshToken,
//             expiredToken: DateTime.now().toString());
//         ProfileModel profileModel = await authRepositories.getProfile();
//         emit(state.copyWith(
//             profileModel: profileModel, verifyCodeLoading: false));
//       } else {
//         emit(state.copyWith(verifyCodeLoading: false));
//       }
//       event.onSuccess();
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(verifyCodeLoading: false));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authForgotPassword(
//       AuthForgotPassword event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(resetPasswordLoading: true));
//       await authRepositories.resendPassword(userName: event.userName);
//       event.onSuccess();
//       emit(state.copyWith(resetPasswordLoading: false));
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(
//         resetPasswordLoading: false,
//       ));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authResetPassword(
//       AuthResetPassword event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(resetPasswordLoading: true));
//       await authRepositories.resetPassword(
//         code: event.code,
//         newPassword: event.password,
//         userName: event.userName,
//       );
//       final TokenModel tokenModel = await authRepositories.login(
//         password: event.password,
//         userName: event.userName,
//       );
//       await MyPluginAuthentication.persistUser(
//           userId: event.userName,
//           token: tokenModel.token,
//           refreshToken: tokenModel.refreshToken,
//           expiredToken: DateTime.now().toString());
//       ProfileModel profileModel = await authRepositories.getProfile();
//       emit(state.copyWith(
//           profileModel: profileModel, resetPasswordLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(resetPasswordLoading: false));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authUpdateProfile(
//       AuthUpdateProfile event, Emitter<AuthState> emit) async {
//     try {
//       emit(state.copyWith(updateProfileLoading: true));
//       String imageUrl = '';
//       if (event.image != null) {
//         imageUrl = await authRepositories.uploadImage(event.image!);
//       }
//       event.body['avatar'] = imageUrl;
//       await authRepositories.updateProfile(body: event.body);
//       ProfileModel profileModel = await authRepositories.getProfile();
//       emit(state.copyWith(
//           profileModel: profileModel, updateProfileLoading: false));
//       event.onSuccess();
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       emit(state.copyWith(updateProfileLoading: false));
//       event.onError(error.code, error.message);
//     }
//   }

//   void authFCM(AuthFCM event, Emitter<AuthState> emit) async {
//     try {
//       await authRepositories.registerFCMDevice(body: event.body);
//     } catch (e) {
//       ParseError error = ParseError.fromJson(e);
//       print(error);
//     }
//   }
// }
