import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders=[];
  List<OrderItem> get orders{
    return [..._orders];
  }
  Future<void> adddOrder(List<CartItem> cartProduct,double total) async{
    const url = 'https://shop-app-2341e.firebaseio.com/orders.json';
    final timestamp =DateTime.now();
    final response = await http.post(url,body: json.encode({
      'amount':total,
      'dateTime': timestamp.toIso8601String(),
      'products':cartProduct.map((cp)=>{
        'id':cp.id,
        'title':cp.title,
        'quantity':cp.quantity,
        'price':cp.price,
      }).toList(),
    }));
    _orders.insert(0,OrderItem(id: json.decode(response.body)['name'], amount:total , products: cartProduct, dateTime: DateTime.now()));
  }

  Future<void> fetchAndSetOrders() async{
    const url = 'https://shop-app-2341e.firebaseio.com/orders.json';
    final response  = await http.get(url);
    //print(json.decode(response.body));
    final List<OrderItem> loadedOrdes=[];
    final extractedData = json.decode(response.body) as Map<String,dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId,orderData){
              loadedOrdes.insert(0, OrderItem(id: orderId, amount: orderData['amount'], products: (orderData['products'] as List<dynamic>).map((item)=>CartItem(price: item['price'],quantity: item['quantity'],title: item['title'],id: item['id'])).toList(), dateTime:DateTime.parse(orderData['dateTime'])));
    });
    _orders=loadedOrdes.reversed.toList();
    notifyListeners();
  }

}
