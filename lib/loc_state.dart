import 'package:observable/observable.dart';
import 'properties.dart';

class LocState extends PropertyChangeNotifier {
  String _id;
  StateProperty<String> _description;
  StateProperty<String> _owner;
  StateProperty<String> _speedText;
  StateProperty<String> _stateText;
  StateProperty<bool> _isAssigned;

  LocState(this._id) {
    _description = new StateProperty<String>(
        this, new Symbol("description"), "unknown railway");
    _owner = new StateProperty<String>(this, new Symbol("owner"), "");
    _speedText = new StateProperty<String>(this, new Symbol("speedText"), "");
    _stateText = new StateProperty<String>(this, new Symbol("stateText"), "");
    _isAssigned =
        new StateProperty<bool>(this, new Symbol("isAssigned"), false);
  }

  int compareTo(LocState other) {
    if (isAssigned && !other.isAssigned) {
      return -1;
    } else if (!isAssigned && other.isAssigned) {
      return 1;
    }
    var rc = description.compareTo(other.description);
    if (rc != 0) {
      return rc;
    }
    return owner.compareTo(other.owner);
  }

  void loadFromLocMessage(dynamic msg) {
    description = msg["description"] ?? "";
    owner = msg["owner"] ?? "";
    speedText = msg["speedText"] ?? "";
    stateText = msg["stateText"] ?? "";
    isAssigned = msg["isAssigned"] ?? false;
  }

  String get id => _id;

  String get description => _description.value;
  set description(String value) => _description.value = value;

  String get owner => _owner.value;
  set owner(String value) => _owner.value = value;

  String get speedText => _speedText.value;
  set speedText(String value) => _speedText.value = value;

  String get stateText => _stateText.value;
  set stateText(String value) => _stateText.value = value;

  bool get isAssigned => _isAssigned.value;
  set isAssigned(bool value) => _isAssigned.value = value;
}
