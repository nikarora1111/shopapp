import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth{
    print(token);
    return token!=null;
  }
  String get token{

    if(_expiryDate !=null && _expiryDate.isAfter(DateTime.now()) && _token!=null){
      print('true;');
      return _token;

    }
    print('ffff');
    return null;
    //if(DateTime.now()<_expiryDate)
  }
  Future<void> _authenticate(String email, String password, String type) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyDea5skGLAHyW_q33lT4x9Vgq8PAGYAkqs';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      //print(response.body.toString());
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData["error"]['message']);
        throw HttpException(responseData['error']['message']);
      }
      _token=responseData['idToken'];
      _userId=responseData['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      /*print(_token);
      print(_userId);
      print(_expiryDate.toString());*/
    } catch (e) {
      throw e;
    }
  }

//signUp
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  } //signInWithPassword

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
