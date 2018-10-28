import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FirebaseAuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;

  //TODO singleton
  FirebaseAuthenticationService() {}

  Future<FirebaseUser> getUser() async {
    return auth.currentUser().catchError((error) => print(error.toString()));
  }
}
