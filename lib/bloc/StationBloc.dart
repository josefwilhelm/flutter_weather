import 'package:kitty_mingsi_flutter/bloc/BlocProvider.dart';
import 'package:kitty_mingsi_flutter/models/Station.dart';
import 'package:kitty_mingsi_flutter/repository/StationRepository.dart';
import 'package:kitty_mingsi_flutter/service_locator/serviceLocator.dart';
import 'package:rxdart/rxdart.dart';

class StationBloc implements BlocBase {
  final _repository = sl.get<StationRepository>();

  final _stationFetcher = BehaviorSubject<List<Station>>();
  final _stationName =
  BehaviorSubject<Station>(seedValue: Station("Station1", ''));

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
    if (station.documentId.isEmpty) {
      return;
    }
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
