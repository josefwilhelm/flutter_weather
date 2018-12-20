import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPress;
  final IconData icon;

  GridItem(
      {@required this.color,
      @required this.title,
      @required this.onPress,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          color: color,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
