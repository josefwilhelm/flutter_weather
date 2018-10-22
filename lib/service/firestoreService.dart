import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Firestore firestore;
  CollectionReference usersReference;
  CollectionReference stationsReference;

  FirestoreService() {
    firestore = Firestore.instance;
    usersReference = firestore.collection("users");
    stationsReference = firestore.collection("stations");
  }

  Future<QuerySnapshot> getAllStations() {
    return stationsReference.getDocuments();
  }
}
