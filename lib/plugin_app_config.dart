enum AppEnvironment { dev, stage, prod }

class AppConfig {
  // Singleton object
  static final AppConfig _singleton = AppConfig._internal();

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();

  AppEnvironment? appEnvironment;
  String? baseUrl;
  String? userPoolId;
  String? clientId;
  String? stripePublicKey;
  String? merchantId;
  String? googleAPIKey;

  // Set app configuration with single function
  void setAppConfig(
      {AppEnvironment? appEnvironment,
      String? baseUrl,
      String? userPoolId,
      String? clientId,
      String? stripePublicKey,
      String? merchantId,
      String? googleAPIKey}) {
    this.merchantId = merchantId ?? this.merchantId;
    this.stripePublicKey = stripePublicKey ?? this.stripePublicKey;
    this.appEnvironment = appEnvironment ?? this.appEnvironment;
    this.baseUrl = baseUrl ?? this.baseUrl;
    this.userPoolId = userPoolId ?? this.userPoolId;
    this.clientId = clientId ?? this.clientId;
    this.googleAPIKey = googleAPIKey ?? this.googleAPIKey;
  }
}
