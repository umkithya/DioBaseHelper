import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioBaseHelper {
  String _baseUrl = "";
  String? _token;
  String? _session;
  DioBaseHelper(String baseUrl, {String? token, String? session}) {
    _baseUrl = baseUrl;
    _token = token;
    _session = session;

    debugPrint('Constructor Initialized');
  }

  Future<dynamic> onRequest({
    String? endPoint,
    required METHODE? methode,
    Map<dynamic, dynamic>? body,
    bool? isAuthorize = false,
    bool isDebugOn = false,
    bool showBodyInput = false,
  }) async {
    if (methode != METHODE.get && body == null) {
      throw Exception('Body must not be null of $methode');
      // debugPrint('Error=======');
    }

    if (isDebugOn) {
      debugPrint('token===$_token');
    }
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': isAuthorize!
          ? _token != ''
              ? 'Token $_token'
              : 'Token $_session'
          : ""
    };

    if (showBodyInput) {
      debugPrint('BodyInputDebug:${json.encode(body)}');
    }
    try {
      var dio = Dio();
      var fullUrl = "$_baseUrl$endPoint";
      late Response response;
      switch (methode) {
        case METHODE.get:
          {
            response = await dio.get(fullUrl,
                options: Options(
                  headers: header,
                ));
            break;
          }
        case METHODE.post:
          {
            response = await dio.post(fullUrl,
                data: json.encode(body),
                options: Options(
                  headers: header,
                ));
            break;
          }
        case METHODE.put:
          {
            response = await dio.put(fullUrl,
                data: json.encode(body),
                options: Options(
                  headers: header,
                ));
            break;
          }
        case METHODE.delete:
          {
            response = await dio.delete(fullUrl,
                data: json.encode(body),
                options: Options(
                  headers: header,
                ));
            break;
          }
        default:
          break;
      }

      var lastResponse = await _returnResponse(response);
      if (isDebugOn) {
        debugPrint("200=====${lastResponse.toString()}");
      }
      return lastResponse;
    } on DioError catch (e) {
      if (isDebugOn) {
        debugPrint('DioError:${e.message}');
      }
      return await _returnResponse(e.response!);
    }
  }

  Future<dynamic> onRequestFormData({
    String? endPoint,
    required String filePath,
    bool? isAuthorize = false,
    bool isDebugOn = false,
    bool showBodyInput = false,
  }) async {
    // if (methode != METHODE.get && body == null) {
    //   throw Exception('Body must not be null of $methode');
    //   // debugPrint('Error=======');
    // }

    if (isDebugOn) {
      debugPrint('token===$_token');
    }
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': isAuthorize!
          ? _token != ''
              ? 'Token $_token'
              : 'Token $_session'
          : ""
    };

    if (showBodyInput) {
      // debugPrint('BodyInputDebug:${json.encode(body)}');
    }
    try {
      var dio = Dio();
      var fullUrl = _baseUrl + endPoint.toString();
      var formData = FormData.fromMap({
        'username': "+855963288307",
        'file': await MultipartFile.fromFile(filePath),
      });
      Response response = await dio.post(fullUrl,
          data: formData,
          options: Options(
            headers: header,
          ));

      var lastResponse = await _returnResponse(response);
      if (isDebugOn) {
        debugPrint("200=====${lastResponse.toString()}");
      }
      return lastResponse;
    } on DioError catch (e) {
      if (isDebugOn) {
        debugPrint('DioError:${e.message}');
      }
      return await _returnResponse(e.response!);
    }
  }

  dynamic _returnResponse(Response response) async {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 202:
        return response.data;
      case 302:
        return response.data;
      case 400:
        return Future.error(ErrorModel(
            statusCode: response.statusCode, bodyString: response.data));
      case 401:
        return Future.error(ErrorModel(
            statusCode: response.statusCode, bodyString: response.data));
      case 404:
        return Future.error(ErrorModel(
            statusCode: response.statusCode, bodyString: response.data));
      case 403:
        return Future.error(ErrorModel(
            statusCode: response.statusCode, bodyString: response.data));
      case 500:
        return Future.error(ErrorModel(
            statusCode: response.statusCode, bodyString: response.data));

      default:
        return Future.error(ErrorModel(
            statusCode: response.statusCode,
            bodyString: response.data ?? 'Error'));
    }
  }
}

class ErrorModel {
  final int? statusCode;
  final dynamic bodyString;
  final String? message;
  const ErrorModel({
    this.statusCode,
    this.bodyString,
    this.message,
  });
}

enum METHODE {
  get,
  post,
  delete,
  put,
}
