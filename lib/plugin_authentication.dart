import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plugin_helper/plugin_app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PluginAppConstraints {
  static String user = 'USER';
  static String pwd = 'PASSWORD';
  static String token = 'TOKEN';
  static String email = 'EMAIL';
  static String expired = 'EXPIRED';
  static String firstRun = 'FIRST_RUN';
}

class PluginAuthentication {
  final userPool = CognitoUserPool(
    AppConfig().userPoolId!,
    AppConfig().clientId!,
  );

  final storage = const FlutterSecureStorage();

  Future<void> refreshToken() async {
    dynamic userInfo = await getUserAndPassword();
    final cognitoUser = CognitoUser(userInfo['user'], userPool);

    final authDetails = AuthenticationDetails(
        username: userInfo['user'], password: userInfo['pwd']);

    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
      dynamic token = {
        'token': session?.getIdToken().getJwtToken(),
      };
      await persistToken(
          user: userInfo['user'], pass: userInfo['pwd'], token: token['token']);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUserAndPassword() async {
    try {
      return {
        'user': await storage.read(key: PluginAppConstraints.user),
        'pwd': await storage.read(key: PluginAppConstraints.pwd),
      };
    } catch (e) {
      return {
        'user': null,
        'pwd': null,
      };
    }
  }

  Future<void> persistToken(
      {required String user,
      required String pass,
      required String token}) async {
    await storage.write(key: PluginAppConstraints.user, value: user);
    await storage.write(key: PluginAppConstraints.pwd, value: pass);
    await storage.write(key: PluginAppConstraints.token, value: token);
    final expireTimeInTimestamp =
        DateTime.now().millisecondsSinceEpoch + (1 * 60 * 60 * 1000);
    await storage.write(
        key: PluginAppConstraints.expired,
        value: expireTimeInTimestamp.toString());

    return;
  }

  Future<dynamic> getToken() async {
    return await storage.read(key: PluginAppConstraints.token);
  }

  Future<bool> hasExpireToken() async {
    try {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (await storage.read(key: PluginAppConstraints.expired) != null) {
        final expireTime =
            int.parse((await storage.read(key: PluginAppConstraints.expired))!);
        if ((expireTime - currentTime) < 60000) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasToken() async {
    try {
      String? token = await storage.read(key: PluginAppConstraints.token);
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

  Future<void> deleteToken() async {
    await storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return;
  }

  /// API
  Future<String?> loginCognito(
      {required String userName, required String password}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );
    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      rethrow;
    }
    return session?.getIdToken().getJwtToken();
  }

  Future<String> signUpCognito({
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

  Future<bool> verifyCodeCognito({String? userName, String? code}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      return await cognitoUser.confirmRegistration(code!);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resendCodeCognito({String? userName}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      await cognitoUser.resendConfirmationCode();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> forgotPassword({required String userName}) async {
    final cognitoUser = CognitoUser(userName, userPool);
    try {
      await cognitoUser.forgotPassword();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirmNewPassword(
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

  Future<bool> updatePassword(
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
      await storage.write(key: PluginAppConstraints.pwd, value: newPassword);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> requestUpdateAttribute({required String name}) async {
    final cognitoUser = await getCognitoUserWithAuthentication();
    await cognitoUser.getAttributeVerificationCode(name);
    return true;
  }

  Future<bool> verifyAttribute(
      {required String confirmationCode,
      required String attributeName,
      required String value}) async {
    final cognitoUser = await getCognitoUserWithAuthentication();
    bool isVerify =
        await cognitoUser.verifyAttribute(attributeName, confirmationCode);
    if (isVerify) {
      return updateAttribute(
          cognitoUser: cognitoUser, attributeName: attributeName, value: value);
    }
    return false;
  }

  Future<bool> updateAttribute(
      {required String attributeName,
      required String value,
      CognitoUser? cognitoUser}) async {
    CognitoUser? cognito;
    if (cognitoUser != null) {
      cognito = cognitoUser;
    } else {
      cognito = await getCognitoUserWithAuthentication();
    }
    return cognito.updateAttributes(
        [CognitoUserAttribute(name: attributeName, value: value)]);
  }

  Future<CognitoUser> getCognitoUserWithAuthentication() async {
    final userName = await storage.read(key: PluginAppConstraints.user);
    final password = await storage.read(key: PluginAppConstraints.pwd);
    final cognitoUser = CognitoUser(userName, userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );

    await cognitoUser.authenticateUser(authDetails);

    return cognitoUser;
  }

  Future<List<CognitoUserAttribute>?> getAllAttributes() async {
    try {
      var cognito = await getCognitoUserWithAuthentication();
      var attributes = await cognito.getUserAttributes();
      return attributes;
    } catch (e) {}
  }

  Future<CognitoUserSession?> getSession() async {
    final userName = await storage.read(key: PluginAppConstraints.user);
    final password = await storage.read(key: PluginAppConstraints.pwd);
    final cognitoUser = CognitoUser(userName, userPool);
    final authDetails = AuthenticationDetails(
      username: userName,
      password: password,
    );

    return cognitoUser.authenticateUser(authDetails);
  }

  Future<bool> isFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(PluginAppConstraints.firstRun);
    if (result != null) {
      return result;
    }
    return true;
  }

  Future<void> setFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PluginAppConstraints.firstRun, false);
  }
}