import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      body: FutureBuilder<List<TotalVolume>>(
        future: volumeData(http.Client()),
        builder: (context, snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default: {

              final items  = snapshot.data;

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Text('${index + 1}'),
                        CachedNetworkImage(
                          placeholder: CircularProgressIndicator(),
                          imageUrl: items[index].coinInfo.imageUrl,
                          height: 30.0,
                        ),
                        Text('${items[index].coinInfo.name}'),
                      ],
                    ),
                  );
                },
              );
            }
          }
        }),
    );
  }
}
