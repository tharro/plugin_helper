import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plugin_helper/plugin_helper.dart';

class PluginNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamSubscription? fcmListener;

  static Future<void> _showNotification(
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
      required Function(RemoteMessage message) onMessage,
      required Function(String payload) onHandleLocalMessage,
      required Function(RemoteMessage message) onHandleFCMMessage,
      required Function(String token) onRegisterFCM,
      String? payload,
      required String chanelId,
      required String chanelName,
      required String channelDescription}) async {
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
        _selectLocalNotification(
            payload: data!, onHandleMessage: onHandleLocalMessage);
      });
      String? token = await messaging.getToken();
      print('token $token');
      onRegisterFCM(token!);
      fcmListener = FirebaseMessaging.onMessage
          .asBroadcastStream()
          .listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        _onMessage(message, onMessage);
        if (message.notification != null) {
          _showNotification(
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
          (message) => _onMessage(message, onMessage(message)));
      _setupInteractedMessage(onHandleFCMMessage: onHandleFCMMessage);
    }
  }

  static _onMessage(RemoteMessage message, Function onMessage) {
    onMessage(message);
  }

  static void _selectLocalNotification(
      {required String payload, required Function onHandleMessage}) {
    onHandleMessage(payload);
  }

  static Future<void> _setupInteractedMessage(
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

  static void setupCrashlytics({required Function() main}) {
    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      main();
      if (await PluginHelper.isFirstInstall()) {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.deleteAll();
        PluginHelper.setFirstInstall();
      }
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
  }

  static dispose() {
    fcmListener?.cancel();
  }
}
