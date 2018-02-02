import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

class StateProperty<T> {
  PropertyChangeNotifier _notifier; 
  Symbol _symbol;
  T _value;
  VoidCallback _additionalChangeCallback;

  StateProperty(this._notifier, this._symbol, this._value, [this._additionalChangeCallback]);

  T get value => _value;
  set value(T newValue) {
    if (_value != newValue) {
      var oldValue = _value;
      _value = newValue;
      notifyPropertyChange(oldValue, newValue);
    }
  }

  void notifyPropertyChange(T oldValue, T newValue) {
      _notifier.notifyPropertyChange(_symbol, oldValue, newValue);    
      if (_additionalChangeCallback != null) {
        _additionalChangeCallback();
      }
  }
}
