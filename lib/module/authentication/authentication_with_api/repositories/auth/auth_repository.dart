// import 'dart:io';

// import '../../models/auth/token_model.dart';
// import '../../api/apiUrl.dart';
// import '../../models/auth/get_started_model.dart';
// import '../../models/auth/profile_model.dart';
// import 'package:plugin_helper/plugin_api.dart';

// class AuthRepository extends MyPluginApi {
//   Future<ProfileModel> getProfile() async {
//     final url = APIUrl.getProfile;
//     final response = await request(
//       url,
//       Method.get,
//     );
//     return ProfileModel.fromJson(response.data);
//   }

//   Future<String> uploadImage(File file) async {
//     final url = APIUrl.upload;
//     final response = await requestUploadFile(url, Method.post, file,
//         body: {'type': 'image'});
//     return response.data['results'];
//   }

//   Future<void> updateProfile({required Map<String, dynamic> body}) async {
//     final url = APIUrl.getProfile;
//     await request(
//       url,
//       Method.put,
//       body: body,
//     );
//   }

//   Future<GetStartedModel> getStarted(Map<String, dynamic> body) async {
//     final url = APIUrl.getStarted;
//     final response =
//         await request(url, Method.post, body: body, useIDToken: false);
//     return GetStartedModel.fromJson(response.data);
//   }

//   Future<void> registerFCMDevice({required Map<String, dynamic> body}) async {
//     final url = APIUrl.fcm;
//     await request(url, Method.post, body: body);
//   }

//   Future<void> removeFCMDevice({required Map<String, dynamic> body}) async {
//     final url = APIUrl.fcm;
//     await request(url, Method.put, body: body);
//   }

//   Future<TokenModel> login(
//       {required String userName, required String password}) async {
//     final url = APIUrl.login;
//     final response = await request(url, Method.post,
//         body: {
//           'user_name': userName,
//           'password': password,
//         },
//         useIDToken: false);
//     return TokenModel.fromJson(response.data);
//   }

//   Future<TokenModel> refreshToken({required String refreshToken}) async {
//     final url = APIUrl.refreshToken;
//     final response = await request(url, Method.post, body: {
//       'refresh_token': refreshToken,
//     });
//     return TokenModel.fromJson(response.data);
//   }

//   Future<void> signUp(Map<String, dynamic> body) async {
//     final url = APIUrl.signUp;
//     await request(url, Method.post, body: body, useIDToken: false);
//   }

//   Future<void> verify({required String userName, required String code}) async {
//     final url = APIUrl.verify;
//     await request(url, Method.post,
//         body: {'user_name': userName, 'code': code}, useIDToken: false);
//   }

//   Future<void> resendPassword({required String userName}) async {
//     final url = APIUrl.resendPassword;
//     await request(url, Method.post,
//         body: {
//           'user_name': userName,
//         },
//         useIDToken: false);
//   }

//   Future<void> resendCode({required String userName}) async {
//     final url = APIUrl.resendCode;
//     await request(url, Method.post,
//         body: {
//           'user_name': userName,
//         },
//         useIDToken: false);
//   }

//   Future<void> resetPassword(
//       {required String userName,
//       required String newPassword,
//       required String code}) async {
//     final url = APIUrl.resetPassword;
//     await request(url, Method.post,
//         body: {
//           'user_name': userName,
//           'new_password': newPassword,
//           'code': code,
//         },
//         useIDToken: false);
//   }

//   Future<void> updatePassword({required String newPassword}) async {
//     final url = APIUrl.updatePassword;
//     await request(url, Method.post, body: {'new_password': newPassword});
//   }
// }
