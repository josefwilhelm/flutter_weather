import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //new

class StandardButton extends StatelessWidget {
  StandardButton(
      {@required this.onPress,
      @required this.title,
      this.buttonColor,
      this.padding: const EdgeInsets.all(12.0)});

  final VoidCallback onPress;
  final String title;
  final EdgeInsets padding;
  final Color _textColor = Colors.white;
  final buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoButton(
                padding: padding,
                color: buttonColor,
                onPressed: onPress,
                child: _text())
            : RaisedButton(
                padding: padding,
                color: buttonColor,
                onPressed: onPress,
                child: _text()));
  }

  Widget _text() {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, color: _textColor),
    );
  }
}
