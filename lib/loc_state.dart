import 'package:observable/observable.dart';
import 'properties.dart';

class LocState extends PropertyChangeNotifier {
  String _id;
  StateProperty<String> _description;
  StateProperty<String> _owner;

  LocState(this._id) {
    _description = new StateProperty<String>(this, new Symbol("description"), "unknown railway");
    _owner = new StateProperty<String>(this, new Symbol("owner"), "");
  }

  String get id => _id;

  String get description => _description.value;
  set description(String value) => _description.value = value;

  String get owner => _owner.value;
  set owner(String value) => _owner.value = value;
}
