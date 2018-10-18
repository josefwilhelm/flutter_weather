import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/bottomNavigation.dart';
import 'package:bloc/bloc.dart';
import 'bloc/AuthenticationBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final AuthenticationBloc _authBloc = AuthenticationBloc();
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
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
          // accentColor: Colors.blue,
          // primaryColor: Colors.cyan[800]
          // primaryColor: const Color(0xFF82AC9F),
          // accentColor: const Color(0xFF67697C),
          // textTheme: Theme.of(context)
          //     .textTheme
          //     .apply(bodyColor: const Color(0xFF53687E))
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
            return BlocProvider(
              bloc: _authBloc,
              child: Login(),
            );
          }
        });
  }
}
