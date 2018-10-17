import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../dataRepository.dart';
import '../main.dart';
import 'settings.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigaitonWidgetState createState() => _BottomNavigaitonWidgetState();
}

class _BottomNavigaitonWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  final List<Widget> _widgets = [
    MyHomePage(),
    SettingsWidget(),
    DataRepository()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(FontAwesomeIcons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(FontAwesomeIcons.wrench),
            title: new Text('Settings'),
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.yellow,
              icon: Icon(FontAwesomeIcons.database),
              title: Text('Database'))
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
