import 'dart:async';
import 'package:get/get.dart';
import 'package:sm_web/infra/models/auth.dart';
import 'package:sm_web/infra/storage/session.dart';

class ApiClient {
  ApiClient(
    this.basePath, {
    String? apiUrl,
    Duration timeout = const Duration(minutes: 3),
  }) : _getConnect = GetConnect() {
    final resolvedApiUrl = apiUrl ?? ApiConfig.baseUrl;

    _getConnect.httpClient.baseUrl = _joinUrl(resolvedApiUrl, basePath);

    _getConnect.httpClient.timeout = timeout;

    _configureInterceptors();
  }

  final String basePath;
  final GetConnect _getConnect;

  static String _joinUrl(String server, String path) {
    final normalizedServer = server.endsWith('/')
        ? server.substring(0, server.length - 1)
        : server;

    final normalizedPath = path.isEmpty
        ? ''
        : path.startsWith('/')
        ? path
        : '/$path';

    return '$normalizedServer$normalizedPath';
  }

  void _configureInterceptors() {
    _getConnect.httpClient.addRequestModifier<dynamic>((request) {
      final token = SessionStorage.token;

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      return request;
    });

    _getConnect.httpClient.addResponseModifier<dynamic>((request, response) {
      return response;
    });
  }

  Future<ApiResponse> _request(
    String method,
    String? url, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
    Progress? uploadProgress,
  }) async {
    try {
      final response = await _getConnect.request<ApiResponse>(
        url ?? '/',
        method,
        body: body,
        contentType: contentType,
        query: query,
        uploadProgress: uploadProgress,
        headers: headers,
        decoder: (data) {
          return _decodeResponse(data, decoder);
        },
      );

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.failure(
        message: 'La solicitud excedió el tiempo de espera.',
        status: 408,
        codeError: 'WEB-TIMEOUT',
      );
    } catch (error) {
      return ApiResponse.failure(
        message: error.toString(),
        status: 500,
        codeError: 'WEB-500',
      );
    }
  }

  Future<ApiResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
  }) {
    return _request(
      'GET',
      url,
      headers: headers,
      query: query,
      decoder: decoder,
    );
  }

  Future<ApiResponse> post(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
    Progress? uploadProgress,
  }) {
    return _request(
      'POST',
      url,
      body: body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  Future<ApiResponse> put(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
    Progress? uploadProgress,
  }) {
    return _request(
      'PUT',
      url,
      body: body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  Future<ApiResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
  }) {
    return _request(
      'DELETE',
      url,
      headers: headers,
      query: query,
      decoder: decoder,
    );
  }

  Future<ApiResponse> multipart(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
    Progress? uploadProgress,
  }) {
    return _request(
      'POST',
      url,
      body: body,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
      contentType: 'multipart/form-data',
    );
  }

  ApiResponse _decodeResponse(dynamic data, Decoder? decoder) {
    try {
      if (data is! Map<String, dynamic>) {
        return ApiResponse.failure(
          message: 'La respuesta del servidor no tiene un formato válido.',
          status: 500,
          codeError: 'WEB-INVALID-RESPONSE',
        );
      }

      return ApiResponse.fromJson(data, decoder);
    } catch (error) {
      return ApiResponse.failure(
        message: error.toString(),
        status: 500,
        codeError: 'WEB-DECODE',
      );
    }
  }

  ApiResponse _handleResponse(Response<ApiResponse> response) {
    final body = response.body;

    if (response.statusCode == null) {
      return ApiResponse.failure(
        message: response.statusText ?? 'No se obtuvo respuesta del servidor.',
        status: 666,
        codeError: 'WEB-666',
      );
    }

    if (body?.token != null && body!.token!.isNotEmpty) {
      SessionStorage.setToken(body.token!);
      SessionStorage.save(AuthProfile.fromJson(body.data["user"]));
    }

    return body ??
        ApiResponse.failure(
          message:
              response.statusText ?? 'No se obtuvo respuesta del servidor.',
          status: response.statusCode!,
          codeError: 'WEB-${response.statusCode}',
        );
  }
}

abstract final class ApiConfig {
  static const String baseUrl = 'http://localhost:3001';
}

class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    required this.message,
    required this.status,
    required this.codeError,
    this.token,
  });

  final T? data;
  final String message;
  final int status;
  final String? codeError;
  final String? token;

  bool get isSuccess => status >= 200 && status < 300;
  bool get isError => !isSuccess;

  const ApiResponse.success({
    required T? data,
    String message = 'OK',
    int status = 200,
    String? token,
  }) : this(
         data: data,
         message: message,
         status: status,
         codeError: null,
         token: token,
       );

  const ApiResponse.failure({
    required String message,
    required int status,
    required String codeError,
  }) : this(data: null, message: message, status: status, codeError: codeError);

  factory ApiResponse.fromJson(Map<String, dynamic> json, Decoder<T>? decoder) {
    final rawData = json['data'];

    return ApiResponse<T>(
      data: rawData == null
          ? null
          : decoder == null
          ? rawData as T?
          : decoder(rawData),
      message: json['message']?.toString() ?? '',
      status: _parseStatus(json['status']),
      codeError: json['errorCode']?.toString(),
      token: json["data"]['token']?.toString(),
    );
  }

  static int _parseStatus(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 500;
  }
}
