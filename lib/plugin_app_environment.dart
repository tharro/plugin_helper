enum AppEnvironment { dev, stage, prod }

/// This plugin helps manage multiple environments in the project.
///
/// Example
///
/// main.dart
/// ```
/// void main() {
///    MyPluginAppEnvironment().setAppConfig(
///       appEnvironment: AppEnvironment.prod,
///       ...
///    );
/// }
/// ```
///
///
/// main_dev.dart
/// ```
/// void main() {
///    MyPluginAppEnvironment().setAppConfig(
///       appEnvironment: AppEnvironment.dev,
///       ...
///    );
/// }
/// ```
class MyPluginAppEnvironment {
  // Singleton object
  static final MyPluginAppEnvironment _singleton =
      MyPluginAppEnvironment._internal();

  factory MyPluginAppEnvironment() {
    return _singleton;
  }

  MyPluginAppEnvironment._internal();

  AppEnvironment? appEnvironment;

  /// A URL allows you to access an API and its various features.
  String? baseUrl;

  /// Set Cognito user pool (if any)
  String? userPoolId;

  /// Set Cognito clientId (if any)
  String? clientId;

  /// Stripe key is used to authenticate API requests.
  String? stripePublicKey;

  /// A merchant ID number—commonly called a merchant number
  /// or MID—is a 15-digit numerical identifier used to facilitate credit
  /// and debit card payments for your business. (if any)
  String? merchantId;

  /// Google API key is used to get address from Map API.
  String? googleAPIKey;

  /// A string combined with [linkCloudfront] to get link from cloudfront.
  /// Only use for image
  String? bucket;

  /// A domain combined with a key from the API and [bucket] creates
  /// a complete link to show the file from the server if [bucket] is not null.
  ///
  /// Example
  /// ```
  /// linkCloudfront: "https://dev.cloudfront.com/"
  ///
  /// String key = "image/background.jpg";
  /// String linkImage = '${MyPluginHelper.getLinkImage(key: key, width: 50, height: 50)'
  /// ```
  String? linkCloudfront;

  /// A domain combined with a key from the API creates
  /// a complete link to show the file from the server if [bucket] and [linkCloudfront] is null.
  ///
  /// Example
  /// ```
  /// linkS3: "https://dev.s3.com/"
  ///
  /// String key = "image/background.jpg";
  /// String linkImage = '${MyPluginAppEnvironment().linkS3}$key'
  /// ```
  String? linkS3;

  /// Customize another key. Please set key in the AppConstrain before use
  ///
  /// Example
  /// ```
  /// customKey: {
  ///   "AppConstrains.domainGo": "https://go.api/"
  /// }
  /// ```
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
    String? bucket,
    String? linkCloudfront,
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
    this.bucket = bucket ?? this.bucket;
    this.linkCloudfront = linkCloudfront ?? this.linkCloudfront;
  }
}
