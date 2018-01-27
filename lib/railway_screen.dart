import 'dart:async';
import 'package:flutter/material.dart';

import 'railway_state.dart';
import 'railway_state_control_panel.dart';
import 'server_client.dart';

class RailwayScreen extends StatefulWidget {
  final ServerClient _client;

  RailwayScreen(this._client);

  @override
  State createState() => new RailwayScreenState(_client);
}

class RailwayScreenState extends State<RailwayScreen> {
  final ServerClient _client;
  final RailwayState _railwayState = new RailwayState();
  bool _isRunning = false;
  StreamSubscription<dynamic> _clientSubscription;

  RailwayScreenState(this._client);

    @override  
  void initState() {
    super.initState();
    _clientSubscription = _client.messages.listen(_processDataMessage);
    _client.publishControlMessage({"type": "refresh"});
  }

  @override  
  void dispose() {
    _clientSubscription.cancel();
    super.dispose();
  }

  void _processDataMessage(dynamic msg) {
    _railwayState.processDataMessage(msg);
    setState(() => _isRunning = _railwayState.isRunning);
  }

  @override
  Widget build(BuildContext context) {
    if (_isRunning) {
      return new Scaffold(
        appBar: new AppBar(title: new Text("BinkyRailways")),
        body: new Column(children: [
          new RailwayStateControlPanel(_client, _railwayState),
          new Center(child: new Text("Running")),
        ]),
      );
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text("BinkyRailways")),
      body: new Center(child: new Text("Editing...")),
    );
  }
}
