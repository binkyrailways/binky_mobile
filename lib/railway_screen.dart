import 'dart:async';
import 'package:flutter/material.dart';
import 'connect_screen.dart';
import 'server_client.dart';

class RailwayScreen extends StatefulWidget {
  final ServerClient _client;

  RailwayScreen(this._client);

  @override
  State createState() => new RailwayScreenState(_client);
}

enum RailwayScreenViewState { editing, running }

class RailwayScreenState extends State<RailwayScreen> {
  final ServerClient _client;
  RailwayScreenViewState _viewState = RailwayScreenViewState.editing;

  RailwayScreenState(this._client) {
    processMessages();
  }

  Future<Null> processMessages() async {
    await for (var msg in _client.messages) {
      var msgType = msg["type"];
      print("msg type: $msgType");
      switch (msgType) {
        case "editing":
          setState(() => _viewState = RailwayScreenViewState.editing);
          break;
        case "running":
          setState(() => _viewState = RailwayScreenViewState.running);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_viewState) {
      case RailwayScreenViewState.editing:
        return new Scaffold(
          appBar: new AppBar(title: new Text("BinkyRailways")),
          body: new Center(child: new Text("Editing...")),
        );
      default:
        return new Scaffold(
          appBar: new AppBar(title: new Text("BinkyRailways")),
          body: new Center(child: new Text("Running")),
        );
    }
  }
}
