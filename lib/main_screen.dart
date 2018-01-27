import 'package:flutter/material.dart';
import 'connect_screen.dart';
import 'railway_screen.dart';
import 'server_client.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

enum MainScreenViewState { connect, main }

class MainScreenState extends State<MainScreen> {
  MainScreenViewState _viewState = MainScreenViewState.connect;
  ServerClient _client;

  @override
  Widget build(BuildContext context) {
    switch (_viewState) {
      case MainScreenViewState.connect:
        return new ConnectScreen(_onConnected);
      default:
        return new RailwayScreen(_client, _onConnectionSettings);
    }
  }

  void _onConnected(ServerClient client) {
    setState(() {
      _viewState = MainScreenViewState.main;
      _client = client;
    });
  }

  void _onConnectionSettings() {
    setState(() {
      _viewState = MainScreenViewState.connect;
      _client = null;
    });
  }
}
