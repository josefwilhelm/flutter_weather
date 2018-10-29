import 'package:flutter/material.dart';
import 'package:kitty_mingsi_flutter/screens/login.dart';
import 'package:kitty_mingsi_flutter/screens/bottomNavigation.dart';
import 'package:bloc/bloc.dart';
import 'package:kitty_mingsi_flutter/bloc/AuthenticationBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kitty_mingsi_flutter/screens/splash.dart';
import 'package:kitty_mingsi_flutter/bloc/StationBloc.dart';
import 'package:kitty_mingsi_flutter/bloc/BlocProvider.dart';

import 'package:kitty_mingsi_flutter/service/firestoreService.dart';
import 'package:kitty_mingsi_flutter/service/authenticationService.dart';
import 'package:kitty_mingsi_flutter/service_locator/serviceLocator.dart';
import 'package:kitty_mingsi_flutter/repository/StationRepository.dart';

void main() {
  sl.registerSingleton<FirebaseAuthenticationService>(new FirebaseAuthenticationService());
  sl.registerSingleton<FirestoreService>(new FirestoreService());
  sl.registerSingleton<StationRepository>(new StationRepository());

  runApp(BlocProvider(
      bloc: AuthenticationBloc(),
      child: BlocProviderGeneric<StationBloc>(
          bloc: StationBloc(), child: new MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        routes: {
          "/start": (context) => BottomNavigationWidget(),
          "/login": (context) => Login(),
        },
        theme: new ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          accentColor: Colors.teal[800],
          primaryTextTheme:
              Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
        ),
        home: _onStart());
  }

  Widget _onStart() {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            if (snapshot.hasData) {
              return BottomNavigationWidget();
            }
            return Login();
          }
        });
  }
}
