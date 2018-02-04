import 'package:observable/observable.dart';
import 'properties.dart';

class BlockState extends PropertyChangeNotifier {
  String _id;
  StateProperty<String> _description;

  BlockState(this._id) {
    _description = new StateProperty<String>(
        this, new Symbol("description"), "?");
  }

  int compareTo(BlockState other) {
    var rc = description.compareTo(other.description);
    if (rc != 0) {
      return rc;
    }
    return 0;
  }

  void loadFromBlockMessage(dynamic msg) {
    description = msg["description"] ?? "";
  }

  String get id => _id;

  String get description => _description.value;
  set description(String value) => _description.value = value;
}
