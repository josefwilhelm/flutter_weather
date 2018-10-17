import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/bottomNavigation.dart';
import 'package:bloc/bloc.dart';
import 'bloc/AuthenticationBloc.dart';

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
        },
        theme: new ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF67697C),
            accentColor: const Color(0xFF82AC9F),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: const Color(0xFF53687E))),
        home: BlocProvider(
          bloc: _authBloc,
          child: Login(),
        ));
  }
}
