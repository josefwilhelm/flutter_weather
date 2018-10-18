import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'states/AuthenticationState.dart';
import 'events/AuthenticationEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/bottomNavigation.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _user;

  BuildContext _context;

  AuthenticationState get initialState => AuthenticationState.initial();

  void onLoginButtonPressed(BuildContext context,
      {String email, String password}) {
    _context = context;
    dispatch(
      LoginButtonPressed(
        email: email,
        password: password,
      ),
    );
  }

  void onLogoutPressed(BuildContext context) {
    _context = context;
    dispatch(LogoutPressed());
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState state, AuthenticationEvent event) async* {
    if (event is LoginButtonPressed) {
      yield AuthenticationState.loading();
      try {
        _user = await _login(event.email, event.password);
        debugPrint(_user.email);
        Navigator.pushReplacementNamed(_context, "/start");
        yield AuthenticationState.success(_user.uid);
      } catch (error) {
        yield AuthenticationState.failure(error.toString());
      }
    }

    if (event is LogoutPressed) {
      yield AuthenticationState.loading();
      try {
        await _logout();
        Navigator.pushReplacementNamed(_context, "/login");
      } catch (error) {}
    }
  }

  Future<FirebaseUser> _login(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _logout() {
    _auth.signOut();
  }
}
