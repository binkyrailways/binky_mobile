import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

import 'loc_state.dart';
import 'server_client.dart';

class LocListItem extends StatefulWidget {
  final ServerClient _client;
  final LocState _loc;

  LocListItem(this._client, this._loc);

  @override
  State createState() => new LocListItemState(_client, this._loc);
}

class LocListItemState extends State<LocListItem> {
  final ServerClient _client;
  final LocState _loc;
  StreamSubscription<List<ChangeRecord>> _subscription;
  String _description;
  String _owner;
  String _stateText;
  String _speedText;

  LocListItemState(this._client, this._loc) {
    _description = _loc.description;
    _owner = _loc.owner;
    _stateText = _loc.stateText;
    _speedText = _loc.speedText;
  }

  @override
  void initState() {
    super.initState();
    _subscription = _loc.changes.listen(onLocStateChanged);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void onLocStateChanged(List<ChangeRecord> c) {
    setState(() {
      _description = _loc.description;
      _owner = _loc.owner;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: new Column(children: [
        new Row(children: [
          new Expanded(child: new Text(_description)),
          new Text(_loc.stateText)
        ]),
        new Row(children: [
          new Expanded(child: new Text(_owner)),
          new Text(_loc.speedText)
        ]),
      ])
    );
  }
}
