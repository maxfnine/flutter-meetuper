import 'package:flutter_meetuper/src/models/forms.dart';
import 'package:flutter_meetuper/src/models/user.dart';
import 'package:flutter_meetuper/src/utils/jwt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';


class AuthApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.100.102.21:3001/api/v1';
  String _token = '';
  User _authUser;

  static final AuthApiService _singleton = AuthApiService._internal();

  factory AuthApiService() {
    return _singleton;
  }

  AuthApiService._internal();

  set authUser(Map<String, dynamic> value) {
    _authUser = User.fromJSON(value);
  }

  get authUser => _authUser;

  Future<String> get token async {
    if (_token.isNotEmpty) {
      return _token;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }
  }

  Future<bool> _persistToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  Future<bool> _saveToken(String token) async {
    if (token != null) {
      await _persistToken(token);
      _token = token;
      return true;
    }

    return false;
  }

  Future<bool> isAuthenticated() async {
    final token = await this.token;
    if (token!=null && token.isNotEmpty) {
      final decodedToken = decode(token);
      final bool isValidToken = decodedToken['exp'] * 1000 > DateTime.now().millisecond;

      if (isValidToken) {
        authUser = decodedToken;
      }

      return isValidToken;
    }

    return false;
  }

  Future<void> _removeAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token='';
    _authUser=null;
  }

  Future<bool> logout() async{
    try{
     await _removeAuthData();
     return true;
    }
    catch(error){
      print(error);
      return false;
    }
  }

  Future<Map<String, dynamic>> login(LoginFormData loginData) async {
    final body = json.encode(loginData.toJSON());
    print(body);
    final res = await http.post('$url/users/login',
        headers: {"Content-Type": "application/json"},
        body: body);
    final parsedData = Map<String, dynamic>.from(json.decode(res.body));

    if (res.statusCode == 200) {
      await _saveToken(parsedData['token']);
      authUser = parsedData;
      return parsedData;
    } else {
      return Future.error(parsedData);
    }
  }
}
