import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

/// Is a class for help dio development better and more easy.
/// ```dart
/// final dioBaseHelper = DioBaseHelper("www.api.com");
/// ```
class DioBaseHelper {
  /// [_baseUrl]. is a parameter for input the base api url.
  /// ```dart
  /// final dioBaseHelper = DioBaseHelper("www.api.com");
  /// ```
  String _baseUrl = "";
  String? _token;
  String? _session;
  DioBaseHelper(String baseUrl, {String? token, String? session}) {
    _baseUrl = baseUrl;
    _token = token;
    _session = session;

    log('Constructor Initialized');
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
      // log('Error=======');
    }

    if (isDebugOn) {
      log('token===$_token');
    }
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': isAuthorize!
          ? _token != ''
              ? '$_token'
              : '$_session'
          : ""
    };

    if (showBodyInput) {
      log('BodyInputDebug:${json.encode(body)}');
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
        log("200=====${lastResponse.toString()}");
      }
      return lastResponse;
    } on DioError catch (e) {
      if (isDebugOn) {
        log('DioError:${e.message}');
      }
      return await _returnResponse(e.response!);
    }
  }

  Future<dynamic> onRequestFormData({
    /// A file to be uploaded as part of a [MultipartRequest]. This doesn't need to
    /// correspond to a physical file.
    ///
    /// MultipartFile is based on stream, and a stream can be read only once,
    /// so the same MultipartFile can't be read multiple times.
    String? endPoint,
    required Map<String, dynamic> formData,
    bool? isAuthorize = false,
    bool isDebugOn = false,
    bool showBodyInput = false,
  }) async {
    if (isDebugOn) {
      log('Token:$_token');
    }
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': isAuthorize!
          ? _token != ''
              ? '$_token'
              : '$_session'
          : ""
    };

    try {
      var dio = Dio();
      var fullUrl = _baseUrl + endPoint.toString();
      if (isDebugOn) {
        log('FullUrl:$fullUrl');
      }
      
      
      var data = FormData.fromMap(formData);
      if (showBodyInput) {
        log('BodyInputDebug:${data.files}');
      }
      Response response = await dio.post(fullUrl,
          data: data,
          options: Options(
            headers: header,
          ));

      var lastResponse = await _returnResponse(response);
      if (isDebugOn) {
        log("200=====${lastResponse.toString()}");
      }
      return lastResponse;
    } on DioError catch (e) {
      if (isDebugOn) {
        log('DioError:${e.message}');
        log('DioError:${e.error}');
        log('DioError:${e.stackTrace}');
        log('DioError:${e.response}');
        log('DioError:${e.type}');
      }
      if (e.response != null) {
        return await _returnResponse(e.response!);
      }
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
