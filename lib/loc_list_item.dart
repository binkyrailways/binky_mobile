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
  final TextStyle unassignedStyle = new TextStyle(color: Colors.grey);
  final ServerClient _client;
  final LocState _loc;
  StreamSubscription<List<ChangeRecord>> _subscription;

  LocListItemState(this._client, this._loc);

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final style = _loc.isAssigned ? null : unassignedStyle;
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: new BoxDecoration(color: _loc.isCurrentRouteDurationExceeded ? Colors.red : _loc.hasPossibleDeadlock ? Colors.orange : null),
      child: new Column(children: [
        new Row(children: [
          new Expanded(child: new Text(_loc.description, style: style)),
          new Text(_loc.stateText, style: style)
        ]),
        new Row(children: [
          new Expanded(child: new Text(_loc.owner, style: style)),
          new Text(_loc.speedText, style: style)
        ]),
      ])
    );
  }
}
