import 'dart:async';
import 'package:bloc/bloc.dart';
import 'states/AuthenticationState.dart';
import 'events/AuthenticationEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _user;

  AuthenticationState get initialState => AuthenticationState.initial();

  void onLoginButtonPressed({String email, String password}) {
    dispatch(
      LoginButtonPressed(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState state, AuthenticationEvent event) async* {
    if (event is LoginButtonPressed) {
      yield AuthenticationState.loading();
      try {
        _user = await _login(event.email, event.password);
        yield AuthenticationState.success(_user.uid);
      } catch (error) {
        yield AuthenticationState.failure(error.toString());
      }
    }
  }

  Future<FirebaseUser> _login(String email, String password) async {
    // try {
    return _auth.signInWithEmailAndPassword(email: email, password: password);

    //     .then((user) {
    //   Navigator.pushNamed(
    //       context, "/home"); //TODO replace with replacewithNamed
    // });
    // } catch (e) {

    // }
  }
}
