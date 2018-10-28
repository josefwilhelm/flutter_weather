import 'dart:core';

class Station {
  String name;
  String documentId;

  Station(this.name, this.documentId);
}

class StationValue {
  final double temperatureAir;
  double temperatureGround;
  double humidity;
  double precipition;
  int airPressure;
  DateTime timestamp;

  StationValue(
      {this.temperatureAir,
      this.temperatureGround,
      this.humidity,
      this.precipition,
      this.airPressure,
      this.timestamp});

  factory StationValue.fromFireStoreData(data) {
    2.3.toStringAsFixed(2);

    return StationValue(
        temperatureAir: data['tempAir'] as double,
        temperatureGround: data['tempGround'],
        humidity: data['humidiy'],
        precipition: data['precipition'],
        airPressure: data['airPressure'],
        timestamp: data['timestamp']);
  }
}
