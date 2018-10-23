import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  //TODO singleton
  FirebaseAuthenticationService() {
    _getUser();
  }

  void _getUser() {
    auth.currentUser().then((user) => this.currentUser = user);
  }
}
