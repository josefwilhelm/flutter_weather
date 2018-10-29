import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  FirebaseAuthenticationService() {
    init();
  }

  init() async {
    _auth.currentUser().then((user) {
      currentUser = user;
      print(currentUser.email);
    }).catchError((error) => print(error.toString()));
  }

  Future<FirebaseUser> login(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<void> logout() {
    return _auth.signOut();
  }
}
