import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitty_mingsi_flutter/components/StandardButtonWidget.dart';
import 'package:kitty_mingsi_flutter/bloc/AuthenticationBloc.dart';
import 'package:bloc/bloc.dart';
import 'package:kitty_mingsi_flutter/bloc/events/AuthenticationEvent.dart';
import 'package:kitty_mingsi_flutter/bloc/states/AuthenticationState.dart';
import 'package:kitty_mingsi_flutter/components/DefaultLoadingIndicator.dart';

class LoginForm extends StatefulWidget {
  AuthenticationBloc authBloc;
  LoginForm(this.authBloc);

  _LoginFormState createState() => _LoginFormState(authBloc);
}

class _LoginFormState extends State<LoginForm> {
  final AuthenticationBloc authBloc;
  AuthenticationState _authState;
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool _autovalidate = false;
  var color;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _LoginFormState(this.authBloc);

  @override
  Widget build(BuildContext context) {
    //DEBUG
    emailController.text = "test@test.com";
    passwordController.text = "123456";
    color = Theme.of(context).accentColor;

    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: authBloc,
        builder: (
          BuildContext context,
          AuthenticationState authState,
        ) {
          _authState = authState;

          return Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: Container(
                child: SingleChildScrollView(
              child: Column(children: [
                _headline(),
                SizedBox(height: 16.0),
                _emailForm(),
                SizedBox(height: 16.0),
                _passwordField(),
                SizedBox(height: 28.0),
                authState.isLoading
                    ? Container(
                        child: DefaultLoadingIndicator(),
                        padding: EdgeInsets.all(12.0),
                      )
                    : StandardButton(
                        onPress: () => _handleSignIn(context),
                        title: "Login",
                        buttonColor: color),
              ]),
            )),
          );
        });
  }

  TextFormField _passwordField() {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.emailAddress,
      validator: _validatePassword,
      autofocus: false,
      obscureText: hidePassword,
      decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.lock,
            color: color,
          ),
          labelText: "Password",
          hintText: "****",
          suffixIcon: GestureDetector(
              onTap: _togglePassword,
              child: Icon(
                hidePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                size: 20.0,
              )),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: color, width: 1.0, style: BorderStyle.solid),
          )),
    );
  }

  Widget _emailForm() {
    return TextFormField(
      controller: emailController,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 18.0),
          icon: Icon(
            FontAwesomeIcons.envelope,
            color: color,
          ),
          labelText: "E-mail address",
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: color, width: 1.0, style: BorderStyle.solid),
          )),
    );
  }

  Widget _headline() {
    return Text("Login",
        style: TextStyle(
            color: color, fontSize: 22.0, fontWeight: FontWeight.bold));
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty!";
    }
  }

  void _togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn(BuildContext context) {
    _autovalidate = true;
    if (_formKey.currentState.validate()) {
      authBloc.onLoginButtonPressed(context,
          email: emailController.text, password: passwordController.text);
    }
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
