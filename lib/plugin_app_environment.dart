import 'package:plugin_helper/plugin_helper.dart';

enum AppEnvironment { dev, stage, prod }

//This plugin had used to config the environment and its variables of it
class MyPluginAppEnvironment {
  // Singleton object
  static final MyPluginAppEnvironment _singleton =
      MyPluginAppEnvironment._internal();

  factory MyPluginAppEnvironment() {
    return _singleton;
  }

  MyPluginAppEnvironment._internal();

  AppEnvironment? appEnvironment;
  String? baseUrl;
  String? userPoolId;
  String? clientId;
  String? stripePublicKey;
  String? merchantId;
  String? googleAPIKey;
  late bool isCognito;
  CustomKey? customKey;

  // Set app configuration with single function
  void setAppConfig({
    AppEnvironment? appEnvironment,
    String? baseUrl,
    String? userPoolId,
    String? clientId,
    String? stripePublicKey,
    String? merchantId,
    String? googleAPIKey,
    CustomKey? customKey,
    required bool isCognito,
  }) {
    this.merchantId = merchantId ?? this.merchantId;
    this.stripePublicKey = stripePublicKey ?? this.stripePublicKey;
    this.appEnvironment = appEnvironment ?? this.appEnvironment;
    this.baseUrl = baseUrl ?? this.baseUrl;
    this.userPoolId = userPoolId ?? this.userPoolId;
    this.clientId = clientId ?? this.clientId;
    this.googleAPIKey = googleAPIKey ?? this.googleAPIKey;
    this.customKey = customKey ?? this.customKey;
    this.isCognito = isCognito;
  }
}

class CustomKey extends Equatable {
  final String key;
  final dynamic value;

  const CustomKey({required this.key, required this.value});
  @override
  List<Object?> get props => [key, value];
}
