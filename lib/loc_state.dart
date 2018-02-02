import 'package:flutter/material.dart';
import 'package:observable/observable.dart';
import 'properties.dart';

class LocState extends PropertyChangeNotifier {
  final VoidCallback _triggerLocListChanged;
  String _id;
  StateProperty<String> _description;
  StateProperty<String> _owner;
  StateProperty<String> _speedText;
  StateProperty<String> _stateText;
  StateProperty<String> _direction;
  StateProperty<bool> _isAssigned;
  StateProperty<bool> _isControlledAutomatically;
  StateProperty<bool> _isCurrentRouteDurationExceeded;
  StateProperty<bool> _hasPossibleDeadlock;

  LocState(this._id, this._triggerLocListChanged) {
    _description = new StateProperty<String>(
        this, new Symbol("description"), "unknown railway");
    _owner = new StateProperty<String>(this, new Symbol("owner"), "");
    _speedText = new StateProperty<String>(this, new Symbol("speedText"), "");
    _stateText = new StateProperty<String>(this, new Symbol("stateText"), "");
    _direction = new StateProperty<String>(this, new Symbol("direction"), "forward");
    _isAssigned =
        new StateProperty<bool>(this, new Symbol("isAssigned"), false, _triggerLocListChanged);
    _isControlledAutomatically = new StateProperty<bool>(this, new Symbol("isControlledAutomatically"), false, _triggerLocListChanged);
    _isCurrentRouteDurationExceeded = new StateProperty<bool>(this, new Symbol("isCurrentRouteDurationExceeded"), false);
    _hasPossibleDeadlock = new StateProperty<bool>(this, new Symbol("hasPossibleDeadlock"), false);
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
    direction = msg["direction"] ?? "forward";
    isAssigned = msg["is-assigned"] ?? false;
    isControlledAutomatically = msg["is-controlled-automatically"] ?? false;
    isCurrentRouteDurationExceeded = msg["is-current-route-duration-exceeded"] ?? false;
    hasPossibleDeadlock = msg["has-possible-deadlock"] ?? false;
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

  String get direction => _direction.value;
  set direction(String value) => _direction.value = value;

  bool get isAssigned => _isAssigned.value;
  set isAssigned(bool value) => _isAssigned.value = value;

  bool get isControlledAutomatically => _isControlledAutomatically.value;
  set isControlledAutomatically(bool value) => _isControlledAutomatically.value = value;

  bool get isCurrentRouteDurationExceeded => _isCurrentRouteDurationExceeded.value;
  set isCurrentRouteDurationExceeded(bool value) => _isCurrentRouteDurationExceeded.value = value;

  bool get hasPossibleDeadlock => _hasPossibleDeadlock.value;
  set hasPossibleDeadlock(bool value) => _hasPossibleDeadlock.value = value;
}
