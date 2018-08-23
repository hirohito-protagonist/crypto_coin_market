import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'crypto_compare.service.dart';
import 'model/total_volume.model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crypto Coin Market',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Crypto Coin Market'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: FutureBuilder<http.Response>(
        future: volumeData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final response = json.decode(snapshot.data.body);

            final items = List.of(response['Data'].map((item) => TotalVolume.fromJson(item)));

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Text('${index + 1} ${items[index].coinInfo.name}');
              },
            );
          }
          return CircularProgressIndicator();
        }),
    );
  }
}
