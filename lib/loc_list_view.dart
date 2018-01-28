import 'package:flutter/material.dart';

import 'loc_state.dart';
import 'loc_list_item.dart';
import 'server_client.dart';

class LocListView extends StatefulWidget {
  final ServerClient _client;
  final List<LocState> _locs;

  LocListView(this._client, this._locs);

  @override
  State createState() => new LocListViewState(_client, this._locs);
}

class LocListViewState extends State<LocListView> {
  final ServerClient _client;
  List<LocState> _locs;

  LocListViewState(this._client, this._locs);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (_, int index) => new LocListItem(_client, _locs[index]),
      itemCount: _locs.length,
    );
  }
}
