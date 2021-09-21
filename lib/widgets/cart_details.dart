import 'package:factory_outlet/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartDetails extends StatelessWidget {
  final String id;
  final String prodId;
  final String title;
  final int quantity;
  final double price;
  //final List<CartItem> cartdata;
  CartDetails(
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.prodId,
    //this.cartdata,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.all(20),
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure"),
            content: Text(
              "Do you want remove item from the cart",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No"),
              )
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 3,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 35,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  child: Text(
                    '₹ $price',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).accentColor,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "total : ${(price * quantity)}",
                  ),
                  Text("Quantity : $quantity"),
                ],
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Cart>(context, listen: false)
                    .removesingleItem(prodId);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "The product is removed",
                    ),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      textColor: Theme.of(context).primaryColor,
                      label: "undo",
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .addItem(prodId, title, price);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ),
    );
  }
}
