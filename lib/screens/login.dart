import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:kitty_mingsi_flutter/screens/loginForm.dart';
import 'package:kitty_mingsi_flutter/screens/registerForm.dart';
import 'package:bloc/bloc.dart';
import 'package:kitty_mingsi_flutter/bloc/AuthenticationBloc.dart';

import 'package:kitty_mingsi_flutter/bloc/events/AuthenticationEvent.dart';
import 'package:kitty_mingsi_flutter/bloc/states/AuthenticationState.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc _authBloc = BlocProvider.of(context) as AuthenticationBloc;

    final List<Widget> _widgets = [LoginForm(_authBloc), RegisterForm()];

    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: _authBloc,
        builder: (
          context,
          AuthenticationState authState,
        ) {
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
                  color:  Theme.of(context).accentColor,
                ),
                SizedBox(height: 24.0),
                Expanded(flex: 3, child: _widgets[_currentIndex]),
                SizedBox(height: 24.0),
                // RaisedButton(
                //   child: Text("go to home"),
                //   onPressed: () {
                //     Navigator.pushNamed(context, "/start");
                //   },
                // )
              ]),
            ),
          );
        });
  }

  _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
