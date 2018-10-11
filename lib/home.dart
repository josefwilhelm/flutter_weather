import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sticky_headers/sticky_headers.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final button = Container(
        child: Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoButton(
                padding: EdgeInsets.all(12.0),
                color: Theme.of(context).accentColor,
                onPressed: _onClickMePresed,
                child: Container(
                    child: Text(
                  'New Data',
                )))
            : RaisedButton(
                padding: EdgeInsets.all(12.0),
                color: Theme.of(context).primaryColor,
                onPressed: _onClickMePresed,
                // then((FirebaseUser user) => )
                //   .catchError((e) => print(e));
                child: Container(
                    child: Text(
                  'New Data',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ))));

    return Builder(
        builder: (context) => Column(
              children: <Widget>[
                Expanded(
                  child: ListView(children: <Widget>[
                    StickyHeader(
                        header: HeaderCart("Last 7 days"),
                        content: Column(
                          children: <Widget>[
                            Container(
                                height: 300.0,
                                child: Card(
                                    margin: EdgeInsets.all(8.0),
                                    color: Colors.blue[200],
                                    child:
                                        AreaAndLineChart(_createSampleData()))),
                            button
                          ],
                        )),
                    StickyHeader(
                        header: HeaderCart("Last 30 days"),
                        content: Column(
                          children: <Widget>[
                            Container(
                                height: 300.0,
                                child: Card(
                                    margin: EdgeInsets.all(8.0),
                                    color: Colors.green[200],
                                    child:
                                        AreaAndLineChart(_createSampleData()))),
                            button
                          ],
                        )),
                    StickyHeader(
                        header: HeaderCart("Last 1337 days"),
                        content: Column(
                          children: <Widget>[
                            Container(
                                height: 300.0,
                                child: Card(
                                    margin: EdgeInsets.all(8.0),
                                    color: Colors.red[200],
                                    child:
                                        AreaAndLineChart(_createSampleData()))),
                            button
                          ],
                        )),
                  ]),
                ),
              ],
            ));
  }

  void _onClickMePresed() {
    setState(() {});
  }

  List<charts.Series<WeatherValue, DateTime>> _createSampleData() {
    Random random = Random();
    final data = List<WeatherValue>();

    for (var i = 0; i < 10; i++) {
      data.add(
          new WeatherValue(new DateTime(2017, 9, 10 + i), random.nextInt(100)));
    }

    return [
      new charts.Series<WeatherValue, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.black.darker,
        domainFn: (WeatherValue sales, _) => sales.time,
        measureFn: (WeatherValue sales, _) => sales.temp,
        data: data,
      )
    ];
  }
}

class HeaderCart extends StatelessWidget {
  HeaderCart(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Card(
        child: Text(
          text,
          style: Theme.of(context).textTheme.display1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AreaAndLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  AreaAndLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: true,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      // dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.

}

/// Sample time series data type.
class WeatherValue {
  final DateTime time;
  final int temp;

  WeatherValue(this.time, this.temp);
}
