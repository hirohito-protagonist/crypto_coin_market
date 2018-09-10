import 'package:flutter/material.dart';
import 'views/markets.view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crypto Coin Market',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MarketsView(title: 'Crypto Coin Market'),
    );
  }
}