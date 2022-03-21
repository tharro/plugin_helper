enum AppEnvironment { dev, stage, prod }

class PluginAppConfig {
  // Singleton object
  static final PluginAppConfig _singleton = PluginAppConfig._internal();

  factory PluginAppConfig() {
    return _singleton;
  }

  PluginAppConfig._internal();

  AppEnvironment? appEnvironment;
  String? baseUrl;
  String? userPoolId;
  String? clientId;
  String? stripePublicKey;
  String? merchantId;
  String? googleAPIKey;
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
  }) {
    this.merchantId = merchantId ?? this.merchantId;
    this.stripePublicKey = stripePublicKey ?? this.stripePublicKey;
    this.appEnvironment = appEnvironment ?? this.appEnvironment;
    this.baseUrl = baseUrl ?? this.baseUrl;
    this.userPoolId = userPoolId ?? this.userPoolId;
    this.clientId = clientId ?? this.clientId;
    this.googleAPIKey = googleAPIKey ?? this.googleAPIKey;
    this.customKey = customKey ?? this.customKey;
  }
}
