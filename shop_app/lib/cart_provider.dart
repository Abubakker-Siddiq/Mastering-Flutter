import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cart = [];

  bool addProduct(Map<String, dynamic> product) {
    for (final currentProduct in cart) {
      if (currentProduct['title'] == product['title'] &&
          currentProduct['size'] == product['size']) {
        return false;
      }
    }
    cart.add(product);
    notifyListeners();
    return true;
  }

  void removeProduct(Map<String, dynamic> product) {
    cart.remove(product);
    notifyListeners();
  }
}
