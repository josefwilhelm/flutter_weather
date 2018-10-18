import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Icon(
        Icons.cloud_download,
        color: Colors.red,
        size: 300.0,
      )),
    );
  }
}
