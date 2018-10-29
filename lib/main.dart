import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/bottomNavigation.dart';
import 'package:bloc/bloc.dart';
import 'bloc/AuthenticationBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash.dart';
import 'bloc/StationBloc.dart';
import 'bloc/BlocProvider.dart';

void main() => runApp(BlocProvider(
    bloc: AuthenticationBloc(),
    child: BlocProviderGeneric<StationBloc>(
        bloc: StationBloc(), child: new MyApp())));

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
          accentColor: Colors.cyan,
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
