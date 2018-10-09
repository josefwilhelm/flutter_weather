import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart'; //new
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Initially password is obscure

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF7EBE8),
      body: Container(
        padding: const EdgeInsets.all(28.0),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.0,
              ),
              Expanded(
                child: Icon(
                  IconData(0xe3ea, fontFamily: 'MaterialIcons'),
                  size: 120.0,
                  color: Theme.of(context).primaryColor,
                ),
                flex: 1,
              ),
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
  bool _obscureText = true;

  String email = "test@test.com";
  String password = "123456";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void setIsLoading(bool isLoading) {
    setState(() {
      _isloading = isLoading;
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    setIsLoading(true);

    assert()

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
      setIsLoading(false);
      Navigator.pushNamed(
          context, "/home"); //TODO replace with replacewithNamed
    }).catchError((e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Wrong username or password!')));
      setIsLoading(false);
      return null;
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailController,
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
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      autofocus: false,
      obscureText: _obscureText,
      decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).accentColor,
          ),
          labelText: "Password",
          hintText: "****",
          suffixIcon: GestureDetector(
              onTap: _toggle,
              child: Icon(
                _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
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
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Submit button pressed')));
                    },
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

    return Container(
        child: Column(children: [
      Text("Login",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22.0,
              fontWeight: FontWeight.bold)),
      SizedBox(height: 16.0),
      email,
      SizedBox(height: 16.0),
      password,
      SizedBox(
        height: 28.0,
      ),
      loginButton,
      SizedBox(
        height: 12.0,
      ),
      Container(
          child: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Register button pressed')));
                  },
                  child: Container(
                      child: Text(
                    'Register',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 18.0),
                  )))
              : FlatButton(
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Register button pressed')));
                  },
                  child: Container(
                      child: Text(
                    'Register',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 18.0),
                  ))))
    ]));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
