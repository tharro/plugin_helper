import 'dart:collection';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:plugin_helper/plugin_authentication.dart';
import 'package:plugin_helper/plugin_helper.dart';
import 'package:plugin_helper/plugin_message_require.dart';

//This plugin had used to make the HTTP method request
enum Method { post, put, patch, delete, get }

class MyPluginApi {
  static final dio = Dio();

  Future<Response> request(
    url,
    Method method, {
    body,
    Map<String, dynamic>? params,
    useIDToken = true,
    headersOverwrite,
    customContentType,
    Map<String, dynamic>? customHeader,
    Map<String, dynamic>? headerAddition,
    Function(int, int)? onSendProgress,
    Options? cacheOptions,
  }) async {
    Map headers = {
      'cache-control': 'cache',
      'Content-Type': customContentType ?? 'application/json',
      'Connection': 'keep-alive'
    };

    if (useIDToken) {
      if (await MyPluginAuthentication.hasToken()) {
        if (!await MyPluginAuthentication.checkTokenValidity()) {
          await MyPluginAuthentication.refreshToken();
        }
      }
      final users = await MyPluginAuthentication.getUser();
      headers['Authorization'] = 'Bearer ${users.token}';
    }

    var combinedMap = headers;
    if (headersOverwrite != null) {
      var mapList = [headers, headersOverwrite];
      combinedMap = mapList.reduce((map1, map2) => map1..addAll(map2));
    }
    Map<String, dynamic> header = customHeader ?? HashMap.from(combinedMap);
    if (headerAddition != null) {
      header.addAll(headerAddition);
    }
    String _languageCode = await MyPluginHelper.getLanguage();
    if (params != null) {
      params = params..addAll({'language_code': _languageCode});
    } else {
      params = {'language_code': _languageCode};
    }

    try {
      if (method == Method.post) {
        return await dio.post(url,
            data: body,
            options: Options(
              headers: header,
            ),
            queryParameters: params,
            onSendProgress: onSendProgress);
      } else if (method == Method.put) {
        return await dio.put(
          url,
          data: body,
          options: Options(headers: header),
          queryParameters: params,
          onSendProgress: onSendProgress,
        );
      } else if (method == Method.patch) {
        return await dio.patch(url,
            data: body,
            options: Options(headers: header),
            queryParameters: params);
      } else if (method == Method.delete) {
        return await dio.delete(url,
            options: Options(headers: header),
            data: body,
            queryParameters: params);
      }

      return await dio.get(url,
          options: cacheOptions != null
              ? cacheOptions.copyWith(headers: header)
              : Options(headers: header),
          queryParameters: params);
    } catch (e) {
      print("📕 error at api: $url");
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        throw PlatformException(
          code: 'NOT_CONNECTED',
          message: MyPluginMessageRequire.noConnection,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<Response<dynamic>> requestUploadFile(url, Method method, File file,
      {String? typeFile,
      Map<String, dynamic>? body,
      Map<String, dynamic>? customHeader,
      Function(int, int)? onSendProgress}) async {
    String fileName = file.path.split('/').last;
    String mimeType = mime(fileName)!;
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    FormData data = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(file.path,
            filename: fileName,
            contentType: MediaType(mimee, typeFile ?? type)),
      }..addAll(body ?? {}),
    );

    return await request(url, method, customHeader: customHeader, body: data,
        onSendProgress: (value, total) {
      if (onSendProgress != null) {
        onSendProgress(value, total);
      }
    });
  }
}
