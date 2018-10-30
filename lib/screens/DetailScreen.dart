import 'package:kitty_mingsi_flutter/screens/Dashboard.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Station Detail"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              DefaultWeatherWidget(
                title: "sdf",
                value: "123",
              ),
              DefaultWeatherWidget(
                title: "sdf",
                value: "123",
              ),
              DefaultWeatherWidget(
                title: "sdf",
                value: "123",
              )
            ],
          ),
        ),
      ),
    );
  }
}
