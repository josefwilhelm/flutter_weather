import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/StandardButtonWidget.dart';

class RegisterForm extends StatefulWidget {
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool hidePassword = true;
  bool _autovalidate = false;
  bool _isloading = false;
  bool _successful = false;
  var color;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailRepeatController = TextEditingController();
  TextEditingController _passwordRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).accentColor;
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Container(
          child: _successful
              ? _successfulView()
              : SingleChildScrollView(
                  child: Column(children: [
                    _headline(),
                    SizedBox(height: 16.0),
                    _emailForm("Enter E-mail address", _emailController,
                        _validateEmail),
                    SizedBox(height: 16.0),
                    _emailForm("Repeat E-mail address", _emailRepeatController,
                        _validateEmailRepeat),
                    SizedBox(height: 16.0),
                    _passwordField("Enter password", _passwordController,
                        _validatePassword),
                    SizedBox(height: 28.0),
                    _passwordField("Enter password again",
                        _passwordRepeatController, _validatePasswordRepeat),
                    SizedBox(height: 28.0),
                    _isloading
                        ? Container(
                            child: CircularProgressIndicator(),
                            padding: EdgeInsets.all(12.0),
                          )
                        : StandardButton(
                            onPress: _onRegisterPressed,
                            title: "Register",
                            buttonColor: color),
                  ]),
                )),
    );
  }

  TextFormField _passwordField(String label, TextEditingController controller,
      ValueChanged<String> validator) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      autofocus: false,
      obscureText: hidePassword,
      decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.lock,
            color: color,
          ),
          labelText: label,
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

  Widget _emailForm(String label, TextEditingController controller,
      ValueChanged<String> validator) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 18.0),
          icon: Icon(
            FontAwesomeIcons.envelope,
            color: color,
          ),
          labelText: label,
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: color, width: 1.0, style: BorderStyle.solid),
          )),
    );
  }

  Widget _headline() {
    return Text("Register",
        style: TextStyle(
            color: color, fontSize: 22.0, fontWeight: FontWeight.bold));
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
    _emailController.dispose();
    _emailRepeatController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() async {
    _autovalidate = true;
    if (_formKey.currentState.validate()) {
      setIsLoading(true);

      String email = _emailController.text;
      String password = _passwordController.text;

      if (password.isEmpty || email.isEmpty) {
        setIsLoading(false);
      }

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        //     .then((user) {
        //   _successful = true;
        //   setIsLoading(false);
        //   // Navigator.pushNamed(
        //   //     context, "/home"); //TODO replace with replacewithNamed
        // });
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

  String _validateEmailRepeat(String value) {
    if (_emailController.text == value) {
      return null;
    } else {
      return 'E-mail does not match';
    }
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty!";
    } else if (value.length < 7) {
      return 'Password needs to be at least 8 characters long';
    }
  }

  String _validatePasswordRepeat(String value) {
    if (_passwordController.text != value) {
      return "Password does not match";
    }
  }

  Widget _successfulView() {
    return Center(child: Text("successfully registered"));
  }
}
