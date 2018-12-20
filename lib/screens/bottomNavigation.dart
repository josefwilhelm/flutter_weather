import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitty_mingsi_flutter/dataRepository.dart';
import 'package:kitty_mingsi_flutter/screens/settings.dart';

import 'Dashboard.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigaitonWidgetState createState() => _BottomNavigaitonWidgetState();
}

class _BottomNavigaitonWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 1;
  final List<Widget> _widgets = [
    Dashboard(),
    ProfileWidget(),
    DataRepository(),
    Test()
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            backgroundColor: color,
            icon: Icon(FontAwesomeIcons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: color,
            icon: Icon(FontAwesomeIcons.user),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
              backgroundColor: color,
              icon: Icon(FontAwesomeIcons.database),
              title: Text('Database')),
          BottomNavigationBarItem(
              backgroundColor: color,
              icon: Icon(FontAwesomeIcons.teeth),
              title: Text('Test'))
        ],
      ),
      body: _widgets[_currentIndex],
    );
  }

  _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text("Test")),
          Container(
              child: Image.asset(
            'assets/test.png',
            fit: BoxFit.fill,
            height: 200.0,
          )),
          Center(child: Text("Test")),
        ],
      ),
    );
  }
}
