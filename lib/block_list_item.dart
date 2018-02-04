import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

import 'block_state.dart';
import 'server_client.dart';

class BlockListItem extends StatefulWidget {
  final ServerClient _client;
  final BlockState _block;

  BlockListItem(this._client, this._block);

  @override
  State createState() => new BlockListItemState(_client, this._block);
}

class BlockListItemState extends State<BlockListItem> {
  final TextStyle unassignedStyle = new TextStyle(color: Colors.grey);
  final ServerClient _client;
  final BlockState _block;
  StreamSubscription<List<ChangeRecord>> _subscription;

  BlockListItemState(this._client, this._block);

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
    var lockedBy = _block.lockedByLoc;
    Color color;
    if (_block.isOccupiedUnexpected) {
      color = Colors.orange;
    } else if (_block.isClosed) {
      color = Colors.grey;
    } else {
      switch (_block.state) {
        case "occupied":
          color = Colors.red[200];
          break;
        case "destination":
          color = Colors.yellow[200];
          break;
        case "entering":
          color = Colors.lightGreen[200];
          break;
        case "locked":
          color = Colors.cyan[200];
          break;
      }
    }
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: new BoxDecoration(color: color),
      child: new Column(children: [
        new Row(children: [
          new Expanded(child: new Text(_block.description)),
          new Text(lockedBy != null ? lockedBy.description : "")
        ]),
      ])
    );
  }
}
