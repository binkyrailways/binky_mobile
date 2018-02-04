import 'package:flutter/material.dart';

import 'loc_bottom_sheet.dart';
import 'loc_state.dart';
import 'loc_list_item.dart';
import 'server_client.dart';

typedef void LocTappedCallback(LocState loc);

class LocListView extends StatefulWidget {
  final ServerClient _client;
  final List<LocState> _locs;

  LocListView(this._client, this._locs) : super(key: new Key(_locs.hashCode.toString()));

  @override
  State createState() => new LocListViewState(_client, this._locs);
}

class LocListViewState extends State<LocListView> {
  final ServerClient _client;
  List<LocState> _locs;
  PersistentBottomSheetController<LocBottomSheet> _bottomSheetController;
  LocState _bottomSheetLoc;

  LocListViewState(this._client, this._locs);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (ctx, int index) => new GestureDetector(
        child: new LocListItem(_client, _locs[index]), 
        onTap: () => _onItemTapped(ctx, index)),
      itemCount: _locs.length,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    var loc = _locs[index];
    if ((_bottomSheetLoc == loc) && (_bottomSheetController != null)) {
      // Close sheet 
      _bottomSheetController.close();
    } else {
      // Show bottom sheet
      _bottomSheetLoc = loc;
      _bottomSheetController = Scaffold.of(context).showBottomSheet<LocBottomSheet>((c) => new LocBottomSheet(_client, loc));
      _bottomSheetController.closed.then((x) {
        if (_bottomSheetLoc == loc) {
          _bottomSheetLoc = null;
          _bottomSheetController = null;
        }
      });
    }
  }
}
