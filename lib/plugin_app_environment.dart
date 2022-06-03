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
  late bool isVerifyEmailAndPhone;
  Map<String, dynamic>? customKey;

  // Set app configuration with single function
  void setAppConfig({
    AppEnvironment? appEnvironment,
    String? baseUrl,
    String? userPoolId,
    String? clientId,
    String? stripePublicKey,
    String? merchantId,
    String? googleAPIKey,
    Map<String, dynamic>? customKey,
    required bool isVerifyEmailAndPhone,
  }) {
    this.merchantId = merchantId ?? this.merchantId;
    this.stripePublicKey = stripePublicKey ?? this.stripePublicKey;
    this.appEnvironment = appEnvironment ?? this.appEnvironment;
    this.baseUrl = baseUrl ?? this.baseUrl;
    this.userPoolId = userPoolId ?? this.userPoolId;
    this.clientId = clientId ?? this.clientId;
    this.googleAPIKey = googleAPIKey ?? this.googleAPIKey;
    this.customKey = customKey ?? this.customKey;
    this.isVerifyEmailAndPhone = isVerifyEmailAndPhone;
  }
}
