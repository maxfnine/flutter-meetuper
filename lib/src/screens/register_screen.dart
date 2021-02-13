import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetuper/src/models/arguments.dart';
import 'package:flutter_meetuper/src/models/forms.dart';
import 'package:flutter_meetuper/src/utils/validators.dart';
import '../services/auth_api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  final AuthApiService _authApiService=AuthApiService();

  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // 1. Create GlobalKey for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext _scaffoldContext;
  // 2. Create autovalidate
  bool _autovalidate = false;
  // 3. Create instance of RegisterFormData
  RegisterFormData _registerData = RegisterFormData();
  // 4. Create Register function and print all of the data

  _handleSuccess(dynamic data){
    Navigator.pushNamedAndRemoveUntil(context,
        LoginScreen.route,
            (route) => false,
    arguments: LoginScreenArguments('You have been successfully registered, feel free to login now :)'),);
  }

  _handleError(response){

      Scaffold.of(_scaffoldContext).showSnackBar(
        SnackBar(
          content: Text(response['errors']['message']),
        ),
      );

  }

  _register(){
    widget._authApiService.register(_registerData)
        .then(_handleSuccess)
        .catchError(_handleError);
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_registerData.toJSON());
      _register();
    } else {
      setState(() => _autovalidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Register')
        ),
        body: Builder(
            builder: (context) {
              _scaffoldContext=context;
              return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    // 5. Form Key
                    key: _formKey,
                    autovalidate: _autovalidate,
                    child: ListView(
                      children: [
                        _buildTitle(),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline,
                          decoration: InputDecoration(
                            hintText: 'Name',
                          ),
                          // 6. Required Validator
                          validator: composeValidators('name', [requiredValidator]),
                          // 7. onSaved - save data to registerFormData
                          onSaved: (value) => _registerData.name = value,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline,
                          decoration: InputDecoration(
                            hintText: 'Username',
                          ),
                          validator: composeValidators('username', [requiredValidator]),
                          onSaved: (value) => _registerData.username = value,
                        ),
                        TextFormField(
                            style: Theme.of(context).textTheme.headline,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                            ),
                            validator: composeValidators('email', [requiredValidator, emailValidator]),
                            onSaved: (value) => _registerData.email = value,
                            keyboardType: TextInputType.emailAddress
                        ),
                        TextFormField(
                            style: Theme.of(context).textTheme.headline,
                            decoration: InputDecoration(
                              hintText: 'Avatar Url',
                            ),
                            onSaved: (value) => _registerData.avatar = value,
                            keyboardType: TextInputType.url
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline,
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                          validator: composeValidators('password', [requiredValidator]),
                          onSaved: (value) => _registerData.password = value,
                          obscureText: true,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline,
                          decoration: InputDecoration(
                            hintText: 'Password Confirmation',
                          ),
                          validator: composeValidators('password confirmation', [requiredValidator]),
                          onSaved: (value) => _registerData.passwordConfirmation = value,
                          obscureText: true,
                        ),
                        _buildLinksSection(),
                        _buildSubmitBtn()
                      ],
                    ),
                  )
              );
            }
        )
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
        alignment: Alignment(-1.0, 0.0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          child: const Text('Submit'),
          onPressed:_submit,
        )
    );
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context,LoginScreen.route ,(route) => false);
            },
            child: Text(
              'Already Registered? Login Now.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/meetups");
              },
              child: Text(
                'Continue to Home Page',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              )
          )
        ],
      ),
    );
  }
}