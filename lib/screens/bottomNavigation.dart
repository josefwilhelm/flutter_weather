import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart';
import 'settings.dart';
import '../dataRepository.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigaitonWidgetState createState() => _BottomNavigaitonWidgetState();
}

class _BottomNavigaitonWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  final List<Widget> _widgets = [Home(), SettingsWidget(), DataRepository()];

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
            icon: Icon(FontAwesomeIcons.wrench),
            title: new Text('Settings'),
          ),
          BottomNavigationBarItem(
              backgroundColor: color,
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
