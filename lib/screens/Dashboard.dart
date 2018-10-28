import 'package:flutter/material.dart';
import '../bloc/BlocProvider.dart';
import '../bloc/StationBloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../components/StandardButtonWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Station.dart';
import '../components/LoadingFullscreen.dart';
import '../util/DoubleToStringWithDigitsConverter.dart';

class Dashboard extends StatefulWidget {
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final airTempTitle = "Air Temperature";
  final groundTempTitle = "Ground Temperature";
  final airPressureTitle = "Air Pressure";
  final humidityTitle = "Humidity";
  final precipitationLastHourTitle = "Last Hour";
  final precipitationLast24hTitle = "Last 24h";

  @override
  Widget build(BuildContext context) {
    StationBloc bloc = BlocProviderGeneric.of(context);
    return BlocProviderGeneric(
        bloc: bloc,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Dashboard"),
            ),
            body: StreamBuilder(
                stream: bloc.stationValue,
                builder: ((context, AsyncSnapshot<StationValue> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingFullScreenWidget();
                  } else if (snapshot.hasData) {
                    var snap = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _header(bloc),
                        _column(snap.temperatureAir, airTempTitle,
                            snap.temperatureGround, groundTempTitle),
                        _column(snap.airPressure.toDouble(), airPressureTitle,
                            snap.humidity, humidityTitle),
                        _column(snap.precipition, precipitationLastHourTitle,
                            snap.precipition * 2.5, precipitationLast24hTitle),
                        Expanded(
                          child: Container(),
                        ),
                        _button(context, bloc)
                      ],
                    );
                  }
                  return Container();
                }))));
  }

  Widget _header(StationBloc bloc) {
    return StreamBuilder(
      stream: bloc.stationName,
      builder: (BuildContext context, AsyncSnapshot<Station> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
              child: Card(
                  color: Colors.grey,
                  child: Text("Station: " + snapshot.data.name)));
        }
        return Container();
      },
    );
  }

  Widget _column(double firstValue, String firstTitle, double secondValue,
      String secondTitle) {
    String first =
        DoubleToStringWithDigitsConverter.doubleToStringWithDigitsConverter(
            firstValue);
    String second =
        DoubleToStringWithDigitsConverter.doubleToStringWithDigitsConverter(
            secondValue);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 120.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DefaultWeatherWidget(
              value: first,
              title: firstTitle,
            ),
            SizedBox(
              width: 48.0,
            ),
            DefaultWeatherWidget(value: second, title: secondTitle),
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context, StationBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: StandardButton(
        onPress: () => _bottomSheet(context, bloc),
        title: "Choose Station",
        buttonColor: Colors.teal[800],
        padding: EdgeInsets.all(12.0),
      ),
    );
  }

  void _bottomSheet(BuildContext context, StationBloc bloc) {
    bloc.fetchAllStations();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder(
              stream: bloc.allStations,
              builder: (context, AsyncSnapshot<List<Station>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return _buildList(snapshot.data, bloc);
                }
                return Container();
              });
        });
  }

  Widget _buildList(List<Station> data, StationBloc bloc) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                bloc.changeStation.add(data[index]);
                Navigator.pop(context);
              },
              child: _debugListItem(context, data[index].name));
        });
  }

  Widget _debugListItem(BuildContext context, String s) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: Text(
        s,
        style: Theme.of(context).textTheme.display1,
      )),
    );
  }
}

class DefaultWeatherWidget extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;

  DefaultWeatherWidget(
      {@required this.value, @required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            title == null
                ? Container()
                : Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]))),
                      child: AutoSizeText(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    flex: 1,
                  ),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  child: AutoSizeText(
                    value == null ? "-" : value,
                    style: Theme.of(context).textTheme.display1,
                    maxLines: 1,
                  ),
                ),
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(colors: [
            Colors.grey[100],
            Colors.grey[800],
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),
      ),
    );
  }
}
