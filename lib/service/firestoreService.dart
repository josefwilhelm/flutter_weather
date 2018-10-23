import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:math';

class FirestoreService {
  Firestore firestore = Firestore();
  CollectionReference usersReference;
  CollectionReference stationsReference;
  FirebaseUser currentUser;

  List<DocumentSnapshot> stations;

  FirestoreService(FirebaseUser user) {
    this.currentUser = user;
    this.usersReference = firestore.collection("users");
    this.stationsReference = firestore.collection("stations");
  }

  void _loadData() {
    //TODO
    _getAllStationsForUser("").then((allStations) {
      stations.addAll(allStations.documents);
    });
  }

  Future<QuerySnapshot> _getAllStationsForUser(String userId) {
    return stationsReference.where("userId", isEqualTo: userId).getDocuments();
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
            'timestamp': timestamp
          })
          .then((document) =>
              debugPrint("written to document: " + document.documentID))
          .catchError((error) => debugPrint(error.toString()));
    });
  }
}
