// import 'dart:convert';

// import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:plugin_helper/plugin_app_environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This plugin had used for authentication by AWS
class MyPluginAppConstraints {
  static const String user = 'USER';
  static const String token = 'TOKEN';
  static const String refreshToken = 'REFRESH_TOKEN';
  static const String firstRun = 'FIRST_RUN';
  static const String login = 'LOGIN';
  static const String verify = 'VERIFY';
  static const String signUp = 'SIGN_UP';
  static const String expired = 'EXPIRED';
  static const String expiredRefresh = 'EXPIRED_REFRESH';
  static const String language = 'LANGUAGE';
}

class MyPluginAuthentication {
  // static final userPool = CognitoUserPool(
  //   MyPluginAppEnvironment().userPoolId!,
  //   MyPluginAppEnvironment().clientId!,
  // );

  static const storage = FlutterSecureStorage();

  // static Future<String?> loginCognito(
  //     {required String userName, required String password}) async {
  //   final cognitoUser = CognitoUser(userName, userPool);
  //   final authDetails = AuthenticationDetails(
  //     username: userName,
  //     password: password,
  //   );
  //   CognitoUserSession? session;
  //   try {
  //     session = await cognitoUser.authenticateUser(authDetails);
  //     await persistUser(
  //         userId: userName,
  //         token: session?.getIdToken().getJwtToken() ?? '',
  //         refreshToken: session?.getRefreshToken()?.getToken() ?? '');
  //   } catch (e) {
  //     rethrow;
  //   }
  //   return session?.getIdToken().getJwtToken();
  // }

  // static Future<String> signUpCognito({
  //   required String id,
  //   required String password,
  //   required List<AttributeArg> userAttributes,
  // }) async {
  //   final attributes = userAttributes;
  //   try {
  //     await userPool.signUp(
  //       id,
  //       password,
  //       userAttributes: attributes,
  //     );
  //     return id;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<bool> verifyCodeCognito(
  //     {String? userName, String? code}) async {
  //   final cognitoUser = CognitoUser(userName, userPool);
  //   try {
  //     return await cognitoUser.confirmRegistration(code!);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<bool> resendCodeCognito({String? userName}) async {
  //   final cognitoUser = CognitoUser(userName, userPool);
  //   try {
  //     await cognitoUser.resendConfirmationCode();
  //     return true;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<bool> forgotPassword({required String userName}) async {
  //   final cognitoUser = CognitoUser(userName, userPool);
  //   try {
  //     await cognitoUser.forgotPassword();
  //     return true;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<bool> confirmNewPassword(
  //     {required String userName,
  //     required String code,
  //     required String newPassword}) async {
  //   final cognitoUser = CognitoUser(userName, userPool);
  //   try {
  //     await cognitoUser.confirmPassword(code, newPassword);
  //     return true;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<bool> updatePassword(
  //     {required String userName,
  //     required String currentPassword,
  //     required String newPassword}) async {
  //   final cognitoUser = CognitoUser(userName, userPool);
  //   final authDetails = AuthenticationDetails(
  //     username: userName,
  //     password: currentPassword,
  //   );
  //   await cognitoUser.authenticateUser(authDetails);
  //   try {
  //     await cognitoUser.changePassword(currentPassword, newPassword);
  //     return true;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // static Future<bool> resendCodeAttribute({required String name}) async {
  //   Users userInfo = await getUser();
  //   final cognitoUser = CognitoUser(userInfo.userId, userPool);
  //   await cognitoUser.getAttributeVerificationCode(name);
  //   return true;
  // }

  // static Future<bool> verifyAttribute(
  //     {required String confirmationCode,
  //     required String attributeName,
  //     required String value}) async {
  //   Users userInfo = await getUser();
  //   final cognitoUser = CognitoUser(userInfo.userId, userPool);
  //   return await cognitoUser.verifyAttribute(attributeName, confirmationCode);
  // }

  // static Future<bool> updateAttribute(
  //     {required String attributeName,
  //     required String value,
  //     CognitoUser? cognitoUser}) async {
  //   CognitoUser? cognito;
  //   if (cognitoUser != null) {
  //     cognito = cognitoUser;
  //   } else {
  //     Users userInfo = await getUser();
  //     cognito = CognitoUser(userInfo.userId, userPool);
  //   }
  //   return cognito.updateAttributes(
  //       [CognitoUserAttribute(name: attributeName, value: value)]);
  // }

  // static Future<void> refreshToken() async {
  //   Users userInfo = await getUser();
  //   final cognitoUser = CognitoUser(userInfo.userId!, userPool);
  //   try {
  //     final refreshToken = CognitoRefreshToken(userInfo.refreshToken);
  //     CognitoUserSession? cognitoUserSession =
  //         await cognitoUser.refreshSession(refreshToken);
  //     await persistUser(
  //         userId: userInfo.userId!,
  //         token: cognitoUserSession?.getIdToken().getJwtToken() ?? '',
  //         refreshToken:
  //             cognitoUserSession?.getRefreshToken()?.getToken() ?? '');
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future<bool> hasToken() async {
    try {
      String? token = await storage.read(key: MyPluginAppConstraints.token);
      if (token != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      await storage.deleteAll();
      return false;
    }
  }

  static Future<bool> checkTokenValidity() async {
    final users = await getUser();
    // if (MyPluginAppEnvironment().isCognito) {
    //   if (DateTime.now()
    //       .add(const Duration(minutes: 1))
    //       .isBefore(_tokenExpiration(users.token!))) {
    //     return true;
    //   }
    // } else {
    if (DateTime.now()
        .add(const Duration(minutes: 5))
        .isBefore(DateTime.parse(users.expiredToken!))) {
      return true;
    }
    // }

    return false;
  }

  static Future<bool> checkRefreshTokenValidity() async {
    final users = await getUser();
    if (DateTime.now()
        .add(const Duration(minutes: 5))
        .isBefore(DateTime.parse(users.expiredRefreshToken!))) {
      return true;
    }
    return false;
  }

  // static DateTime _tokenExpiration(String token) {
  //   final parts = token.split('.');

  //   if (parts.length != 3) {
  //     throw 'tokenInvalid';
  //   }

  //   final payloadMap = json.decode(_decodeBase64(parts[1]));

  //   if (payloadMap is! Map<String, dynamic>) {
  //     throw 'payloadInvalid';
  //   }

  //   return DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000);
  // }

  // static String _decodeBase64(String str) {
  //   var output = str.replaceAll('-', '+').replaceAll('_', '/');

  //   switch (output.length % 4) {
  //     case 0:
  //       break;
  //     case 2:
  //       output += '==';
  //       break;
  //     case 3:
  //       output += '=';
  //       break;
  //     default:
  //       throw 'base64Invalid';
  //   }

  //   return utf8.decode(base64Url.decode(output));
  // }

  static Future<Users> getUser() async {
    try {
      String? user = await storage.read(key: MyPluginAppConstraints.user);
      String? token = await storage.read(key: MyPluginAppConstraints.token);
      String? refreshToken =
          await storage.read(key: MyPluginAppConstraints.refreshToken);
      String? expiredToken =
          await storage.read(key: MyPluginAppConstraints.expired);
      String? expiredRefreshToken =
          await storage.read(key: MyPluginAppConstraints.expiredRefresh);
      return Users(
        userId: user,
        token: token,
        refreshToken: refreshToken,
        expiredToken: expiredToken,
        expiredRefreshToken: expiredRefreshToken,
      );
    } catch (e) {
      return Users();
    }
  }

  static Future<void> persistUser({
    required String userId,
    required String token,
    required String refreshToken,
    String? expiredToken,
    String? expiredRefreshToken,
  }) async {
    await storage.write(key: MyPluginAppConstraints.user, value: userId);
    await storage.write(key: MyPluginAppConstraints.token, value: token);
    await storage.write(
        key: MyPluginAppConstraints.refreshToken, value: refreshToken);
    await storage.write(
        key: MyPluginAppConstraints.expired, value: expiredToken);
    await storage.write(
        key: MyPluginAppConstraints.expiredRefresh, value: expiredRefreshToken);
  }

  static Future<void> deleteUser() async {
    await storage.delete(key: MyPluginAppConstraints.user);
    await storage.delete(key: MyPluginAppConstraints.token);
    await storage.delete(key: MyPluginAppConstraints.refreshToken);
    await storage.delete(key: MyPluginAppConstraints.expired);
    await storage.delete(key: MyPluginAppConstraints.expiredRefresh);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return;
  }
}

class Users {
  final String? userId;
  final String? token;
  final String? refreshToken;
  final String? expiredToken;
  final String? expiredRefreshToken;

  Users(
      {this.userId,
      this.expiredRefreshToken,
      this.token,
      this.refreshToken,
      this.expiredToken});
}
