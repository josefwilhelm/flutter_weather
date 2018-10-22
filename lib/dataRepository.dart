import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'components/StandardButtonWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class DataRepository extends StatefulWidget {
  _DataRepositoryState createState() => _DataRepositoryState();
}

class _DataRepositoryState extends State<DataRepository> {
  Stream<QuerySnapshot> _data;
  List<DocumentSnapshot> documents;
  Random random = Random();
  FirebaseUser user;
  CollectionReference get stations => firestore.collection('stations');

  final Firestore firestore = Firestore();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StandardButton(
                title: "Add 1 measurement to firestore",
                onPress: _addData,
                buttonColor: Theme.of(context).primaryColor),
            SizedBox(
              height: 32.0,
            ),
            StandardButton(
                title: "add data periodically",
                onPress: _addDataPeriodically,
                buttonColor: Colors.green),
            SizedBox(
              height: 32.0,
            ),
            StandardButton(
                title: "add new station",
                onPress: _addNewStation,
                buttonColor: Colors.blue),
          ]),
      // body: new StreamBuilder<QuerySnapshot>(
      //   stream: Firestore.instance.collection('stations').snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) return new Text('Loading...');
      //     return new ListView(
      //       children: snapshot.data.documents.map((DocumentSnapshot document) {
      //         return new ListTile(
      //           title: new Text("value of document['stationName']: " +
      //               document['stationName']),
      //           subtitle: new Text("documentId: " + document.documentID),
      //         );
      //       }).toList(),
      //     );
      //   },
      // ),
    );
  }

  void _addNewStation() {
    try {
      Firestore.instance.collection("stations").document().setData({
        'stationName': 'station2', // + (documents.length + 1).toString(),
        'userId': user.uid
      }).catchError((e) => debugPrint(e.toString()));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getStations() {
    FirebaseAuth.instance.currentUser().then((user) {
      try {
        stations
            .where("userId", isEqualTo: user.uid)
            .getDocuments()
            .then((value) {
          documents = value.documents;
          user = user;
          debugPrint("number of stations: " + documents.length.toString());
          debugPrint("user: " + user.email);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
      debugPrint(user.uid);
    });
  }

  void _addDataPeriodically() {
    Timer.periodic(Duration(minutes: 5), (Timer t) => _addData());
  }

  void _addData() {
    var timestamp = FieldValue.serverTimestamp();

    documents.forEach((document) {
      stations
          .document(document.documentID)
          .collection('data')
          .add({
            'tempAir': random.nextInt(30) + random.nextDouble(),
            'precipition': random.nextDouble(),
            'tempGround': 5 + random.nextInt(20) + random.nextDouble(),
            'isWet': random.nextInt(20) == 19 ? false : true,
            'timestamp': timestamp
          })
          .then((document) =>
              debugPrint("written to firestore: " + timestamp.toString()))
          .catchError((error) => debugPrint(error.toString()));
    });
  }

  Stream<QuerySnapshot> _loadData() {
    _data = Firestore.instance.collection("users").snapshots();
  }
}
