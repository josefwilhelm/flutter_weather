import 'BlocProvider.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/Station.dart';
import '../repository/StationRepository.dart';

class StationBloc implements BlocBase {
  final _repository = StationRepository();

  final _stationFetcher = BehaviorSubject<List<Station>>();
  final _stationName = BehaviorSubject<Station>();
  final _stationValuesController = BehaviorSubject<StationValue>(
      seedValue: StationValue(
          airPressure: 1235,
          humidity: 78.432,
          precipition: 0.4,
          temperatureAir: 13.5,
          temperatureGround: 14.5,
          timestamp: DateTime.now()));

  Sink get changeStation => _stationName.sink;
  Observable<Station> get stationName => _stationName.stream;
  Observable<List<Station>> get allStations => _stationFetcher.stream;
  Observable<StationValue> get stationValue => _stationValuesController.stream;
  Sink get stationValuesSink => _stationValuesController.sink;

  StationBloc() {
    _stationName.stream.listen(_handleStationChange);
    // changeStation.add(_repository.randomStationValue());
  }

  void addValues() {}

  void _handleStationChange(Station station) async {
    var stationValue =
        await _repository.getValuesForStation(station.documentId);

    _stationValuesController.sink
        .add(StationValue.fromFireStoreData(stationValue.documents.first));
  }

  fetchAllStations() async {
    _repository
        .getAllStations()
        .then((stations) => _stationFetcher.sink.add(stations));
  }

  void dispose() {
    _stationFetcher.close();
    _stationName.close();
    _stationValuesController.close();
  }
}
