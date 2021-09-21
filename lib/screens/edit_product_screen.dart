import 'package:factory_outlet/provider/product.dart';
import 'package:factory_outlet/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURL = FocusNode();
  final _imageURLcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _init = true;
  var _isLoading = false;

  var _initvalue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageURL.addListener(_previewImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _newProduct = Provider.of<Products>(context).findById(prodId);
        _initvalue = {
          'title': _newProduct.title,
          'description': _newProduct.description,
          'price': _newProduct.price.toString(),
          'imageUrl': '',
        };
        _imageURLcontroller.text = _newProduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  void dispose() {
    _imageURL.removeListener(_previewImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURL.dispose();
    _imageURLcontroller.dispose();
    super.dispose();
  }

  void _previewImage() {
    if (!_imageURL.hasFocus) {
      if (!_imageURLcontroller.text.startsWith('http') &&
          !_imageURLcontroller.text.startsWith('https') &&
          !_imageURLcontroller.text.endsWith('.jpg') &&
          !_imageURLcontroller.text.endsWith('.jpeg') &&
          !_imageURLcontroller.text.endsWith('.png')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_newProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addData(_newProduct);
      } catch (error) {
        await showDialog<Null>(
          barrierColor: Colors.black45,
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Some error occured!!"),
            content: Text("Something went wrong."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Okay"),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .editProduct(_newProduct.id, _newProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add product",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initvalue['title'],
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the data.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: newValue,
                          description: _newProduct.description,
                          price: _newProduct.price,
                          imageUrl: _newProduct.imageUrl,
                          isFavorite: _newProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                        initialValue: _initvalue['price'],
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please add price here.";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please add a valid number.";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please add price that greaterthan zero.";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _newProduct = Product(
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: _newProduct.description,
                            price: double.parse(newValue),
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite,
                          );
                        }),
                    TextFormField(
                        initialValue: _initvalue['description'],
                        decoration: InputDecoration(labelText: "Description"),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter the description.";
                          }
                          if (value.length < 10) {
                            return "Description is too short.";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _newProduct = Product(
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: newValue,
                            price: _newProduct.price,
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite,
                          );
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 3,
                            ),
                          ),
                          height: 100,
                          width: 100,
                          //alignment: Alignment.center,
                          child: _imageURLcontroller.text.isEmpty
                              ? Text("No url is detected")
                              : FittedBox(
                                  fit: BoxFit.contain,
                                  child:
                                      Image.network(_imageURLcontroller.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Image URL",
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLcontroller,
                            focusNode: _imageURL,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a image URL.";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return "This URL cannot be found.";
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.png')) {
                                return "this URL not belongs to a image.";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _newProduct = Product(
                                id: _newProduct.id,
                                title: _newProduct.title,
                                description: _newProduct.description,
                                price: _newProduct.price,
                                imageUrl: newValue,
                                isFavorite: _newProduct.isFavorite,
                              );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
