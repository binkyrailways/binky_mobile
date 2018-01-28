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
  bool _powerActual;
  bool _powerRequested;
  bool _autoLocControlActual;
  bool _autoLocControlRequested;
  StreamSubscription<List<ChangeRecord>> _subscription;

  RailwayStateControlPanelState(this._client, this._railwayState) {
    _powerActual = false;
    _powerRequested = false;
    _autoLocControlActual = false;
    _autoLocControlRequested = false;
  }

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
    setState(() {
      _powerActual = _railwayState.powerActual;
      _powerRequested = _railwayState.powerRequested;
      _autoLocControlActual = _railwayState.autoLocControlActual;
      _autoLocControlRequested = _railwayState.autoLocControlRequested;
    });
  }

  @override
  Widget build(BuildContext context) {
    var powerText = "";
    if (_powerActual == _powerRequested) {
      powerText = _powerActual ? "Power is On" : "Power is Off";
    } else {
      powerText = _powerRequested ? "Power will turn On" : "Power will turn Off";
    }
    var autoLocControlText = "";
    if (_autoLocControlActual == _autoLocControlRequested) {
      autoLocControlText = _autoLocControlActual ? "Automatic control" : "Manual control";
    } else { 
      autoLocControlText = _autoLocControlRequested ? "-> Auto" : "-> Manual";
    }
    return new Column(children: [
        new Row(children: [
          new Container( 
            margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: new Icon(_powerActual ? Icons.check : Icons.power_settings_new)),
          new Expanded(child: new Text(powerText)),
          new FlatButton(
            child: new Text("On"),
            onPressed: _powerActual ? null : _onPowerOn),
          new FlatButton(
            child: new Text("Off"),
            onPressed: _powerActual ? _onPowerOff : null),
        ]),
        new Row(children: [
          new Container( 
            margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: new Icon(_autoLocControlActual ? Icons.android : Icons.person)),
          new Expanded(child: new Text(autoLocControlText)),
          new FlatButton(
            child: new Text("Auto"),
            onPressed: _autoLocControlActual ? null : _onAutoLocControlOn),
          new FlatButton(
            child: new Text("Manual"),
            onPressed: _autoLocControlActual ? _onAutoLocControlOff : null),
        ]),
      ]);
  }

  _onPowerOn() {
    _client.publishControlMessage({
      "type": "power-on"
    });
    setState(() => _powerRequested = true);
  }

  _onPowerOff() {
    _client.publishControlMessage({
      "type": "power-off"
    });
    setState(() => _powerRequested = false);
  }

  _onAutoLocControlOn() { 
    _client.publishControlMessage({
      "type": "automatic-loccontroller-on"
    });
    setState(() => _autoLocControlRequested = true);    
  }

  _onAutoLocControlOff() { 
    _client.publishControlMessage({
      "type": "automatic-loccontroller-off"
    });
    setState(() => _autoLocControlRequested = false);    
  }
}
