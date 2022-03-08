import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './plugin_authentication.dart';

class PluginNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamSubscription? fcmListener;

  static Future<void> showNotification(
      {required String title,
      required String body,
      required Color color,
      String? payload,
      chanelId,
      chanelName,
      channelDescription}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      chanelId,
      chanelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
      color: color,
    );

    var iOSChannelSpecifics = const IOSNotificationDetails(
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload ?? '');
  }

  static Future<void> settingNotification(
      {required Color colorNotification,
      required Function onMessage,
      onHandleLocalMessage,
      onHandleFCMMessage,
      onRegisterFCM,
      String? payload,
      chanelId,
      chanelName,
      channelDescription}) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/notification_icon');
      var initializationSettingsIOS = const IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String? data) async {
        selectLocalNotification(
            payload: data!, onHandleMessage: onHandleLocalMessage);
      });
      String? token = await messaging.getToken();
      print('token $token');
      onRegisterFCM(token);
      fcmListener = FirebaseMessaging.onMessage
          .asBroadcastStream()
          .listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        _onMessage(message, onMessage);
        if (message.notification != null) {
          showNotification(
              title: message.notification!.title!,
              body: message.notification!.body!,
              color: colorNotification,
              payload: payload,
              chanelId: chanelId,
              chanelName: chanelName,
              channelDescription: channelDescription);
        }
      });
      FirebaseMessaging.onBackgroundMessage(
          (message) => _onMessage(message, onMessage));
      setupInteractedMessage(onHandleFCMMessage: onHandleFCMMessage);
    }
  }

  static _onMessage(RemoteMessage message, Function onMessage) {
    onMessage(message);
  }

  static void selectLocalNotification(
      {required String payload, required Function onHandleMessage}) {
    onHandleMessage(payload);
  }

  static Future<void> setupInteractedMessage(
      {required Function onHandleFCMMessage}) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, onHandleFCMMessage);
    }
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message, onHandleFCMMessage));
  }

  static void _handleMessage(
      RemoteMessage message, Function onHandleFCMMessage) {
    onHandleFCMMessage(message);
  }

  static void setupCrashlytics({void main}) {
    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      if (await PluginAuthentication().isFirstInstall()) {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.deleteAll();
        PluginAuthentication().setFirstInstall();
      }
      await Firebase.initializeApp();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      main;
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
  }

  dispose() {
    fcmListener?.cancel();
  }
}
