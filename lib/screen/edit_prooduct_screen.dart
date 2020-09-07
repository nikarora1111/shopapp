import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';

class EditProductSScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  _EditProductSScreenState createState() => _EditProductSScreenState();
}

class _EditProductSScreenState extends State<EditProductSScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var isinit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isinit) {
      isinit = false;
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async{
    final isValid = _form.currentState.validate();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _form.currentState.save();
      if (_editedProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        //Navigator.of(context).pop();
      } else {
        try{
         await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);

        }catch(error){
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('An error occured'),
                content: Text(error.toString()),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
        }/*finally{
          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).pop();
        }*/
        }
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
      //print(_editedProduct.title);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
        title: Text('Edit Products'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              autovalidate: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please Provide a value';
                        else
                          return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      decoration: InputDecoration(
                          labelText: 'Title', icon: Icon(Icons.title)),
                    ),
                    TextFormField(
                        initialValue: _initValues['price'],
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a price';
                          else if (double.parse(value) == null)
                            return 'Please enter a valid number';
                          else if (double.parse(value) <= 0)
                            return 'Please enter positive price';
                          else
                            return null;
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        decoration: InputDecoration(
                            labelText: 'Price',
                            icon: Icon(Icons.monetization_on)),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        }),
                    TextFormField(
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a description';
                        } else if (value.length < 15)
                          return ' description is too short';
                        else
                          return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          description: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      maxLines: 3,
                      //textInputAction: TextInputAction.,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          icon: Icon(Icons.description)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a url')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //initialValue: _initValues['imageUrl'],
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please Enter an Image URL';
                              if (!value.startsWith('https') &&
                                  !value.startsWith('http'))
                                return 'please entera valid url';
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('jpeg') &&
                                  !value.endsWith('jpg'))
                                return 'not valid url';
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                imageUrl: value,
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => {_saveForm()},
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
