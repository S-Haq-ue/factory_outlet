import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get item {
    return {..._items};
  }

  double get totalamount {
    var total = 0.0;
    _items.forEach(
      (key, cartitem) {
        total += cartitem.price * cartitem.quantity;
      },
    );
    return total;
  }

  int get noItems {
    return _items.length;
  }

  void addItem(
    String prodId,
    String title,
    double price,
  ) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity + 1,
              price: existing.price));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void clearall() {
    _items = {};
    notifyListeners();
  }

  void removesingleItem(String prodId) {
    if (_items[prodId].quantity > 1) {
      _items.update(
        prodId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity - 1,
          price: existing.price,
        ),
      );
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }
}
