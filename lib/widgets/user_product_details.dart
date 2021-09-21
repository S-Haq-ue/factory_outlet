import 'package:factory_outlet/provider/products.dart';
import 'package:factory_outlet/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductDetails extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductDetails(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).accentColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('ARE YOU SURE'),
                    content: Text('Do you want delete this product'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Provider.of<Products>(context, listen: false)
                                .removeProduct(id)
                                .then((_) {
                              Navigator.of(context).pop();
                            }).catchError((_) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Something went wrong!.an error occured!!",
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            });
                          },
                          child: Text("Yes")),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No"),
                      ),
                    ],
                  ),
                );
                //Provider.of<Products>(context, listen: false).removeProduct(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
