import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kitty_mingsi_flutter/bloc/events/AuthenticationEvent.dart';
import 'package:kitty_mingsi_flutter/bloc/states/AuthenticationState.dart';
import 'package:kitty_mingsi_flutter/service/authenticationService.dart';
import 'package:kitty_mingsi_flutter/service_locator/serviceLocator.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuthenticationService _auth =
  sl.get<FirebaseAuthenticationService>();

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
  Stream<AuthenticationState> mapEventToState(AuthenticationState state,
      AuthenticationEvent event) async* {
    if (event is LoginButtonPressed) {
      yield AuthenticationState.loading();
      try {
        await _auth.login(event.email, event.password);
        Navigator.pushReplacementNamed(_context, "/start");
        yield AuthenticationState.success();
      } catch (error) {
        yield AuthenticationState.failure(error.toString());
      }
    }

    if (event is LogoutPressed) {
      yield AuthenticationState.loading();
      try {
        await _auth.logout();
        Navigator.pushReplacementNamed(_context, "/login");
        yield AuthenticationState.initial();
      } catch (error) {}
    }
  }
}
