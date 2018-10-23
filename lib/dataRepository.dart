import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'components/StandardButtonWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
<<<<<<< HEAD
import 'bloc/BlocProvider.dart';
import 'bloc/StationBloc.dart';
=======
import 'models/WeatherDataModels.dart';
import 'screens/home.dart';

import 'package:charts_flutter/flutter.dart' as charts;
>>>>>>> 88c2deb58ee45fdd6d1b61b20e924fe8a9eb748a

class DataRepository extends StatefulWidget {
  _DataRepositoryState createState() => _DataRepositoryState();
}

class _DataRepositoryState extends State<DataRepository> {
  Stream<QuerySnapshot> _data;
  List<DocumentSnapshot> documents;
  List<List<AirTemperatureValue>> stationValues = [];
  List<AirTemperatureValue> airTemperatureList = [];

  Map<DateTime, double> airTemperatureMap;
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
    final StationBloc bloc = BlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(bloc.title),
      ),
      body: //SingleChildScrollView(
          SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StandardButton(
                title: "add new station",
                onPress: _addNewStation,
                buttonColor: Colors.blue),
            StandardButton(
                title: "reload UI", onPress: _refresh, buttonColor: Colors.red),
            StandardButton(
                title: "Add 1 measurement to firestore",
                onPress: _addData,
                buttonColor: Theme.of(context).primaryColor),
            StandardButton(
                title: "add data periodically",
                onPress: _addDataPeriodically,
                buttonColor: Colors.green),
            StandardButton(
                title: "reload data from server",
                onPress: _parseData,
                buttonColor: Colors.red),
            SizedBox(
              height: 32.0,
            ),
            Card(
              color: Colors.yellow,
              child: Text(
                "Number of stations: " + stationValues.length.toString(),
                style: Theme.of(context).textTheme.display2,
              ),
            ),
            //       StandardButton(
            //           title: "Add 1 measurement to firestore",
            //           onPress: _addData,
            //           buttonColor: Theme.of(context).primaryColor),
            //       SizedBox(
            //         height: 32.0,
            //       ),
            //       StandardButton(
            //           title: "add data periodically",
            //           onPress: _addDataPeriodically,
            //           buttonColor: Colors.green),
            //       SizedBox(
            //         height: 32.0,
            //       ),
            //       StandardButton(
            //           title: "add new station",
            //           onPress: _addNewStation,
            //           buttonColor: Colors.blue),
            //       SizedBox(
            //         height: 32.0,
            //       ),
            //       StandardButton(
            //           title: "data", onPress: _parseData, buttonColor: Colors.red),
            //       SizedBox(
            //         height: 32.0,
            //       ),
            //       StandardButton(
            //           title: "refresh", onPress: _refresh, buttonColor: Colors.red),
            //       Text("charts"),

            Container(
              height: 400.0,
              child: stationValues.isEmpty
                  ? Text(
                      "reload UI please!",
                      style: Theme.of(context).textTheme.display2,
                    )
                  : ListView.builder(
                      itemCount: stationValues.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _stationsCharts()[index];
                      }),
            ),
          ],
        ),
      ),
    );
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
  }

  void _refresh() {
    setState(() {});
  }

  List<Widget> _stationsCharts() {
    List<Widget> list = [];
    stationValues.forEach((station) {
      list.add(Column(
        children: <Widget>[
          Container(
              height: 300.0, child: AreaAndLineChart(createChart(station))),
        ],
      ));
    });
    return list;
  }

  List<charts.Series<AirTemperatureValue, DateTime>> createChart(
      List<AirTemperatureValue> station) {
    return [
      new charts.Series<AirTemperatureValue, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.black.darker,
        domainFn: (AirTemperatureValue sales, _) => sales.timestamp,
        measureFn: (AirTemperatureValue sales, _) => sales.temperature.toInt(),
        data: station,
      )
    ];
  }

  void _addNewStation() {
    try {
      Firestore.instance.collection("stations").document().setData({
        'stationName': 'station' + (documents.length + 1).toString(),
        'userId': user.uid
      }).catchError((e) => debugPrint(e.toString()));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getStations() {
    FirebaseAuth.instance.currentUser().then((tempUser) {
      try {
        user = tempUser;
        stations
            .where("userId", isEqualTo: user.uid)
            .getDocuments()
            .then((value) {
          documents = value.documents;
          _parseData();
          debugPrint("number of stations: " + documents.length.toString());
          debugPrint("user: " + user.email);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
      debugPrint(user.uid);
    });
  }

  void _parseData() {
    documents.forEach((document) {
      document.reference.collection("data").getDocuments().then((measurement) {
        measurement.documents.forEach((m) {
          airTemperatureList
              .add(AirTemperatureValue(m.data['timestamp'], m.data['tempAir']));
        });

        stationValues.add(airTemperatureList);
        airTemperatureList = [];
      }).catchError((error) {
        debugPrint(error.toString());
      });
    });
  }

  void _addDataPeriodically() {
    Timer.periodic(Duration(minutes: 15), (Timer t) => _addData());
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
              debugPrint("written to document: " + document.documentID))
          .catchError((error) => debugPrint(error.toString()));
    });
  }
}
