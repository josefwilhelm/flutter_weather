import 'package:flutter/material.dart';
import 'login.dart';
import 'settings.dart';
import 'home.dart';
import 'package:flutter/cupertino.dart'; //new

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
            // brightness: Brightness.dark,
            primaryColor: const Color(0xFF82AC9F),
            accentColor: const Color(0xFF82AC9F),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: const Color(0xFF53687E))),
        initialRoute: "/home",
        routes: {
          "/": (context) => Login(),
          "/home": (context) => MyHomePage(),
          "/settings": (context) => SettingsPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [Home(), SettingsPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(
            "Look at my charts",
            // style: TextStyle(color: Colors.white),
          ), //new Text(widget.title),
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Theme.of(context).accentColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.wrench), title: Text("Settings")),
          ],
          onTap: onTabTapped,
          currentIndex: _currentIndex,
        ),
        body: _pages[_currentIndex]);
  }
}
