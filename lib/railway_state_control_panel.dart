import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

import 'railway_state.dart';
import 'server_client.dart';

class RailwayStateControlPanel extends StatefulWidget {
  final ServerClient _client;
  final RailwayState _railwayState;

  RailwayStateControlPanel(this._client, this._railwayState);

  @override
  State createState() => new RailwayStateControlPanelState(_client, this._railwayState);
}

class RailwayStateControlPanelState extends State<RailwayStateControlPanel> {
  final ServerClient _client;
  final RailwayState _railwayState;
  StreamSubscription<List<ChangeRecord>> _subscription;

  RailwayStateControlPanelState(this._client, this._railwayState);

  @override  
  void initState() {
    super.initState();
    _subscription = _railwayState.changes.listen(onRailwayStateChanged);
  }

  @override  
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void onRailwayStateChanged(List<ChangeRecord> c) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var powerText = "";
    if (_railwayState.powerConsistent) {
      powerText = _railwayState.powerActual ? "Power is On" : "Power is Off";
    } else {
      powerText = _railwayState.powerRequested ? "Power will turn On" : "Power will turn Off";
    }
    var autoLocControlText = "";
    if (_railwayState.autoLocControlConsistent) {
      autoLocControlText = _railwayState.autoLocControlActual ? "Automatic control" : "Manual control";
    } else { 
      autoLocControlText = _railwayState.autoLocControlRequested ? "-> Auto" : "-> Manual";
    }
    return new Column(children: [
        new Row(children: [
          new Container( 
            margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: new Icon(_railwayState.powerActual ? Icons.check : Icons.power_settings_new)),
          new Expanded(child: new Text(powerText)),
          new FlatButton(
            child: new Text("On"),
            onPressed: _railwayState.powerActual ? null : _onPowerOn),
          new FlatButton(
            child: new Text("Off"),
            onPressed: _railwayState.powerActual ? _onPowerOff : null),
        ]),
        new Row(children: [
          new Container( 
            margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: new Icon(_railwayState.autoLocControlActual ? Icons.android : Icons.person)),
          new Expanded(child: new Text(autoLocControlText)),
          new FlatButton(
            child: new Text("Auto"),
            onPressed: _railwayState.autoLocControlActual ? null : _onAutoLocControlOn),
          new FlatButton(
            child: new Text("Manual"),
            onPressed: _railwayState.autoLocControlActual ? _onAutoLocControlOff : null),
        ]),
      ]);
  }

  _onPowerOn() {
    _client.publishControlMessage({
      "type": "power-on"
    });
  }

  _onPowerOff() {
    _client.publishControlMessage({
      "type": "power-off"
    });
  }

  _onAutoLocControlOn() { 
    _client.publishControlMessage({
      "type": "automatic-loccontroller-on"
    });
  }

  _onAutoLocControlOff() { 
    _client.publishControlMessage({
      "type": "automatic-loccontroller-off"
    });
  }
}
