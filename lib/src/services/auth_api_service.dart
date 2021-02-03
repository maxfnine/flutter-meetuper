import 'package:flutter_meetuper/src/models/forms.dart';
import 'package:flutter_meetuper/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class AuthApiService{
  static final AuthApiService _singleton = AuthApiService._internal();
  final String url=Platform.isIOS?'http://localhost:3001/api/v1':'http://10.100.102.21:3001/api/v1';
  String _token;
  User _authUser;

  set authUser(Map<String,dynamic> userData){
    _authUser=User.fromJSON(userData);
  }

  get authUser=>_authUser;

  bool _saveToken(String token){
    if(token!=null){
      _token=token;
      return true;
    }

    return false;
  }

  bool isAuthenticated(){
    if(_token!=null && _token.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  AuthApiService._internal();
  factory AuthApiService(){
    return _singleton;
  }

  Future<Map<String,dynamic>> login(LoginFormData loginData) async {
    final body = json.encode(loginData.toJSON());
    final response = await http.post('$url/users/login',body: body,headers: {'Content-Type':'application/json'});
    final parsedData  = Map<String,dynamic>.from(json.decode(response.body));
    if(response.statusCode==200){
      _saveToken(parsedData['token']);
      authUser=parsedData;
      print(_authUser);
      return parsedData;
    }else{
      return Future.error(parsedData);
    }
  }
}