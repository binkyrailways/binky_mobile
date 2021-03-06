import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

import 'block_list_view.dart';
import 'loc_list_view.dart';
import 'loc_state.dart';
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
  String _modelTime = "";
  String _view = "locs";
  StreamSubscription<dynamic> _clientSubscription;
  StreamSubscription<List<ChangeRecord>> _subscription;

  // Default ctor
  RailwayScreenState(this._client, this._onConnectionSettings);

    @override  
  void initState() {
    super.initState();
    _clientSubscription = _client.messages.listen(_processDataMessage);
    _client.publishControlMessage({"type": "refresh"});
    _subscription = _railwayState.changes.listen(onRailwayStateChanged);
  }

  @override  
  void dispose() {
    _clientSubscription.cancel();
    _subscription.cancel();
    super.dispose();
  }

  void onRailwayStateChanged(List<ChangeRecord> c) {
    setState(() {});
  }

  void _processDataMessage(dynamic msg) {
    _railwayState.processDataMessage(msg);
    setState(() {
      _description = _railwayState.description;
      _modelTime = _railwayState.modelTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_railwayState.isRunning) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(_modelTime),
          actions: [
            new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: _onConnectionSettings,
            ),
          ],
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new DrawerHeader(
                child: new Text(_description)
              ),
              new ListTile(
                leading: new Icon(Icons.directions_railway),
                title: new Text('Locs'),
                selected: _view == "locs",
                onTap: () {
                  setState(() => _view = "locs");
                  Navigator.pop(context); // close the drawer
                },
              ),
              new ListTile(
                leading: new Icon(Icons.my_location),
                title: new Text('Blocks'),
                selected: _view == "blocks",
                onTap: () {
                  setState(() => _view = "blocks");
                  Navigator.pop(context); // close the drawer
                },                
              )
            ],
          )
        ),
        body: new Column(children: [
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: new RailwayStateControlPanel(_client, _railwayState),
          ),
          new Divider(height: 1.0),
          new Flexible(child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: _view == "blocks" ? 
                new BlockListView(_client, _railwayState.blocks) :
                new LocListView(_client, _railwayState.locs),
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
