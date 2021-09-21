import 'dart:async';
import 'dart:convert';

import 'package:factory_outlet/models/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expDate;
  String _userId;
  Timer _authtimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    print(_userId);
    return _userId;
  }

  String get token {
    if (_expDate != null &&
        _expDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _userLoginSignup(
      String emailid, String password, String urlkeyWORD) async {
    try {
      Uri url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlkeyWORD?key=AIzaSyB2C6u8HkWeqisanYsfxptgOagtnhEXvKY');
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': emailid,
          'password': password,
          'returnSecureToken': true
        }),
      );
      print(jsonDecode(response.body));
      final errorResponse = jsonDecode(response.body);
      if (errorResponse['error'] != null) {
        print(errorResponse['error']['message']);
        throw ErrorHandler(
          errorResponse['error']['message'],
        );
      }
      _token = errorResponse['idToken'];
      _userId = errorResponse['localId'];
      _expDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            errorResponse['expiresIn'],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
      print("error is ::" + errorResponse);

      final prefs = await SharedPreferences.getInstance();
      final prefData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expDate': _expDate.toIso8601String()
      });
      prefs.setString('prefData', prefData);
    } catch (error) {
      print("the error is =>>>");
      print(error);
      //throw ErrorHandler(error);
    }
  }

  Future<bool> isStayLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('prefData')) {
      return false;
    }
    final extrData =
        jsonDecode(prefs.getString('prefData')) as Map<String, Object>;
    final extractedTime = DateTime.parse(extrData['expDate']);
    if (extractedTime.isBefore(DateTime.now())) {
      return false;
    }
    _token = extrData['token'];
    _expDate = extractedTime;
    _userId = extrData['userId'];
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signUp(String emailid, String password) async {
    _userLoginSignup(emailid, password, 'signUp');
  }

  Future<void> logIn(String emailid, String password) async {
    _userLoginSignup(emailid, password, 'signInWithPassword');
  }

  void logOut() {
    _token = null;
    _expDate = null;
    _userId = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
    notifyListeners();
  }

  void autoLogout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final _exptimeIn = _expDate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: _exptimeIn), logOut);
  }
}
