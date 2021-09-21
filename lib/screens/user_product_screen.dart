//import 'dart:ffi';

import 'package:factory_outlet/provider/products.dart';
import 'package:factory_outlet/screens/edit_product_screen.dart';
import 'package:factory_outlet/widgets/main_drawer.dart';
import 'package:factory_outlet/widgets/user_product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = "/user-product-screen";

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).loadData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Products",
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (_, i) => UserProductDetails(
                            productData.items[i].id,
                            productData.items[i].title,
                            productData.items[i].imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: MainDrawer(),
    );
  }
}
