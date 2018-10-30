import 'package:flutter/material.dart';

class AuthenticationState {
  final bool isLoading;
  final bool isLoginButtonEnabled;
  final String error;
  final String token;

  const AuthenticationState({
    @required this.isLoading,
    @required this.isLoginButtonEnabled,
    @required this.error,
    @required this.token,
  });

  factory AuthenticationState.initial() {
    return AuthenticationState(
      isLoading: false,
      isLoginButtonEnabled: true,
      error: '',
      token: '',
    );
  }

  factory AuthenticationState.loading() {
    return AuthenticationState(
      isLoading: true,
      isLoginButtonEnabled: false,
      error: '',
      token: '',
    );
  }

  factory AuthenticationState.failure(String error) {
    return AuthenticationState(
      isLoading: false,
      isLoginButtonEnabled: true,
      error: error,
      token: '',
    );
  }

  factory AuthenticationState.success() {
    return AuthenticationState(
      isLoading: false,
      isLoginButtonEnabled: true,
      error: '',
      token: '',
    );
  }
}
