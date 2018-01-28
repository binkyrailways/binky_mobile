import 'dart:async';
import 'package:flutter/material.dart';

import 'loc_list_view.dart';
import 'railway_state.dart';
import 'railway_state_control_panel.dart';
import 'server_client.dart';

class RailwayScreen extends StatefulWidget {
  final ServerClient _client;
  final VoidCallback _onConnectionSettings;

  RailwayScreen(this._client, this._onConnectionSettings);

  @override
  State createState() => new RailwayScreenState(_client, _onConnectionSettings);
}

class RailwayScreenState extends State<RailwayScreen> {
  final ServerClient _client;
  final VoidCallback _onConnectionSettings;
  final RailwayState _railwayState = new RailwayState();
  String _description = "Binky Railways";
  bool _isRunning = false;
  StreamSubscription<dynamic> _clientSubscription;

  // Default ctor
  RailwayScreenState(this._client, this._onConnectionSettings);

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
    setState(() {
      _description = _railwayState.description;
      _isRunning = _railwayState.isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRunning) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(_description),
          actions: [
            new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: _onConnectionSettings,
            ),
          ],
        ),
        body: new Column(children: [
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: new RailwayStateControlPanel(_client, _railwayState),
          ),
          new Divider(height: 1.0),
          new Flexible(child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: new LocListView(_client, _railwayState.locs),
            )
        )]),
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_description),
          actions: [
            new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: _onConnectionSettings,
            ),
          ],
      ),
      body: new Center(child: new Text("Editing...")),
    );
  }
}
