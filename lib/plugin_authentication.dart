import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  static const storage = FlutterSecureStorage();
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
    if (users.expiredToken != null &&
        users.expiredToken! > DateTime.now().toUtc().millisecondsSinceEpoch) {
      return true;
    }

    return false;
  }

  static Future<bool> checkRefreshTokenValidity() async {
    final users = await getUser();
    if (users.expiredRefreshToken != null &&
        users.expiredRefreshToken! >
            DateTime.now().toUtc().millisecondsSinceEpoch) {
      return true;
    }
    return false;
  }

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
        expiredToken:
            expiredToken != null ? int.tryParse(expiredToken) ?? 0 : 0,
        expiredRefreshToken: expiredRefreshToken != null
            ? int.tryParse(expiredRefreshToken) ?? 0
            : 0,
      );
    } catch (e) {
      return Users();
    }
  }

  static Future<void> persistUser({
    required String userId,
    required String token,
    required String refreshToken,
    required int expiredToken,
    required int expiredRefreshToken,
  }) async {
    await storage.write(key: MyPluginAppConstraints.user, value: userId);
    await storage.write(key: MyPluginAppConstraints.token, value: token);
    await storage.write(
        key: MyPluginAppConstraints.refreshToken, value: refreshToken);
    await storage.write(
        key: MyPluginAppConstraints.expired, value: expiredToken.toString());
    await storage.write(
        key: MyPluginAppConstraints.expiredRefresh,
        value: expiredRefreshToken.toString());
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
  final int? expiredToken;
  final int? expiredRefreshToken;

  Users(
      {this.userId,
      this.expiredRefreshToken,
      this.token,
      this.refreshToken,
      this.expiredToken});
}
