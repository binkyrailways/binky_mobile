import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server_client.dart';

typedef void ConnectedCallback(ServerClient client);

class ConnectScreen extends StatefulWidget {
  final ConnectedCallback _connected;

  ConnectScreen(this._connected);

  @override
  State createState() => new ConnectScreenState(_connected);
}

class ConnectScreenState extends State<ConnectScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ConnectedCallback _connected;
  final TextEditingController _mqttHostController = new TextEditingController();
  final TextEditingController _mqttPortController = new TextEditingController(text: "1883");
  final TextEditingController _mqttTopicController = new TextEditingController(text: "/binkyrailways");
  bool _inputValid = false;
  bool _connecting = false;

  ConnectScreenState(this._connected);

  Future<Null> _loadPreferences() async {
    final SharedPreferences prefs = await _prefs;
    final String mqttHost = prefs.getString('mqtt.host') ?? "";
    final int mqttPort = prefs.getInt("mqtt.port") ?? 1883;
    final String mqttTopic = prefs.getString("mqtt.topic") ?? "/binkyrailways";
    setState(() {
      _mqttHostController.text = mqttHost;
      _mqttPortController.text = mqttPort.toString();
      _mqttTopicController.text = mqttTopic;
      _validateFieldValues();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Text("Create connection"),
            new Container(child: new Icon(Icons.wifi), margin: new EdgeInsets.symmetric(horizontal: 5.0)),
          ]),
       ),
      body: _connecting ? new Center(child: new Text("Connecting ...")) : _buildTextComposer(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: _inputValid ? _handleConnect : null,
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Form(
          child: new Column(
            children: <Widget>[
              new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: new TextField(
                    controller: _mqttHostController,
                    onChanged: (x) => _validateFieldValues(),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    //obscureText: true,
                    inputFormatters: [],
                    decoration:
                        new InputDecoration(labelText: "MQTT Host", hintText: "host name or IP address"),
                  )),
              new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: new TextField(
                    controller: _mqttPortController,
                    onChanged: (x) => _validateFieldValues(),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    inputFormatters: [],
                    decoration:
                        new InputDecoration(labelText: "MQTT Port", hintText: "1883"),
                  )),
              new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: new TextField(
                    controller: _mqttTopicController,
                    onChanged: (x) => _validateFieldValues(),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    //obscureText: true,
                    inputFormatters: [],
                    decoration:
                        new InputDecoration(labelText: "MQTT topic", hintText: "/binkyrailways"),
                  )),
            ],
          ),
        ));
  }

  void _validateFieldValues() {
    var host = _mqttHostController.text;
    var port = _mqttPortController.text;
    var topic = _mqttTopicController.text;
    var portNum = int.parse(port, onError: (source) => null);
    var isValid = (host != "") && (topic != "") && (portNum != null);
    setState(() => _inputValid = isValid);
  }

  Future<Null> _handleConnect() async {
    var host = _mqttHostController.text;
    var port = _mqttPortController.text;
    var topic = _mqttTopicController.text;
    var portNum = int.parse(port, onError: (source) => null);
    if ((host != "") && (topic != "") && (portNum != null)) {
      setState(() => _connecting = true);
      try{
        var client = await ServerClient.connect(host, portNum, topic);
        _connected(client);
        // Save preferences
        final SharedPreferences prefs = await _prefs;
        prefs.setString('mqtt.host', host);
        prefs.setInt("mqtt.port", portNum);
        prefs.setString("mqtt.topic", topic);
      } catch(e) {
        setState(() => _connecting = false);
      }
    }
  }
}
