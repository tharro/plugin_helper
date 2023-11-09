import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// This plugin helps manage user access tokens.
class MyPluginAuthentication {
  static const storage = FlutterSecureStorage();

  /// Check whether token exists or not.
  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      String? token;
      if (!kIsWeb && Platform.isLinux) {
        token = prefs.getString(MyPluginAppConstraints.token);
      }
      token = await storage.read(key: MyPluginAppConstraints.token);

      if (token != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (!kIsWeb && Platform.isLinux) {
        await prefs.clear();
      } else {
        await storage.deleteAll();
      }
      return false;
    }
  }

  /// Check whether token is valid or not.
  static Future<bool> checkTokenValidity() async {
    final users = await getUser();
    if (users.expiredToken != null &&
        users.expiredToken! >
            DateTime.now()
                .add(const Duration(minutes: 5))
                .toUtc()
                .millisecondsSinceEpoch) {
      return true;
    }

    return false;
  }

  /// Check whether the refresh token is valid or not.
  static Future<bool> checkRefreshTokenValidity() async {
    final users = await getUser();
    if (users.expiredRefreshToken != null &&
        users.expiredRefreshToken! >
            DateTime.now()
                .add(const Duration(minutes: 5))
                .toUtc()
                .millisecondsSinceEpoch) {
      return true;
    }
    return false;
  }

  /// Retrieve user's token from local storage
  static Future<Users> getUser() async {
    try {
      String? user, token, refreshToken, expiredToken, expiredRefreshToken;
      if (!kIsWeb && Platform.isLinux) {
        final prefs = await SharedPreferences.getInstance();
        user = prefs.getString(MyPluginAppConstraints.user);
        token = prefs.getString(MyPluginAppConstraints.token);
        refreshToken = prefs.getString(MyPluginAppConstraints.refreshToken);
        expiredToken = prefs.getString(MyPluginAppConstraints.expired);
        expiredRefreshToken =
            prefs.getString(MyPluginAppConstraints.expiredRefresh);
      } else {
        user = await storage.read(key: MyPluginAppConstraints.user);
        token = await storage.read(key: MyPluginAppConstraints.token);
        refreshToken =
            await storage.read(key: MyPluginAppConstraints.refreshToken);
        expiredToken = await storage.read(key: MyPluginAppConstraints.expired);
        expiredRefreshToken =
            await storage.read(key: MyPluginAppConstraints.expiredRefresh);
      }

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

  /// Save user's token to local storage
  static Future<void> persistUser({
    required String userId,
    required String token,
    required String refreshToken,
    required int expiredToken,
    required int expiredRefreshToken,
  }) async {
    if (!kIsWeb && Platform.isLinux) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(MyPluginAppConstraints.user, userId);
      await prefs.setString(MyPluginAppConstraints.token, token);
      prefs.setString(MyPluginAppConstraints.refreshToken, refreshToken);
      prefs.setString(MyPluginAppConstraints.expired, expiredToken.toString());
      await prefs.setString(MyPluginAppConstraints.expiredRefresh,
          expiredRefreshToken.toString());
    } else {
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
  }

  /// Delete user's token in local storage
  static Future<void> deleteUser() async {
    if (kIsWeb || !Platform.isLinux) {
      await storage.delete(key: MyPluginAppConstraints.user);
      await storage.delete(key: MyPluginAppConstraints.token);
      await storage.delete(key: MyPluginAppConstraints.refreshToken);
      await storage.delete(key: MyPluginAppConstraints.expired);
      await storage.delete(key: MyPluginAppConstraints.expiredRefresh);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(MyPluginAppConstraints.user);
    await prefs.remove(MyPluginAppConstraints.token);
    await prefs.remove(MyPluginAppConstraints.refreshToken);
    await prefs.remove(MyPluginAppConstraints.expired);
    await prefs.remove(MyPluginAppConstraints.expiredRefresh);
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
