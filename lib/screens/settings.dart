import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/AuthenticationBloc.dart';
import 'package:bloc/bloc.dart';
import '../bloc/events/AuthenticationEvent.dart';
import '../bloc/states/AuthenticationState.dart';

class SettingsWidget extends StatelessWidget {
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  @override
  Widget build(BuildContext context) {
    // AuthenticationBloc authBloc = BlocProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: BlocBuilder<AuthenticationEvent, AuthenticationState>(
            bloc: _authBloc,
            builder: (
              BuildContext context,
              AuthenticationState authState,
            ) {
              return Center(
                  child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Logout"),
                    onPressed: () => _authBloc.onLogoutPressed(context),
                  ),
                  Text(authState.token)
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
