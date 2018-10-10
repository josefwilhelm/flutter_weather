import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart'; //new
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(28.0),
        child: Column(children: [
          SizedBox(
            height: 48.0,
          ),
          Icon(
            FontAwesomeIcons.paw,
            size: 80.0,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 24.0),
          Expanded(flex: 3, child: LoginForm()),
        ]),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;

  // Toggles the password show status
  void _togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void setIsLoading(bool isLoading) {
    setState(() {
      _isloading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailController,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 18.0),
          icon: Icon(
            FontAwesomeIcons.envelope,
            color: Theme.of(context).accentColor,
          ),
          labelText: "E-mail address",
          border: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue, width: 1.0, style: BorderStyle.solid),
          )),
    );

    final password = TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.emailAddress,
      validator: _validatePassword,
      autofocus: false,
      obscureText: hidePassword,
      decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).accentColor,
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
            borderSide: BorderSide(
                color: Theme.of(context).accentColor,
                width: 1.0,
                style: BorderStyle.solid),
          )),
    );

    final loginButton = _isloading
        ? Container(
            child: CircularProgressIndicator(),
            padding: EdgeInsets.all(12.0),
          )
        : Container(
            child: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoButton(
                    padding: EdgeInsets.all(12.0),
                    color: Theme.of(context).accentColor,
                    onPressed: _handleSignIn,
                    child: Container(
                        child: Text(
                      'Submit',
                    )))
                : RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    color: Theme.of(context).primaryColor,
                    onPressed: _handleSignIn,
                    // then((FirebaseUser user) => )
                    //   .catchError((e) => print(e));
                    child: Container(
                        child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ))));

    final formHeadline = Text("Login",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 22.0,
            fontWeight: FontWeight.bold));

    final registerButton = Container(
        child: Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoButton(
                color: Theme.of(context).primaryColor,
                onPressed: _onRegisterPressed,
                child: Container(
                    child: Text(
                  'Register',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18.0),
                )))
            : FlatButton(
                onPressed: _onRegisterPressed,
                child: Container(
                    child: Text(
                  'Register',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18.0),
                ))));

    return Form(
      key: _formKey,
      child: Container(
          child: SingleChildScrollView(
        child: Column(children: [
          formHeadline,
          SizedBox(height: 16.0),
          email,
          SizedBox(height: 16.0),
          password,
          SizedBox(height: 28.0),
          loginButton,
          SizedBox(height: 12.0),
          registerButton
        ]),
      )),
    );
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty!";
    }
  }

  void _onRegisterPressed() {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Register button pressed')));
    }

    @override
    void dispose() {
      // Clean up the controller when the Widget is removed from the Widget tree
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    if (_formKey.currentState.validate()) {
      setIsLoading(true);

      String email = emailController.text;
      String password = passwordController.text;

      if (password.isEmpty || email.isEmpty) {
        setIsLoading(false);
        return null;
      }

      FirebaseUser user = await _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((user) {
        Navigator.pushNamed(
            context, "/home"); //TODO replace with replacewithNamed
      }).catchError((e) {
        setIsLoading(false);
        return null;
      });

      return user;
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
