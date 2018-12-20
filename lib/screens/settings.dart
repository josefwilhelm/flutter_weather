import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitty_mingsi_flutter/bloc/AuthenticationBloc.dart';
import 'package:kitty_mingsi_flutter/components/GridItem.dart';

class ProfileWidget extends StatelessWidget {
  AuthenticationBloc _authBloc;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _authBloc = BlocProvider.of(context);
    return Scaffold(
        body: SafeArea(
      child: Flex(
          direction: Axis.vertical,
          children: <Widget>[_buildHeaderView(context), _buildGridView()]),
    ));
  }

  Widget _buildHeaderView(BuildContext context) {
    return Expanded(
      child: Stack(fit: StackFit.expand, children: <Widget>[
        Image.asset("assets/test.png", fit: BoxFit.fitHeight),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Icon(
                    FontAwesomeIcons.user,
                    size: 68.0,
                  )),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Profile Name",
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        )
      ]),
      flex: 2,
    );
  }

  Widget _buildGridView() {
    return Expanded(
      flex: 2,
      child: GridView.count(crossAxisCount: 2, children: <Widget>[
        GridItem(
            color: Colors.red,
            title: "Logout",
            onPress: () => _authBloc.onLogoutPressed(_context),
            icon: FontAwesomeIcons.powerOff),
        GridItem(
            color: Colors.green,
            title: "Stations",
            onPress: () => null,
            icon: Icons.beach_access),
      ]),
    );
  }
}
