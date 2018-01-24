import 'package:flutter/material.dart';
import 'connect_screen.dart';
import 'main_screen.dart';

class BinkyMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "BinkyRailways",
      home: new MainScreen(),
      routes: <String, WidgetBuilder>{
         '/connect': (BuildContext context) => new ConnectScreen(),
      },
    );
  }
}
