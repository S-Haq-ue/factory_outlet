import 'package:factory_outlet/provider/order.dart';
import 'package:factory_outlet/widgets/main_drawer.dart';
import 'package:factory_outlet/widgets/order_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routename = "/orders";

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor),
            );
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text("something went wrong"),
            );
          } else {
            return Consumer<Orders>(
              builder: (context, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => OrderDetails(orderData.orders[i]),
              ),
            );
          }
        },
      ),
      drawer: MainDrawer(),
    );
  }
}
