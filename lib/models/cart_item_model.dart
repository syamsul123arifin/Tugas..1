import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  int get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'quantity': quantity,
    };
  }
}