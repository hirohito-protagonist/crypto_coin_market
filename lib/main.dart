import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'crypto_compare.service.dart';
import 'model/total_volume.model.dart';
import 'model/markets_view.model.dart';

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

Future<MarketsViewModel> marketData() async {

  final volume =  await volumeData(http.Client());
  final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
  final prices = await allPriceMultiFull(http.Client(), coins);

  return MarketsViewModel(
    prices: prices,
    volume: volume,
  );
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
      body: FutureBuilder<MarketsViewModel>(
        future: marketData(),
        builder: (context, snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default: {

              final items  = snapshot.data.volume;
              final prices = snapshot.data.prices;

              return ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (context, index) {

                  final currency = items[index].coinInfo.name;
                  final priceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
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
                          title: new Text('${currency}'),
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
