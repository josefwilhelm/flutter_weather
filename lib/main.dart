import 'dataRepository.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/bottomNavigation.dart';
import 'screens/settings.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF67697C),
            // primaryColor: const Color(0xFF82AC9F),
            accentColor: const Color(0xFF82AC9F),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: const Color(0xFF53687E))),
        initialRoute: "/",
        routes: {
          "/": (context) => Login(),
          "/home": (context) => MyHomePage(),
          "/settings": (context) => SettingsWidget(),
          "/start": (context) => BottomNavigationWidget(),
          "/data": (context) => DataRepository()
        });
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text("Look at my charts"), //new Text(widget.title),
        ),
        body: Builder(
            builder: (context) => Column(
                  children: <Widget>[
                    Text(
                      "Yo headline",
                      style: Theme.of(context).textTheme.display2,
                    ),
                    Expanded(
                      child: ListView(
                          // padding: EdgeInsets.all(24.0),
                          children: <Widget>[
                            RaisedButton(
                                child: Text("Click me"),
                                onPressed: () {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Halloooooooo')));
                                }),
                            Container(
                                height: 300.0,
                                child: Card(
                                    color: Theme.of(context).accentColor,
                                    child: AreaAndLineChart.withSampleData())),
                            RaisedButton(
                                child: Text("Click me"),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/settings");
                                }),
                            Container(
                                height: 300.0,
                                child: AreaAndLineChart.withSampleData()),
                          ]),
                    ),
                  ],
                )));
  }
}

class AreaAndLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  AreaAndLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory AreaAndLineChart.withSampleData() {
    return new AreaAndLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

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
  static List<charts.Series<WeatherValue, DateTime>> _createSampleData() {
    final data = [
      new WeatherValue(new DateTime(2017, 9, 10), 5),
      new WeatherValue(new DateTime(2017, 9, 11), 25),
      new WeatherValue(new DateTime(2017, 9, 12), 23),
      new WeatherValue(new DateTime(2017, 9, 13), 44),
      new WeatherValue(new DateTime(2017, 9, 19), 5),
      new WeatherValue(new DateTime(2017, 9, 20), 25),
      new WeatherValue(new DateTime(2017, 9, 21), 33),
      new WeatherValue(new DateTime(2017, 9, 22), 75),
    ];

    return [
      new charts.Series<WeatherValue, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (WeatherValue sales, _) => sales.time,
        measureFn: (WeatherValue sales, _) => sales.temp,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class WeatherValue {
  final DateTime time;
  final int temp;

  WeatherValue(this.time, this.temp);
}
