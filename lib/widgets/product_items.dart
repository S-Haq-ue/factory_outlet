import 'package:factory_outlet/provider/auth.dart';
import 'package:factory_outlet/provider/cart.dart';

import '../screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class ProductItems extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;
  //ProductItems(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routename,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              product.toggleFavoritestatus(authData.token, authData.userId);
            },
          ),
          title: Text(
            product.title,
            style: TextStyle(fontSize: 16.5),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              cart.addItem(
                product.id,
                product.title,
                product.price,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Product added to the cart",
                    style: TextStyle(fontSize: 18),
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    textColor: Theme.of(context).primaryColor,
                    label: "undo",
                    onPressed: () {
                      cart.removesingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
/*
import '../screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class ProductItems extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;
  //ProductItems(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routename,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                product.toggleFavoritestatus();
              },
            ),
            title: Text(
              product.title,
              style: TextStyle(fontSize: 16.5),
            ),
            trailing: Consumer<Product>(
              builder: (context, value, child) => IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
