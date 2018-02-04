import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

import 'block_state.dart';
import 'server_client.dart';

class BlockBottomSheet extends StatefulWidget {
  final ServerClient _client;
  final BlockState _block;

  BlockBottomSheet(this._client, this._block);

  @override
  State createState() => new BlockBottomSheetState(_client, this._block);
}

class BlockBottomSheetState extends State<BlockBottomSheet> {
  final TextStyle unassignedStyle = new TextStyle(color: Colors.grey);
  final ServerClient _client;
  final BlockState _block;
  StreamSubscription<List<ChangeRecord>> _subscription;

  BlockBottomSheetState(this._client, this._block);

  @override
  void initState() {
    super.initState();
    _subscription = _block.changes.listen(onBlockStateChanged);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void onBlockStateChanged(List<ChangeRecord> c) {
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
          child: new Column(mainAxisSize: MainAxisSize.min, children: [
            new Row(children: [
              new Expanded(
                  child: new Text(_block.description, style: headerStyle)),
            ]),
            new Row(
              children: [
                new Expanded(child: new FlatButton(
                  child: new Text("Open"),
                  onPressed: _block.isClosed ? _onOpen : null,
                )),
                new Expanded(child: new FlatButton(
                  child: new Text("Close"),
                  onPressed: _block.isClosed ? null : _onClose,
                )),
              ],
            )
          ]))
    ]);
  }

  void _onOpen() {
    _client.publishControlMessage({"type": "open-block", "id": _block.id});
  }

  void _onClose() {
    _client.publishControlMessage({"type": "close-block", "id": _block.id});
  }
}
