import 'package:observable/observable.dart';

import 'properties.dart';
import 'block_state.dart';
import 'loc_state.dart';

class RailwayState extends PropertyChangeNotifier {
  StateProperty<String> _description;
  StateProperty<bool> _isRunning;
  StateProperty<bool> _powerActual;
  StateProperty<bool> _powerRequested;
  StateProperty<bool> _autoLocControlActual;
  StateProperty<bool> _autoLocControlRequested;
  StateProperty<List<LocState>> _locs;
  StateProperty<List<BlockState>> _blocks;
  StateProperty<String> _modelTime;

  RailwayState() {
    _description = new StateProperty<String>(this, new Symbol("description"), "unknown railway");
    _isRunning = new StateProperty<bool>(this, new Symbol("isRunning"), false);    
    _powerActual = new StateProperty<bool>(this, new Symbol("powerActual"), false);
    _powerRequested = new StateProperty<bool>(this, new Symbol("powerRequested"), false);
    _autoLocControlActual = new StateProperty<bool>(this, new Symbol("autoLocControlActual"), false);
    _autoLocControlRequested = new StateProperty<bool>(this, new Symbol("autoLocControlRequested"), false);
    _locs = new StateProperty<List<LocState>>(this, new Symbol("locs"), new List<LocState>());
    _blocks = new StateProperty<List<BlockState>>(this, new Symbol("blocks"), new List<BlockState>());
    _modelTime = new StateProperty<String>(this, new Symbol("modelTime"), "");
  }

  String get description => _description.value;
  set description(String value) => _description.value = value;

  String get modelTime => _modelTime.value;
  set modelTime(String value) => _modelTime.value = value;

  bool get isRunning => _isRunning.value;
  set isRunning(bool value) => _isRunning.value = value;

  bool get powerConsistent => _powerActual.value == _powerRequested.value;

  bool get powerActual => _powerActual.value;
  set powerActual(bool value) => _powerActual.value = value;

  bool get powerRequested => _powerRequested.value;
  set powerRequested(bool value) => _powerRequested.value = value;

  bool get autoLocControlConsistent => _autoLocControlActual.value == _autoLocControlRequested.value;

  bool get autoLocControlActual => _autoLocControlActual.value; 
  set autoLocControlActual(bool value) => _autoLocControlActual.value = value; 

  bool get autoLocControlRequested => _autoLocControlRequested.value;     
  set autoLocControlRequested(bool value) => _autoLocControlRequested.value = value;

  List<LocState> get locs => _locs.value;
  set locs(List<LocState> value) => _locs.value = value;

  List<BlockState> get blocks => _blocks.value;
  set blocks(List<BlockState> value) => _blocks.value = value;

  void processDataMessage(dynamic msg) {
      var msgType = msg["type"];
      //print("msg type: $msgType");
      switch (msgType) {
        case "railway":
          description = msg["description"] ?? "unknown railway";
          var locs = msg["locs"] ?? [];
          var locStates = new List<LocState>();
          for (final l in locs) {
            var id = l["id"] ?? l["description"] ?? "";
            var locState = new LocState(id, _onNotifyLocsChanged)
              ..loadFromLocMessage(l);
            locStates.add(locState);
          }
          locStates.sort((a, b) => a.compareTo(b));
          this.locs = locStates;
          var blocks = msg["blocks"] ?? [];
          var blockStates = new List<BlockState>();
          for (final b in blocks) {
            var id = b["id"] ?? b["description"] ?? "";
            var blockState = new BlockState(this, id)
              ..loadFromBlockMessage(b);
            blockStates.add(blockState);
          }
          blockStates.sort((a, b) => a.compareTo(b));
          this.blocks = blockStates;
          break; 
        case "editing":
          isRunning = false;
          break;
        case "running":
          isRunning = true;
          break;
        case "time-changed":
          var h = msg["hour"] ?? 0;
          var m = (msg["minute"] ?? 0).toString().padLeft(2, "0");
          modelTime = "$h:$m";
          break;
        case "power-changed":
          powerActual = msg["actual"] ?? false;
          powerRequested = msg["requested"] ?? false;
          break;
        case "automatic-loccontroller-changed":
          autoLocControlActual = msg["actual"] ?? false;
          autoLocControlRequested = msg["requested"] ?? false;
          break;
        case "block-changed":
          var b = msg["block"] ?? {};
          var id = b["id"];
          var blockState = blocks.firstWhere((bs) => bs.id == id, orElse: () => null); 
          if (blockState != null) {
            blockState.loadFromBlockMessage(b);
          }
          break;
        case "loc-changed":
          var l = msg["loc"] ?? {};
          var id = l["id"];
          var locState = locs.firstWhere((ls) => ls.id == id, orElse: () => null); 
          if (locState != null) {
            locState.loadFromLocMessage(l);
          }
          break;
      }
  }

  void _onNotifyLocsChanged() {
    locs.sort((a, b) => a.compareTo(b));
  }
}
