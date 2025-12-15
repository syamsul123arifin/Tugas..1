import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(child: Text('Cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.product.name),
                        subtitle: Text('Rp ${item.product.price} x ${item.quantity} = Rp ${item.totalPrice}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                cart.updateQuantity(item.product.id, item.quantity - 1);
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                cart.updateQuantity(item.product.id, item.quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                cart.removeItem(item.product.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total: Rp ${cart.totalAmount}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _paymentController,
                      decoration: InputDecoration(labelText: 'Payment Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final payment = int.tryParse(_paymentController.text) ?? 0;
                        if (payment < cart.totalAmount) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Insufficient payment')),
                          );
                          return;
                        }
                        final auth = Provider.of<AuthProvider>(context, listen: false);
                        try {
                          await cart.checkout(auth.token!, auth.user!.id, payment);
                          final change = payment - cart.totalAmount;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Checkout Successful'),
                              content: Text('Change: Rp $change'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Checkout failed: $e')),
                          );
                        }
                      },
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}