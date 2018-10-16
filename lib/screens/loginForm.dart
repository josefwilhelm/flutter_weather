import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/StandardButtonWidget.dart';

class LoginForm extends StatefulWidget {
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool hidePassword = true;
  bool _autovalidate = false;
  bool _isloading = false;
  var color;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).accentColor;
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
          _isloading
              ? Container(
                  child: CircularProgressIndicator(),
                  padding: EdgeInsets.all(12.0),
                )
              : StandardButton(
                  onPress: _handleSignIn, title: "Login", buttonColor: color),
        ]),
      )),
    );
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

  void setIsLoading(bool isLoading) {
    setState(() {
      _isloading = isLoading;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    _autovalidate = true;
    if (_formKey.currentState.validate()) {
      setIsLoading(true);

      String email = emailController.text;
      String password = passwordController.text;

      if (password.isEmpty || email.isEmpty) {
        setIsLoading(false);
      }

      try {
        await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((user) {
          Navigator.pushNamed(
              context, "/home"); //TODO replace with replacewithNamed
        });
      } catch (e) {
        setIsLoading(false);
      }
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
