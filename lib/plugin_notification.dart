import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plugin_helper/index.dart';

class MyPluginNotification {
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
      showProgress: true,
      priority: Priority.high,
      color: color,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload ?? '');
  }

  static Future<void> settingNotification(
      {required Color colorNotification,
      required bool Function(RemoteMessage message) onShowLocalNotification,
      required Function(RemoteMessage message) onMessage,
      required Function(String payload) onOpenLocalMessage,
      required Function(RemoteMessage message) onOpenFCMMessage,
      required Function(Map<String, dynamic> token) onRegisterFCM,
      required String iconNotification,
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
          AndroidInitializationSettings(iconNotification);
      var initializationSettingsIOS = const IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String? data) async {
        onOpenLocalMessage(data ?? '');
      });
      Map<String, dynamic> body = await getInfoToRequest();
      onRegisterFCM(body);
      fcmListener = FirebaseMessaging.onMessage
          .asBroadcastStream()
          .listen((RemoteMessage message) async {
        print('Got a message whilst in the foreground!');
        onMessage(message);
        if (message.notification != null) {
          if (onShowLocalNotification(message)) {
            await _showNotification(
                title: message.notification!.title!,
                body: message.notification!.body!,
                color: colorNotification,
                payload: jsonEncode(message.data),
                chanelId: chanelId,
                chanelName: chanelName,
                channelDescription: channelDescription);
          }
        }
      });
      _setupInteractedMessage(onHandleFCMMessage: onOpenFCMMessage);
    }
  }

  static Future<void> _setupInteractedMessage(
      {required Function onHandleFCMMessage}) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onHandleFCMMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onHandleFCMMessage(message));
  }

  static void setupCrashlytics({required Function() main}) {
    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      main();
      if (kIsWeb) {
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(true);
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
  }

  static Future<Map<String, dynamic>> getInfoToRequest() async {
    String? token = await messaging.getToken();
    String meId = await MyPluginHelper.getMeIdDevice();
    Map<String, dynamic> body = {
      "type": "M",
      "device": Platform.isAndroid ? "A" : "I",
      "meid": meId,
      "token": token!,
    };
    return body;
  }

  static dispose() {
    fcmListener?.cancel();
  }
}
