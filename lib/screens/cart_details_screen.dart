import 'package:factory_outlet/provider/cart.dart';
import 'package:factory_outlet/provider/order.dart';
import 'package:factory_outlet/widgets/cart_details.dart';
import 'package:factory_outlet/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartDetailsScreen extends StatelessWidget {
  @override
  static const routename = "/cart-details-screen";
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CART",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "total ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('₹ ${cart.totalamount.toStringAsFixed(2)}'),
                  ),
                  ButtonWidget(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (ctx, i) => CartDetails(
                cart.item.values.toList()[i].id,
                cart.item.values.toList()[i].price,
                cart.item.values.toList()[i].quantity,
                cart.item.values.toList()[i].title,
                cart.item.keys.toList()[i],
              ),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
    );
  }
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalamount <= 0
          ? null
          : () {
              setState(() {
                _isloading = true;
              });
              Provider.of<Orders>(context, listen: false)
                  .addOrder(
                widget.cart.item.values.toList(),
                widget.cart.totalamount,
              )
                  .then((_) {
                setState(() {
                  _isloading = false;
                });
              });
              widget.cart.clearall();
            },
      child: _isloading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Text(
              "PLACE ORDER",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
    );
  }
}
