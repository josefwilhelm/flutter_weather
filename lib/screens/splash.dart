import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Icon(
            Icons.cloud_download,
            color: Colors.red,
            size: 300.0,
          ),
          Text("helllooooooo")
        ],
      ),
    );
  }
}
