import 'package:factory_outlet/provider/auth.dart';
import 'package:factory_outlet/screens/order_screen.dart';
import 'package:factory_outlet/screens/user_product_screen.dart';
import 'package:factory_outlet/widgets/user_product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              "good day",
              style: Theme.of(context).textTheme.headline6,
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          Container(
            height: 200,
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(
                "Factory store",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 28,
            ),
            title: Text("Store"),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
              size: 28,
            ),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routename);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 28,
            ),
            title: Text("Product Management"),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routename);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 28,
            ),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
