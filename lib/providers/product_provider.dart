import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      debugPrint('ProductProvider: Token retrieved: ${token != null ? 'present' : 'null'}');
      if (token == null) throw Exception('No token found');
      debugPrint('ProductProvider: Fetching products...');
      final response = await ApiService().getProducts(token);
      debugPrint('ProductProvider: Response received');
      final List<dynamic> productData = response['data'] ?? [];
      debugPrint('ProductProvider: Product data length: ${productData.length}');
      _products = productData.map((json) => Product.fromJson(json)).toList();
      debugPrint('ProductProvider: Products loaded: ${_products.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('ProductProvider: Error fetching products: $e');
      _products = [];
      notifyListeners();
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}