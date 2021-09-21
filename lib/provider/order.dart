import 'dart:convert';

import './cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.datetime,
    @required this.amount,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  String authToken;
  String _userId;

  //Orders(this.authToken, this._orders);
  void update(String token, String userId, List<OrderItem> item) {
    authToken = token;
    _orders = orders;
    _userId = userId;
  }

  Future<void> loadOrders() async {
    Uri url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/Orders/$_userId.json?auth=$authToken');
    final List<OrderItem> _loadedOrders = [];
    try {
      final response = await http.get(url);
      //print(jsonDecode(response.body));
      final _extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (_extractedData == null) {
        return;
      }
      _extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(
          OrderItem(
              id: orderId,
              datetime: DateTime.parse(orderData['datetime']),
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((op) => CartItem(
                        id: op['id'],
                        title: op['title'],
                        quantity: op['quantity'],
                        price: op['price'],
                      ))
                  .toList()),
        );
      });
      _orders = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    Uri url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/Orders/$_userId.json?auth=$authToken');
    final timestamb = DateTime.now();

    final response = await http.post(
      url,
      body: jsonEncode({
        'datetime': timestamb.toIso8601String(),
        'amount': total,
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
          id: jsonDecode(response.body)['name'],
          datetime: timestamb,
          amount: total,
          products: cartProducts),
    );
    notifyListeners();
  }
}
