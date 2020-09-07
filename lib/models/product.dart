import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Product with ChangeNotifier {
  final String title;
  final String id;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.title,
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    this.isFavorite=false,
    @required this.price
  });
  void _serFavValuw(bool oldStatus){
    isFavorite=oldStatus;
    notifyListeners();
  }
  Future<void> toggleFavoriteStatus() async{
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://shop-app-2341e.firebaseio.com/products/$id.json';
    try{
     final response= await http.patch(url,body: json.encode({
       'isFavorite': isFavorite
     }));
     if(response.statusCode>=400){
       _serFavValuw(oldStatus);
     }
     //notifyListeners();
    }catch(e){
        _serFavValuw(oldStatus);
    }
  }
}