import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart'; //new
import 'loginForm.dart';
import 'registerForm.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentIndex = 0;

  final List<Widget> _widgets = [LoginForm(), RegisterForm()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(FontAwesomeIcons.signInAlt),
            title: new Text('Login'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(FontAwesomeIcons.pencilAlt),
            title: new Text('Register'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(28.0),
        child: Column(children: [
          SizedBox(
            height: 48.0,
          ),
          Icon(
            FontAwesomeIcons.airFreshener,
            size: 80.0,
            color: _currentIndex == 0
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
          ),
          SizedBox(height: 24.0),
          Expanded(flex: 3, child: _widgets[_currentIndex]),
        ]),
      ),
    );
  }

  _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
