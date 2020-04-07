import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app_again/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
//  Future<void> authenticate (String email, String password, String urlSegment) async {
//    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCcpWGr7y1Q1mNAC-2TSyn36Feb4iP-4DU';
//    final response =  await http.post(url, body: json.encode({
//      'email' : email,
//      'password' : password,
//      'returnSecureToken':true
//    }));
//    print(json.decode(response.body));
//  }
//
//  Future<void> signUp(String email, String password) async {
//    return authenticate(email, password, 'signUp');
//  }
//
//  Future<void> login(String email, String password) async {
//  return authenticate(email, password, 'signInWithPassword');
//  }

  Future<void> signUp(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCcpWGr7y1Q1mNAC-2TSyn36Feb4iP-4DU';
    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    print(json.decode(response.body));
    if (response.statusCode >= 400) {
      throw HttpException(json.decode(response.body)['error']['message']);
    }
    _token = json.decode(response.body)['idToken'];
    _userId = json.decode(response.body)['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          json.decode(response.body)['expiresIn'],
        ),
      ),
    );
    _autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token' : _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
    },);
    prefs.setString('userData', userData);
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCcpWGr7y1Q1mNAC-2TSyn36Feb4iP-4DU';
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    if (json.decode(response.body)['error'] != null) {
      throw HttpException(json.decode(response.body)['error']['message']);
    }
    _token = json.decode(response.body)['idToken'];
    _userId = json.decode(response.body)['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          json.decode(response.body)['expiresIn'],
        ),
      ),
    );
    _autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      },
    );
    prefs.setString('userData', userData);
    print(json.decode(response.body));
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    print("Auto Login ");
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  bool get isAuth {
    return _token!=null;
  }

  String get token {
    if(_token!=null && _expiryDate!=null && _expiryDate.isAfter(DateTime.now())){
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }


  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

}
