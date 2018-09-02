import 'dart:async';
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

Future<dynamic> marketData() async {

  final volume =  await volumeData(http.Client());
  final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
  final prices = await allPriceMultiFull(http.Client(), coins);

  return {
    'volume': volume,
    'prices': prices
  };
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: FutureBuilder<dynamic>(
        future: marketData(),
        builder: (context, snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default: {
              print(snapshot.data['volume']);

              final items  = snapshot.data['volume'];
              final prices = snapshot.data['prices'];

              return ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (context, index) {

                  final priceNode = prices['DISPLAY'][items[index].coinInfo.name];
                  final price = priceNode != null ? priceNode['USD']['PRICE'] : '';

                  return new Card(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ListTile(
                          leading: CachedNetworkImage(
                            placeholder: CircularProgressIndicator(),
                            imageUrl: items[index].coinInfo.imageUrl,
                            height: 30.0,
                          ),
                          title: new Text('${items[index].coinInfo.name}'),
                          subtitle: new Text('${price}'),
                        ),
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
