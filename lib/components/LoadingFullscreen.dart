import 'package:flutter/material.dart';
import '../components/DefaultLoadingIndicator.dart';

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
