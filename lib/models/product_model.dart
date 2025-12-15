import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final int price;
  final int stock;
  final String barcode;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.barcode,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String,
      price: int.tryParse(json['price'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      barcode: json['barcode'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'barcode': barcode,
      'image_url': imageUrl,
    };
  }
}