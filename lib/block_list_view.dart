import 'package:flutter/material.dart';

import 'block_bottom_sheet.dart';
import 'block_state.dart';
import 'block_list_item.dart';
import 'server_client.dart';

typedef void BlockTappedCallback(BlockState block);

class BlockListView extends StatefulWidget {
  final ServerClient _client;
  final List<BlockState> _blocks;

  BlockListView(this._client, this._blocks) : super(key: new Key(_blocks.hashCode.toString()));

  @override
  State createState() => new BlockListViewState(_client, this._blocks);
}

class BlockListViewState extends State<BlockListView> {
  final ServerClient _client;
  List<BlockState> _blocks;
  PersistentBottomSheetController<BlockBottomSheet> _bottomSheetController;
  BlockState _bottomSheetBlock;

  BlockListViewState(this._client, this._blocks);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (_, int index) => new GestureDetector(
        child: new BlockListItem(_client, _blocks[index]), 
        onTap: () => _onItemTapped(context, index)),
      itemCount: _blocks.length,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    var block = _blocks[index];
    if ((_bottomSheetBlock == block) && (_bottomSheetController != null)) {
      // Close sheet 
      _bottomSheetController.close();
    } else {
      // Show bottom sheet
      _bottomSheetBlock = block;
      _bottomSheetController = Scaffold.of(context).showBottomSheet<BlockBottomSheet>((c) => new BlockBottomSheet(_client, block));
      _bottomSheetController.closed.then((x) {
        if (_bottomSheetBlock == block) {
          _bottomSheetBlock = null;
          _bottomSheetController = null;
        }
      });
    }
  }
}
