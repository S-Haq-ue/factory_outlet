//import 'dart:html';

import './provider/auth.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './screens/auth_screen.dart';
import './screens/cart_details_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_product_screen.dart';

import './provider/products.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (ctx, auth, prevProduct) => prevProduct
            ..update(
              auth.token,
              auth.userId,
              prevProduct == null ? [] : prevProduct.items,
            ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (ctx, auth, previousOrders) => previousOrders
            ..update(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
        ),
      ],
      git config --global user.email "shameemulhaquep@gmail.com"
  git config --global user.name "Shameemul Haque"
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Factory_Stores",
          theme: ThemeData(
              accentColor: Colors.brown.shade400,
              primaryColor: Colors.amberAccent.shade100,
              errorColor: Colors.red,
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
          home: auth.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: auth.isStayLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routename: (ctx) => ProductDetailsScreen(),
            CartDetailsScreen.routename: (ctx) => CartDetailsScreen(),
            OrderScreen.routename: (ctx) => OrderScreen(),
            UserProductScreen.routename: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
