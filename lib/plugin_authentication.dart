import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plugin_helper/plugin_app_environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This plugin had used for authentication by AWS
class MyPluginAppConstraints {
  static const String user = 'USER';
  static const String pwd = 'PASSWORD';
  static const String token = 'TOKEN';
  static const String email = 'EMAIL';
  static const String expired = 'EXPIRED';
  static const String firstRun = 'FIRST_RUN';
  static const String login = 'LOGIN';
  static const String verify = 'VERIFY';
  static const String signUp = 'SIGN_UP';
}

// class MyPluginAuthentication {
//   static final userPool = CognitoUserPool(
//     MyPluginAppEnvironment().userPoolId!,
//     MyPluginAppEnvironment().clientId!,
//   );

//   static const storage = FlutterSecureStorage();

//   static Future<void> refreshToken() async {
//     dynamic userInfo = await getUserAndPassword();
//     final cognitoUser = CognitoUser(userInfo['user'], userPool);

//     final authDetails = AuthenticationDetails(
//         username: userInfo['user'], password: userInfo['pwd']);

//     CognitoUserSession? session;
//     try {
//       session = await cognitoUser.authenticateUser(authDetails);
//       dynamic token = {
//         'token': session?.getIdToken().getJwtToken(),
//       };
//       await persistToken(
//           user: userInfo['user'], pass: userInfo['pwd'], token: token['token']);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<dynamic> getUserAndPassword() async {
//     try {
//       return {
//         'user': await storage.read(key: MyPluginAppConstraints.user),
//         'pwd': await storage.read(key: MyPluginAppConstraints.pwd),
//       };
//     } catch (e) {
//       return {
//         'user': null,
//         'pwd': null,
//       };
//     }
//   }

//   static Future<void> persistToken(
//       {required String user,
//       required String pass,
//       required String token}) async {
//     await storage.write(key: MyPluginAppConstraints.user, value: user);
//     await storage.write(key: MyPluginAppConstraints.pwd, value: pass);
//     await storage.write(key: MyPluginAppConstraints.token, value: token);
//     final expireTimeInTimestamp =
//         DateTime.now().millisecondsSinceEpoch + (1 * 60 * 60 * 1000);
//     await storage.write(
//         key: MyPluginAppConstraints.expired,
//         value: expireTimeInTimestamp.toString());

//     return;
//   }

//   static Future<dynamic> getToken() async {
//     return await storage.read(key: MyPluginAppConstraints.token);
//   }

//   static Future<bool> hasExpireToken() async {
//     try {
//       final currentTime = DateTime.now().millisecondsSinceEpoch;
//       if (await storage.read(key: MyPluginAppConstraints.expired) != null) {
//         final expireTime = int.parse(
//             (await storage.read(key: MyPluginAppConstraints.expired))!);
//         if ((expireTime - currentTime) < 60000) {
//           return true;
//         }
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<bool> hasToken() async {
//     try {
//       String? token = await storage.read(key: MyPluginAppConstraints.token);
//       if (token != null) {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       await storage.deleteAll();
//       return false;
//     }
//   }

//   static Future<void> deleteToken() async {
//     await storage.deleteAll();
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     return;
//   }

//   /// API
//   static Future<String?> loginCognito(
//       {required String userName, required String password}) async {
//     final cognitoUser = CognitoUser(userName, userPool);
//     final authDetails = AuthenticationDetails(
//       username: userName,
//       password: password,
//     );
//     CognitoUserSession? session;
//     try {
//       session = await cognitoUser.authenticateUser(authDetails);
//     } catch (e) {
//       rethrow;
//     }
//     return session?.getIdToken().getJwtToken();
//   }

//   static Future<String> signUpCognito({
//     required String id,
//     required String password,
//     required List<AttributeArg> userAttributes,
//   }) async {
//     final attributes = userAttributes;
//     try {
//       await userPool.signUp(
//         id,
//         password,
//         userAttributes: attributes,
//       );
//       return id;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> verifyCodeCognito(
//       {String? userName, String? code}) async {
//     final cognitoUser = CognitoUser(userName, userPool);
//     try {
//       return await cognitoUser.confirmRegistration(code!);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> resendCodeCognito({String? userName}) async {
//     final cognitoUser = CognitoUser(userName, userPool);
//     try {
//       await cognitoUser.resendConfirmationCode();
//       return true;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> forgotPassword({required String userName}) async {
//     final cognitoUser = CognitoUser(userName, userPool);
//     try {
//       await cognitoUser.forgotPassword();
//       return true;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> confirmNewPassword(
//       {required String userName,
//       required String code,
//       required String newPassword}) async {
//     final cognitoUser = CognitoUser(userName, userPool);
//     try {
//       await cognitoUser.confirmPassword(code, newPassword);
//       return true;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> updatePassword(
//       {required String userName,
//       required String currentPassword,
//       required String newPassword}) async {
//     final cognitoUser = CognitoUser(userName, userPool);
//     final authDetails = AuthenticationDetails(
//       username: userName,
//       password: currentPassword,
//     );
//     await cognitoUser.authenticateUser(authDetails);
//     try {
//       await cognitoUser.changePassword(currentPassword, newPassword);
//       await storage.write(key: MyPluginAppConstraints.pwd, value: newPassword);
//       return true;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future<bool> resendCodeAttribute({required String name}) async {
//     final cognitoUser = await getCognitoUserWithAuthentication();
//     await cognitoUser.getAttributeVerificationCode(name);
//     return true;
//   }

//   static Future<bool> verifyAttribute(
//       {required String confirmationCode,
//       required String attributeName,
//       required String value}) async {
//     final cognitoUser = await getCognitoUserWithAuthentication();
//     return await cognitoUser.verifyAttribute(attributeName, confirmationCode);
//   }

//   static Future<bool> updateAttribute(
//       {required String attributeName,
//       required String value,
//       CognitoUser? cognitoUser}) async {
//     CognitoUser? cognito;
//     if (cognitoUser != null) {
//       cognito = cognitoUser;
//     } else {
//       cognito = await getCognitoUserWithAuthentication();
//     }
//     return cognito.updateAttributes(
//         [CognitoUserAttribute(name: attributeName, value: value)]);
//   }

//   static Future<CognitoUser> getCognitoUserWithAuthentication() async {
//     final userName = await storage.read(key: MyPluginAppConstraints.user);
//     final password = await storage.read(key: MyPluginAppConstraints.pwd);
//     final cognitoUser = CognitoUser(userName, userPool);
//     final authDetails = AuthenticationDetails(
//       username: userName,
//       password: password,
//     );

//     await cognitoUser.authenticateUser(authDetails);

//     return cognitoUser;
//   }

//   static Future<List<CognitoUserAttribute>?> getAllAttributes() async {
//     try {
//       var cognito = await getCognitoUserWithAuthentication();
//       var attributes = await cognito.getUserAttributes();
//       return attributes;
//     } catch (e) {}
//     return null;
//   }

//   static Future<CognitoUserSession?> getSession() async {
//     final userName = await storage.read(key: MyPluginAppConstraints.user);
//     final password = await storage.read(key: MyPluginAppConstraints.pwd);
//     final cognitoUser = CognitoUser(userName, userPool);
//     final authDetails = AuthenticationDetails(
//       username: userName,
//       password: password,
//     );

//     return cognitoUser.authenticateUser(authDetails);
//   }
// }

class MyPluginAuthentication {
  static final userPool = CognitoUserPool(
    MyPluginAppEnvironment().userPoolId!,
    MyPluginAppEnvironment().clientId!,
  );

  static const storage = FlutterSecureStorage();

  static Future<String?> loginCognito(
      {required String userName, required String password}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );
    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
      await cognitoUser.cacheTokens();
      await persistUser(
          user: userName, token: session?.getIdToken().getJwtToken() ?? '');
    } catch (e) {
      rethrow;
    }
    return session?.getIdToken().getJwtToken();
  }

  static Future<String> signUpCognito({
    required String id,
    required String password,
    required List<AttributeArg> userAttributes,
  }) async {
    final attributes = userAttributes;
    try {
      await userPool.signUp(
        id,
        password,
        userAttributes: attributes,
      );
      return id;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> verifyCodeCognito(
      {String? userName, String? code}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      return await cognitoUser.confirmRegistration(code!);
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> resendCodeCognito({String? userName}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      await cognitoUser.resendConfirmationCode();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> forgotPassword({required String userName}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      await cognitoUser.forgotPassword();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> confirmNewPassword(
      {required String userName,
      required String code,
      required String newPassword}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      await cognitoUser.confirmPassword(code, newPassword);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updatePassword(
      {required String userName,
      required String currentPassword,
      required String newPassword}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: currentPassword,
    );
    await cognitoUser.authenticateUser(authDetails);
    try {
      await cognitoUser.changePassword(currentPassword, newPassword);
      await storage.write(key: MyPluginAppConstraints.pwd, value: newPassword);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> resendCodeAttribute({required String name}) async {
    dynamic userInfo = await getUser();
    final cognitoUser = CognitoUser(userInfo['user'], userPool);
    await cognitoUser.getAttributeVerificationCode(name);
    return true;
  }

  static Future<bool> verifyAttribute(
      {required String confirmationCode,
      required String attributeName,
      required String value}) async {
    dynamic userInfo = await getUser();
    final cognitoUser = CognitoUser(userInfo['user'], userPool);
    return await cognitoUser.verifyAttribute(attributeName, confirmationCode);
  }

  static Future<bool> updateAttribute(
      {required String attributeName,
      required String value,
      CognitoUser? cognitoUser}) async {
    CognitoUser? cognito;
    if (cognitoUser != null) {
      cognito = cognitoUser;
    } else {
      dynamic userInfo = await getUser();
      cognito = CognitoUser(userInfo['user'], userPool);
    }
    return cognito.updateAttributes(
        [CognitoUserAttribute(name: attributeName, value: value)]);
  }

  static Future<void> refreshToken() async {
    dynamic userInfo = await getUser();
    final cognitoUser = CognitoUser(userInfo['user'], userPool);
    try {
      CognitoUserSession? cognitoUserSession = await cognitoUser.getSession();
      cognitoUser.refreshSession(cognitoUserSession!.refreshToken!);
    } catch (e) {
      rethrow;
    }
  }

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
    final user = await getUser();
    if (DateTime.now()
        .add(const Duration(minutes: 5))
        .isBefore(_tokenExpiration(user['token']))) {
      return true;
    }
    return false;
  }

  static DateTime _tokenExpiration(String token) {
    final parts = token.split('.');

    if (parts.length != 3) {
      throw 'tokenInvalid';
    }

    final payloadMap = json.decode(_decodeBase64(parts[1]));

    if (payloadMap is! Map<String, dynamic>) {
      throw 'payloadInvalid';
    }

    return DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000);
  }

  static String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw 'base64Invalid';
    }

    return utf8.decode(base64Url.decode(output));
  }

  static Future<dynamic> getUser() async {
    try {
      return {
        'user': await storage.read(key: MyPluginAppConstraints.user),
        'token': await storage.read(key: MyPluginAppConstraints.token),
      };
    } catch (e) {
      return {
        'user': null,
        'token': null,
      };
    }
  }

  static Future<void> persistUser(
      {required String user, required String token}) async {
    await storage.write(key: MyPluginAppConstraints.user, value: user);
    await storage.write(key: MyPluginAppConstraints.token, value: token);
  }

  static Future<void> deleteUser() async {
    await storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return;
  }
}
