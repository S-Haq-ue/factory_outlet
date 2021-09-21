import 'dart:convert';
import 'dart:ffi';
//import 'dart:html';

import './product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/error_handling.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];*/

  var ttoken;
  var userId;
  //Products(this.token, this._items);

  void update(String token, String uuuserId, List<Product> items) {
    ttoken = token;
    userId = uuuserId;
    _items = items;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteonly {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prdct) => prdct.id == id);
  }

  Future<void> loadData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json?auth=$ttoken&$filterString');

    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        //print("product is null");
        return null;
      }
      url = Uri.parse(
          'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavorite/$userId.json?auth=$ttoken');

      final favoriteresponse = await http.get(url);
      final favoriteData = json.decode(favoriteresponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: //favoriteData[prodId],
                favoriteData == null ? false : favoriteData[prodId],
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedProduct;
    } catch (error) {
      //throw error;
    }
  }

  Future<void> addData(Product product) async {
    final Uri url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/Products.json?auth=$ttoken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final responseDATA = await http.get(url);
      print(json.decode(responseDATA.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      //throw error;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    final prodIntex = _items.indexWhere((prod) => prod.id == id);
    final Uri url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/Products/$id.json?auth=$ttoken');
    await http.patch(url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }));
    if (prodIntex >= 0) {
      _items[prodIntex] = product;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> removeProduct(String id) async {
    final prodIntex = _items.indexWhere((prod) => prod.id == id);
    //_items.removeWhere((prod) => prod.id == id);
    var removedProduct = _items[prodIntex];
    final Uri url = Uri.parse(
        'https://factory-store-1-default-rtdb.asia-southeast1.firebasedatabase.app/Products/$id.json?auth=$ttoken');
    _items.removeAt(prodIntex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(prodIntex, removedProduct);
      notifyListeners();
      throw ErrorHandler('couldnot delete the product.');
    }
    removedProduct = null;
  }
}
