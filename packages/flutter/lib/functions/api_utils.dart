import 'dart:developer' as dev;
import 'package:dio/dio.dart';

class ApiUtil {
  // Setting bawaan Dio (Disesuaikan untuk Dio v4 ke bawah)
  static Dio _getDio() {
    Dio dio = Dio();
    // Timeout pakai Integer (Milidetik). 30000 = 30 detik.
    dio.options.connectTimeout = 30000;
    dio.options.sendTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    return dio;
  }

  // Bantuan untuk menyusun Header (Token dll) secara dinamis
  static Options _buildOptions(String? token, Options? customOptions, bool isDebug) {
    Map<String, dynamic> headers = {
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
      "debug-mode": isDebug ? "true" : "false"
    };

    if (customOptions != null) {
      headers.addAll(customOptions.headers ?? {});
    }

    return Options(headers: headers);
  }

  // ===========================================================================
  // 1. POST CALL
  // ===========================================================================
  static Future<dynamic> postCall({
    required String path,
    dynamic params, 
    String? token,
    Options? options,
    Map<String, dynamic>? queryParams,
    bool isDebug = false,
  }) async {
    try {
      Dio dio = _getDio();
      var finalOptions = _buildOptions(token, options, isDebug);

      if (isDebug) {
        dev.log(params is FormData ? params.fields.toString() : params.toString(), name: "POST_PARAM");
        dev.log("Path: $path", name: "POST_PATH");
      }

      var finalParams = params is Map<String, dynamic> ? FormData.fromMap(params) : params;

      Response response = await dio.post(
        path,
        data: finalParams,
        options: finalOptions,
        queryParameters: queryParams,
      );

      if (isDebug) dev.log("Headers Request: ${response.requestOptions.headers}");
      return response.data;

    // Menggunakan DioError untuk versi lama
    } on DioError catch (e) {
      if (isDebug) dev.log("Dio Error: ${e.message}", name: "POST_ERROR");
      rethrow; 
    }
  }

  // ===========================================================================
  // 2. GET CALL
  // ===========================================================================
  static Future<dynamic> getCall({
    required String path,
    String? token,
    Options? options,
    Map<String, dynamic>? queryParams,
    bool isDebug = false,
  }) async {
    try {
      Dio dio = _getDio();
      var finalOptions = _buildOptions(token, options, isDebug);

      if (isDebug) dev.log("Path: $path | Query: $queryParams", name: "GET_PATH");

      Response response = await dio.get(
        path,
        options: finalOptions,
        queryParameters: queryParams,
      );

      return response.data;
    } on DioError catch (e) {
      if (isDebug) dev.log("Dio Error: ${e.message}", name: "GET_ERROR");
      rethrow;
    }
  }

  // ===========================================================================
  // 3. PUT CALL (Untuk Update Data)
  // ===========================================================================
  static Future<dynamic> putCall({
    required String path,
    dynamic params,
    String? token,
    Options? options,
    Map<String, dynamic>? queryParams,
    bool isDebug = false,
  }) async {
    try {
      Dio dio = _getDio();
      var finalOptions = _buildOptions(token, options, isDebug);

      var finalParams = params is Map<String, dynamic> ? FormData.fromMap(params) : params;

      Response response = await dio.put(
        path,
        data: finalParams,
        options: finalOptions,
        queryParameters: queryParams,
      );

      return response.data;
    } on DioError catch (e) {
      if (isDebug) dev.log("Dio Error: ${e.message}", name: "PUT_ERROR");
      rethrow;
    }
  }

  // ===========================================================================
  // 4. DELETE CALL (Untuk Hapus Data)
  // ===========================================================================
  static Future<dynamic> deleteCall({
    required String path,
    dynamic data,
    String? token,
    Options? options,
    Map<String, dynamic>? queryParams,
    bool isDebug = false,
  }) async {
    try {
      Dio dio = _getDio();
      var finalOptions = _buildOptions(token, options, isDebug);

      Response response = await dio.delete(
        path,
        data: data,
        options: finalOptions,
        queryParameters: queryParams,
      );

      return response.data;
    } on DioError catch (e) {
      if (isDebug) dev.log("Dio Error: ${e.message}", name: "DELETE_ERROR");
      rethrow;
    }
  }
}