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

class RailwayState extends PropertyChangeNotifier {
  StateProperty<String> _description;
  StateProperty<bool> _isRunning;
  StateProperty<bool> _powerActual;
  StateProperty<bool> _powerRequested;
  StateProperty<bool> _autoLocControlActual;
  StateProperty<bool> _autoLocControlRequested;

  RailwayState() {
    _description = new StateProperty<String>(this, new Symbol("description"), "unknown railway");
    _isRunning = new StateProperty<bool>(this, new Symbol("isRunning"), false);    
    _powerActual = new StateProperty<bool>(this, new Symbol("powerActual"), false);
    _powerRequested = new StateProperty<bool>(this, new Symbol("powerRequested"), false);
    _autoLocControlActual = new StateProperty<bool>(this, new Symbol("autoLocControlActual"), false);
    _autoLocControlRequested = new StateProperty<bool>(this, new Symbol("autoLocControlRequested"), false);
  }

  String get description => _description.value;
  set description(String value) => _description.value = value;

  bool get isRunning => _isRunning.value;
  set isRunning(bool value) => _isRunning.value = value;

  bool get powerActual => _powerActual.value;
  set powerActual(bool value) => _powerActual.value = value;

  bool get powerRequested => _powerRequested.value;
  set powerRequested(bool value) => _powerRequested.value = value;

  bool get autoLocControlActual => _autoLocControlActual.value; 
  set autoLocControlActual(bool value) => _autoLocControlActual.value = value; 

  bool get autoLocControlRequested => _autoLocControlRequested.value;     
  set autoLocControlRequested(bool value) => _autoLocControlRequested.value = value;

  void processDataMessage(dynamic msg) {
      var msgType = msg["type"];
      print("msg type: $msgType");
      switch (msgType) {
        case "railway":
          description = msg["description"] ?? "unknown railway";
          break; 
        case "editing":
          isRunning = false;
          break;
        case "running":
          isRunning = true;
          break;
        case "power-changed":
          powerActual = msg["actual"];
          powerRequested = msg["requested"];
          break;
        case "automatic-loccontroller-changed":
          autoLocControlActual = msg["actual"];
          autoLocControlRequested = msg["requested"];
          break;
      }

  }
}
