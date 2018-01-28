import 'package:observable/observable.dart';

class StateProperty<T> {
  PropertyChangeNotifier _notifier; 
  Symbol _symbol;
  T _value;

  StateProperty(this._notifier, this._symbol, this._value);

  T get value => _value;
  set value(T newValue) {
    if (_value != newValue) {
      var oldValue = _value;
      _value = newValue;
      _notifier.notifyPropertyChange(_symbol, oldValue, newValue);
    }
  }
}
