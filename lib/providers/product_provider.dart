import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts(String token) async {
    try {
      final response = await ApiService().getProducts(token);
      final List<dynamic> productData = response['data'] ?? [];
      _products = productData.map((json) => Product.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      _products = [];
      notifyListeners();
      throw e;
    }
  }
}