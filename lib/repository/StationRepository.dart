import '../service/firestoreService.dart';
import '../service/authenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Station.dart';
import 'package:rxdart/rxdart.dart';

class StationRepository {
  FirebaseAuthenticationService auth = FirebaseAuthenticationService();
  FirestoreService firestoreService;

  ValueObservable<List<DocumentSnapshot>> _stations;

  Observable<StationValue> randomStationValue() {
    var temp = _stations.first.asStream().first.then((station) => station
            .first.reference
            .collection('data')
            .getDocuments()
            .then((documents) {
          return StationValue.fromFireStoreData(documents.documents.first.data);
        }));

    Observable<StationValue> stat;
  }

  StationRepository() {
    _init();
    // _loadAllStations(); //TODO
  }
  void _loadAllStations() async {
    _stations = await firestoreService
        .loadAllStations()
        .then((stations) {})
        .catchError((e) => print(e.toString()));
  }

  void _init() async {
    FirebaseUser user = await auth.getUser();
    firestoreService = FirestoreService(user);
  }

  Future<List<Station>> getAllStations() async {
    // return firestoreService.loadAllStations();
    var stations = await firestoreService.loadAllStations();

    try {
      return stations.documents.map((station) {
        return Station(station.data["stationName"], station.documentID);
      }).toList();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot> getValuesForStation(String stationId) async {
    return firestoreService.getLatestValuesForStation(stationId);
  }
}
