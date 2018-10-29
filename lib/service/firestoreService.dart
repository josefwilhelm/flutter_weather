import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Station.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:math';

class FirestoreService {
  Firestore firestore = Firestore();
  CollectionReference usersReference;
  CollectionReference stationsReference;
  FirebaseUser currentUser;

  Set<DocumentSnapshot> stations;

  FirestoreService(FirebaseUser user) {
    this.currentUser = user;
    this.usersReference = firestore.collection("users");
    this.stationsReference = firestore.collection("stations");

    _loadData();
  }

  Future<Set<Station>> getAllStationNames() async {
    if (stations == null) {
      await _loadData();
    }
  }

  Future<void> _loadData() {
    //TODO
    return _getAllStationsForUser(currentUser.uid).then((allStations) {
      stations.addAll(allStations.documents);
    });
  }

  Future<QuerySnapshot> loadAllStations() {
    return _getAllStationsForUser(currentUser.uid);
  }

  Future<QuerySnapshot> _getAllStationsForUser(String userId) {
    return stationsReference
        .where("userId", isEqualTo: currentUser.uid)
        .getDocuments()
        .catchError((error) => print(error.toString()));
  }

  void addNewStation(String name, String userId) {
    stationsReference
        .document()
        .setData({'stationName': name, 'userId': userId}).catchError(
            (e) => debugPrint(e.toString()));
  }

  //DEBUG seed data to firestore
  void addDataPeriodically() {
    Timer.periodic(Duration(minutes: 15), (Timer t) => addData());
  }

  Future<QuerySnapshot> getLatestValuesForStation(String stationId) {
    var s = stationsReference
        .document(stationId)
        .collection('data')
        .orderBy("timestamp")
        .limit(1);

    return s.getDocuments();
  }

  void addData() {
    var timestamp = FieldValue.serverTimestamp();

    Random random = Random();

    stations.forEach((station) {
      station.reference
          .collection('data')
          .add({
            'tempAir': random.nextInt(30) + random.nextDouble(),
            'precipition': random.nextDouble(),
            'tempGround': 5 + random.nextInt(20) + random.nextDouble(),
            'isWet': random.nextInt(20) == 19 ? false : true,
            'humidiy': 40 + random.nextInt(80) + random.nextDouble(),
            'airPressure': 900 + random.nextInt(400),
            'timestamp': timestamp
          })
          .then((document) =>
              debugPrint("written to document: " + document.documentID))
          .catchError((error) => debugPrint(error.toString()));
    });
  }
}
