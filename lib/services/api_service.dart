import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else {
      return 'http://10.0.2.2:8000/api';
    }
  }
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> getProducts(String token) async {
    try {
      debugPrint('ApiService: Fetching products from ${baseUrl}/products');
      final response = await _dio.get(
        '/products',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint('ApiService: Products response status: ${response.statusCode}');
      debugPrint('ApiService: Products response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      debugPrint('ApiService: DioException - ${e.message}');
      debugPrint('ApiService: Response data: ${e.response?.data}');
      debugPrint('ApiService: Response status: ${e.response?.statusCode}');
      throw Exception('Failed to get products: ${e.response?.data ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> getRecommendations(String token, int productId) async {
    try {
      final response = await _dio.get(
        '/recommendations',
        queryParameters: {'product_id': productId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get recommendations: ${e.response?.data ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> checkout(String token, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '/checkout',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Checkout failed: ${e.response?.data ?? e.message}');
    }
  }
}