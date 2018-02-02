import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

import 'loc_state.dart';
import 'server_client.dart';

class LocBottomSheet extends StatefulWidget {
  final ServerClient _client;
  final LocState _loc;

  LocBottomSheet(this._client, this._loc);

  @override
  State createState() => new LocBottomSheetState(_client, this._loc);
}

class LocBottomSheetState extends State<LocBottomSheet> {
  final TextStyle unassignedStyle = new TextStyle(color: Colors.grey);
  final ServerClient _client;
  final LocState _loc;
  StreamSubscription<List<ChangeRecord>> _subscription;

  LocBottomSheetState(this._client, this._loc);

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
    var headerStyle = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5, fontWeightDelta: 1);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      new Divider(height: 1.0),
      new Container(
          margin: new EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          decoration: new BoxDecoration(
              color: _loc.isCurrentRouteDurationExceeded
                  ? Colors.red
                  : _loc.hasPossibleDeadlock ? Colors.orange : null),
          child: new Column(mainAxisSize: MainAxisSize.min, children: [
            new Row(children: [
              new Expanded(
                  child: new Text(_loc.description, style: headerStyle)),
            ]),
            new Row(
              children: !_loc.isAssigned ? [] : [
                new Expanded(child: new Text("Automatic control")),
                new Switch(
                  value: _loc.isControlledAutomatically,
                  onChanged: _loc.isAssigned
                      ? ((x) => _loc.isControlledAutomatically
                          ? _onControlManually()
                          : _onControlAutomatically())
                      : null,
                )
              ],
            ),
            new Row(
              children: !_loc.isAssigned ? [] : [
                new Expanded(child: new FlatButton(
                  child: new Text("Reverse"),
                  onPressed: _loc.direction == "forward" ? _onReverse : null,
                )),
                new Expanded(child: new FlatButton(
                  child: new Text("Stop"),
                  onPressed: null,
                )),
                new Expanded(child: new FlatButton(
                  child: new Text("Forward"),
                  onPressed: _loc.direction == "reverse" ? _onForward : null,
                )),
              ],
            ),
            new Divider(height: 32.0),
            new Row(
              children: !_loc.isAssigned ? [] : [
                new Expanded(
                  child: new FlatButton(
                    textColor: Colors.red[200],
                    child: new Text("Take off track"),
                    onPressed: _loc.isAssigned ? _onRemoveFromTrack : null,
                  ),
                )
              ],
            )
          ]))
    ]);
  }

  void _onControlAutomatically() {
    _client.publishControlMessage(
        {"type": "control-automatically", "id": _loc.id});
  }

  void _onControlManually() {
    _client.publishControlMessage({"type": "control-manually", "id": _loc.id});
  }

  void _onRemoveFromTrack() {
    _client.publishControlMessage({"type": "remove-from-track", "id": _loc.id});
  }

  void _onReverse() {
    _client.publishControlMessage({"type": "direction-reverse", "id": _loc.id});
  }

  void _onForward() {
    _client.publishControlMessage({"type": "direction-forward", "id": _loc.id});
  }
}
