import 'BlocProvider.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../service/firestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/authenticationService.dart';

class StationBloc implements BlocBase {
  int _counter;
  FirestoreService service;
  FirebaseAuthenticationService auth = FirebaseAuthenticationService();
  String title = "hallo seppi";

  StationBloc() {
    _init();
    _inAdd.add(10);
  }

  void _init() async {
    service = FirestoreService(auth.currentUser);
  }

  // //
  // // Stream to handle the counter
  // //
  StreamController<int> _stationsController = StreamController<int>();
  StreamSink<int> get _inAdd => _stationsController.sink;
  Stream<int> get outStations => _stationsController.stream;

  // //
  // // Stream to handle the action on the counter
  // //
  // StreamController _actionController = StreamController();
  // StreamSink get incrementCounter => _actionController.sink;

  // //
  // // Constructor
  // //
  // StationBloc() {
  //   _counter = 0;
  //   _actionController.stream.listen(_handleLogic);
  // }

  void dispose() {
    //   _actionController.close();
    //   _counterController.close();
  }

  // void _handleLogic(data) {
  //   _counter = _counter + 1;
  //   _inAdd.add(_counter);
  // }

}
