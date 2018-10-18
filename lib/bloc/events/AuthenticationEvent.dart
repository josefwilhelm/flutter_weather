import 'package:flutter/material.dart';

abstract class AuthenticationEvent {}

class LoginButtonPressed extends AuthenticationEvent {
  final String email;
  final String password;

  LoginButtonPressed({@required this.email, @required this.password});
}

class RegisterButtonPressed extends AuthenticationEvent {
  final String username;
  final String password;

  RegisterButtonPressed({@required this.username, @required this.password});
}

class LogoutPressed extends AuthenticationEvent {}
