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
      body: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor), //new
        child: new Form(
          child: new Column(
            children: <Widget>[
              new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: new TextField(
                    controller: _mqttHostController,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    //obscureText: true,
                    inputFormatters: [],
                    decoration:
                        new InputDecoration.collapsed(hintText: "MQTT Address"),
                  )),
              new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: new TextField(
                    controller: _mqttPortController,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    inputFormatters: [],
                    decoration:
                        new InputDecoration.collapsed(hintText: "MQTT Port"),
                  )),
              new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  child: new TextField(
                    controller: _mqttTopicController,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    //obscureText: true,
                    inputFormatters: [],
                    decoration:
                        new InputDecoration.collapsed(hintText: "MQTT Topic"),
                  )),
              new Container(
                margin:
                    new EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                child: new RaisedButton(
                    child: new Text("Connect"),
                    onPressed: () => _handleConnect(
                        _mqttHostController.text, _mqttPortController.text, _mqttTopicController.text)),
              )
            ],
          ),
        ));
  }

  Future<Null> _handleConnect(String host, String port, String topic) async {
    debugPrint(host + ":" + port);
    var portNum = int.parse(port);
    var client = await ServerClient.connect(host, portNum, topic);
    _connected(client);
    // Save preferences
    final SharedPreferences prefs = await _prefs;
    prefs.setString('mqtt.host', host);
    prefs.setInt("mqtt.port", portNum);
    prefs.setString("mqtt.topic", topic);
  }
}
