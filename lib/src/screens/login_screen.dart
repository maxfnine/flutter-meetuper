import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';
import '../services/auth_api_service.dart';
import '../utils/validators.dart';
import '../models/forms.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';
  final AuthApiService _authApiService = AuthApiService();

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
  BuildContext _scaffoldContext;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    widget._authApiService.login(_loginData).then((data) {
      Navigator.pushNamed(context, MeetupHomeScreen.route);
    }).catchError((error) {
      Scaffold.of(_scaffoldContext).showSnackBar(
        SnackBar(
          content: Text(error['errors']['message']),
        ),
      );
    });
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          _scaffoldContext = context;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              // Provide key
              key: _formKey,
              autovalidate: _autovalidate,
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Login And Explore',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    key: _emailKey,
                    onSaved: (value) => _loginData.email = value,
                    style: Theme.of(context).textTheme.headline5,
                    validator: composeValidators(
                        'email', [requiredValidator, minLengthValidator]),
                    decoration: InputDecoration(hintText: 'Email Address'),
                  ),
                  TextFormField(
                    key: _passwordKey,
                    obscureText: true,
                    onSaved: (value) => _loginData.password = value,
                    style: Theme.of(context).textTheme.headline5,
                    validator: composeValidators(
                        'password', [requiredValidator, minLengthValidator]),
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
            ),
          );
        },
      ),
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
