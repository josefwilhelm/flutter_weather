import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sticky_headers/sticky_headers.dart';
import '../components/StandardButtonWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/LoadingFullscreen.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.wineGlass),
                text: "Rain",
              ),
              Tab(icon: Icon(FontAwesomeIcons.ravelry), text: "Temperature"),
            ],
          ),
        ),
        body: TabBarView(children: [
          RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: _listView(Colors.grey[100])),
          _listView(Colors.grey[200]),
        ]),
      ),
    );
  }

  Future<List<Widget>> _asyncWidget(Color color) async {
    await Future.delayed(Duration(milliseconds: 1200));

    final list = [
      _stickyHeader("Last 7 days", color),
      _stickyHeader("Last 30 days", color),
      _stickyHeader("Last 1337 days", color)
    ];
    return list;
  }

  Widget _listView(Color color) {
    return Column(children: [
      Expanded(
        child: FutureBuilder(
            future: _asyncWidget(color),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return LoadingFullScreenWidget();
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            snapshot.data[index]);
              }
            }),
      ),
    ]);
  }

  Widget _stickyHeader(String title, Color color) {
    return StickyHeader(
        header: HeaderCart(title),
        content: Column(
          children: <Widget>[
            Container(
                height: 300.0,
                child: Card(
                    margin: EdgeInsets.all(8.0),
                    color: color,
                    child: AreaAndLineChart(_createSampleData()))),
            _button()
          ],
        ));
  }

  Widget _button() {
    return StandardButton(
        title: "Reload data",
        onPress: _onClickMePresed,
        buttonColor: Theme.of(context).primaryColor);
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(milliseconds: 1200));
    _onClickMePresed();
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
