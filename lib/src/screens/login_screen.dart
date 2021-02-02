import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';
import '../utils/validators.dart';
import '../models/forms.dart';


class LoginScreen extends StatefulWidget {
  static final String route = '/login';

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginFormData _loginData = LoginFormData();
  bool _autovalidate=false;
  @override
  void initState() {
    super.initState();
    // _emailController.addListener(() {print(_emailController.text);});
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('email: ${_loginData.email} | password: ${_loginData.password}');
    }else{
      setState(() {
        _autovalidate=true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            // Provide key
            key: _formKey,
            autovalidate:_autovalidate,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    'Login And Explore',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  key: _emailKey,
                  onSaved: (value) => _loginData.email = value,
                  style: Theme.of(context).textTheme.headline5,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email!';
                    }

                    if(value.length<8){
                      return 'Minimum length of email is 8 characters!';
                    }

                    return emailValidator(value);
                  },
                  decoration: InputDecoration(hintText: 'Email Address'),
                ),
                TextFormField(
                  key: _passwordKey,
                  onSaved: (value) => _loginData.password = value,
                  style: Theme.of(context).textTheme.headline5,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a password';
                    }

                    if(value.length<8){
                      return 'Minimum length of password is 8 characters!';
                    }

                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                _buildLinks(),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: const Text('Submit'),
                      onPressed: _submit,
                    ))
              ],
            ),
          )),
      appBar: AppBar(title: Text('Login')),
    );
  }



  Widget _buildLinks() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Text(
              'Not Registered yet? Register Now!',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () => Navigator.pushNamed(context, RegisterScreen.route),
          ),
          GestureDetector(
            child: Text(
              'Continue to Home Screen',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () => Navigator.pushNamed(context, MeetupHomeScreen.route),
          ),
        ],
      ),
    );
  }
}
