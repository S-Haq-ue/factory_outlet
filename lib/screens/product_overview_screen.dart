import 'dart:ffi';

import 'package:factory_outlet/provider/cart.dart';
import 'package:factory_outlet/provider/products.dart';
import 'package:factory_outlet/screens/cart_details_screen.dart';
import 'package:factory_outlet/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../widgets/gridview.dart';
import '../widgets/main_drawer.dart';

import 'package:flutter/material.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showfavorite = false;
  var _init = true;
  var _isLoaded = false;
  @override
  void initState() {
    /*Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).loadData();
    });*/
    super.initState();
  }

  Future<void> _refresh() async {
    await Provider.of<Products>(context, listen: false).loadData();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoaded = true;
      });
      Provider.of<Products>(context).loadData().then((_) {
        setState(() {
          _isLoaded = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Store",
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.noItems.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartDetailsScreen.routename,
                );
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.All) {
                  _showfavorite = false;
                } else {
                  _showfavorite = true;
                }
              });
            },
            icon: Icon(
              Icons.filter_list_alt,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorite only"),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text("All Products"),
                value: FilterOptions.All,
              ),
            ],
          )
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refresh(),
              child: ProductGridView(_showfavorite),
            ),
    );
  }
}
