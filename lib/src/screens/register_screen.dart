import 'package:flutter/material.dart';
import 'login_screen.dart';
class RegisterScreen extends StatefulWidget {
  static const String route = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : FlatButton(
        onPressed: () => Navigator.pushNamed(context, LoginScreen.route),
        child: Text('Go to Login Screen'),
      ),
      appBar: AppBar(
        title: Text('Register'),
      ),
    );
  }
}
