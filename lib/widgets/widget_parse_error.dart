import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:plugin_helper/plugin_message_require.dart';

class ParseError extends Equatable {
  final String code;
  final String message;
  const ParseError({
    required this.code,
    required this.message,
  });
  @override
  List<Object> get props => [code, message];

  static ParseError fromJson(dynamic error) {
    String code = '-1';
    String message = PluginMessageRequire.messUnHandleError;
    DataError dataError;
    if (error is CognitoClientException && error.code == 'NetworkError') {
      return ParseError(
        code: '${error.code}',
        message: PluginMessageRequire.messNoConnection,
      );
    } else if (error is PlatformException) {
      message = '${error.message}';
    } else if (error is DioError) {
      code = error.response?.statusCode?.toString() ?? '';
      if (error.response?.data is Map) {
        dataError = DataError.fromJson(error.response!.data);
        code = dataError.rCode;
        message = dataError.rMessage;
      } else {
        if (code == '503') {
          message = PluginMessageRequire.messService503;
        } else {
          message = error.message;
        }
      }
    } else {
      if (error is Map) {
        dataError = DataError.fromJson(error);
        code = dataError.rCode;
        message = dataError.rMessage;
      } else if (error is CognitoClientException) {
        code = error.code ?? code;
        message = error.message ?? message;
        if (error.code == 'NotAuthorizedException') {
          message = PluginMessageRequire.messNotAuthorizedException;
        }
      } else {
        message = error.toString();
      }
    }

    return ParseError(
      code: code,
      message: message,
    );
  }
}

class DataError extends Equatable {
  final String rCode;
  final String rMessage;

  const DataError({required this.rCode, required this.rMessage});

  @override
  List<Object?> get props => [rCode, rMessage];

  static DataError fromJson(dynamic json) {
    return DataError(
      rCode: json['code'],
      rMessage: json['message'] is String
          ? json['message']
          : jsonEncode(json['message']),
    );
  }
}
