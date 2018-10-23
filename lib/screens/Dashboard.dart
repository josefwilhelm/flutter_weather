import 'package:flutter/material.dart';
import '../bloc/BlocProvider.dart';
import '../bloc/StationBloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    StationBloc bloc = BlocProvider.of(context);

    final tempWidget = Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.thermometerEmpty,
              color: Colors.blue,
              size: 42.0,
            ),
            Text("14.4 °C",
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.blue)),
          ],
        ),
      ),
    );
    final tempWidget1 = Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.thermometerEmpty,
              color: Colors.deepOrange,
              size: 42.0,
            ),
            Text("14.4 °C",
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.deepOrange)),
          ],
        ),
      ),
    );

    return BlocProvider(
        bloc: bloc,
        child: DefaultTabController(
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
                      Tab(
                          icon: Icon(FontAwesomeIcons.ravelry),
                          text: "Temperature"),
                    ],
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[tempWidget, tempWidget1],
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    Center(
                      child: Container(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.wb_cloudy,
                                color: Colors.blueGrey,
                                size: 60.0,
                              ),
                              Text("windy",
                                  style: Theme.of(context)
                                      .textTheme
                                      .display2
                                      .copyWith(color: Colors.blueGrey)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
