import 'package:flutter/material.dart';
import 'package:kitty_mingsi_flutter/components/DefaultLoadingIndicator.dart';

class LoadingFullScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DefaultLoadingIndicator(),
          SizedBox(
            height: 24.0,
          ),
          Text(
            "Loading...",
            style: Theme.of(context).textTheme.display3,
          )
        ],
      ),
    );
  }
}
