import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt/mqtt_shared.dart';
import 'package:mqtt/mqtt_connection_io_socket.dart';

class ServerClient {
  MqttClient<MqttConnectionIOSocket> _client;
  String _topic;
  Stream<dynamic> _messages;

  ServerClient(this._client, this._topic, this._messages);

  static Future<ServerClient> connect(String host, int port, String topic) async {
    var clientID = "foo";
    var conn = new MqttConnectionIOSocket.setOptions(host: host, port: port);
    var client = new MqttClient<MqttConnectionIOSocket>(conn, clientID: clientID);

    try {
      var controller = new StreamController<dynamic>();
      await client.connect(() {
        print("MQTT connection lost");
        controller.close();
      });
      client.subscribe(topic + "/data", QOS_0, (t, d) {
        var msg = JSON.decode(d);
        //print("topic: $t, data: $msg");
        controller.add(msg);
      }); 
      return new ServerClient(client, topic, controller.stream);
    } catch (Exception) {
      /// Error handling.....
      client.disconnect();
      rethrow;
    }
  }

  Stream<dynamic> get messages => _messages;

  publishControlMessage(dynamic msg) async {
    var payload = JSON.encode(msg);
    _client.publish(_topic + "/control", payload);
  }
}
