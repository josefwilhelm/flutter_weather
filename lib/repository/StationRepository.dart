import 'package:kitty_mingsi_flutter/service/firestoreService.dart';
import 'package:kitty_mingsi_flutter/service/authenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitty_mingsi_flutter/models/Station.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kitty_mingsi_flutter/service_locator/serviceLocator.dart';

class StationRepository {
  FirestoreService firestoreService = sl.get<FirestoreService>();

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
  }

  Future<List<Station>> getAllStations() async {
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
