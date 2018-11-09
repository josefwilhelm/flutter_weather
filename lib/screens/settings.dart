import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kitty_mingsi_flutter/bloc/AuthenticationBloc.dart';
import 'package:kitty_mingsi_flutter/bloc/events/AuthenticationEvent.dart';
import 'package:kitty_mingsi_flutter/bloc/states/AuthenticationState.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc _authBloc = BlocProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: BlocBuilder<AuthenticationEvent, AuthenticationState>(
            bloc: _authBloc,
            builder: (BuildContext context,
                AuthenticationState authState,) {
              return Center(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Logout"),
                        onPressed: () => _authBloc.onLogoutPressed(context),
                      ),
                    ],
                  ));
            }
          // StreamBuilder<FirebaseUser>(
          //     stream: FirebaseAuth.instance.onAuthStateChanged,
          //     builder: (BuildContext context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CircularProgressIndicator();
          //       } else {
          //         if (snapshot.hasData) {
          //           return Text(snapshot.data.email);
          //         }
          //       }
          //     })

        ));
  }
}
