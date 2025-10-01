import 'package:dio/dio.dart';
import '../config/keys.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Keys.API_BASE));

  ApiService() {
    _dio.options.connectTimeout = const Duration(milliseconds: 15000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 15000);
  }

  Future<Response> post(String path, Map<String, dynamic> data, {Map<String, dynamic>? headers}) async {
    return _dio.post(path, data: data, options: Options(headers: headers));
  }

  Future<Response> get(String path, {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    return _dio.get(path, queryParameters: params, options: Options(headers: headers));
  }
}
