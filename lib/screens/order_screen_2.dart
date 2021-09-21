import 'package:factory_outlet/provider/order.dart';
import 'package:factory_outlet/widgets/main_drawer.dart';
import 'package:factory_outlet/widgets/order_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routename = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isloaded = false;

  @override
  void initState() {
    _isloaded = true;
    //Future.delayed(Duration.zero).then((_) {
    Provider.of<Orders>(context, listen: false).loadOrders().then(
          (_) => setState(() {
            _isloaded = false;
          }),
        );

    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: _isloaded
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderDetails(orderData.orders[i]),
            ),
      drawer: MainDrawer(),
    );
  }
}
