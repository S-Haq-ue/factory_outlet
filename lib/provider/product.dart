import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  void _setbackagain(bool newvalue) {
    isFavorite = newvalue;
    notifyListeners();
  }

  Future<void> toggleFavoritestatus(String token, String userId) async {
    final currentfav = isFavorite;
    Uri url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavorite/$userId/$id.json?auth=$token');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: jsonEncode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setbackagain(currentfav);
      }
    } catch (error) {
      _setbackagain(currentfav);
    }
  }
}
