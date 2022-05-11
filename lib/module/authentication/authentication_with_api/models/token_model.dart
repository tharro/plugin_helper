import 'package:plugin_helper/plugin_helper.dart';

class TokenModel extends Equatable {
  final String token;
  final String refreshToken;

  const TokenModel({required this.token, required this.refreshToken});

  factory TokenModel.fromJson(dynamic json) {
    return TokenModel(
        refreshToken: json['refresh_token'], token: json['token']);
  }

  TokenModel copyWith({String? token, String? refreshToken}) {
    return TokenModel(
        refreshToken: refreshToken ?? this.refreshToken,
        token: token ?? this.token);
  }

  @override
  List<Object?> get props => [refreshToken, token];
}
