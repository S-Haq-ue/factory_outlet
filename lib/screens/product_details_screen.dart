import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routename = "/product-details-screen";
  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(pId);
    return Scaffold(
      //appBar: AppBar(
      //  title: Text(),
      //),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                //style: Theme.of(context).textTheme.headline6,
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  height: 300,
                  width: double.infinity,
                  child: Image.network(loadedProduct.imageUrl),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 8,
                ),
                Text(
                  "₹ ${loadedProduct.price}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19),
                  softWrap: true,
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
