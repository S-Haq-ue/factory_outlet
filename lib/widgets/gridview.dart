/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_items.dart';
import '../provider/products.dart';

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(15),
      itemBuilder: (context, index) => ChangeNotifierProvider(
        create: (context) => products[index],
        child: ProductItems(
            //products[index].id,
            //products[index].title,
            //products[index].imageUrl,
            ),
      ),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
*/
//import 'package:factory_outlet/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_items.dart';
import '../provider/products.dart';

class ProductGridView extends StatelessWidget {
  final bool showfavorite;
  ProductGridView(this.showfavorite);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final products =
        showfavorite ? productData.favoriteonly : productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(15),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItems(),
      ),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
/*

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_items.dart';
import '../provider/products.dart';

class ProductGridView extends StatelessWidget {
  final bool showfavorite;
  ProductGridView(this.showfavorite);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        showfavorite ? productData.favoriteonly : productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(15),
      itemBuilder: (context, index) => ChangeNotifierProvider(
        create: (context) => products[index],
        child: ProductItems(
            //products[index].id,
            //products[index].title,
            //products[index].imageUrl,
            ),
      ),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
*/