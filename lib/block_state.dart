import 'package:observable/observable.dart';

import 'properties.dart';
import 'loc_state.dart';
import 'railway_state.dart';

class BlockState extends PropertyChangeNotifier {
  final RailwayState _railwayState;
  final String _id;
  StateProperty<String> _description;
  StateProperty<String> _lockedBy;
  StateProperty<String> _state;
  StateProperty<bool> _isClosed;

  BlockState(this._railwayState, this._id) {
    _description = new StateProperty<String>(
        this, new Symbol("description"), "?");
    _lockedBy = new StateProperty<String>(
        this, new Symbol("lockedBy"), "");
    _state = new StateProperty<String>(
        this, new Symbol("state"), "");
    _isClosed = new StateProperty<bool>(
        this, new Symbol("isClosed"), false);
  }

  int compareTo(BlockState other) {
    if (isOccupiedUnexpected && !other.isOccupiedUnexpected) {
      return -1;
    }
    if (!isOccupiedUnexpected && other.isOccupiedUnexpected) {
      return 1;
    }
    var rc = description.compareTo(other.description);
    if (rc != 0) {
      return rc;
    }
    return 0;
  }

  void loadFromBlockMessage(dynamic msg) {
    description = msg["description"] ?? "";
    state = msg["state"] ?? "";
    lockedBy = msg["locked-by"] ?? "";
    isClosed = msg["is-closed"] ?? false;
  }

  String get id => _id;

  String get description => _description.value;
  set description(String value) => _description.value = value;

  String get state => _state.value;
  set state(String value) => _state.value = value;

  bool get isOccupiedUnexpected => state == "occupiedunexpected";

  String get lockedBy => _lockedBy.value;
  set lockedBy(String value) => _lockedBy.value = value;

  LocState get lockedByLoc => _railwayState.locs.firstWhere((ls) => ls.id == lockedBy, orElse: () => null); 

  bool get isClosed => _isClosed.value;
  set isClosed(bool value) => _isClosed.value = value;
}
