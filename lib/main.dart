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

  MarketsViewModel data;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<Null> refreshList() async {
    MarketsViewModel market = await marketData();

    setState(() {
      data = market;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemCount: data?.volume?.length,
          itemBuilder: (context, i) {

            final currency = data.volume[i].coinInfo.name;
            final displayPriceNode = data.prices.display.containsKey(currency) ? data.prices.display[currency] : null;
            final rawPriceNode = data.prices.raw.containsKey(currency) ? data.prices.raw[currency] : null;
            final price = displayPriceNode != null ? displayPriceNode['USD']['PRICE'] : '';
            final priceChangeDisplay = displayPriceNode != null ? displayPriceNode['USD']['CHANGEPCT24HOUR'] : '';
            final priceChange = rawPriceNode != null ? rawPriceNode['USD']['CHANGEPCT24HOUR'] : 0;

            return new Card(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: CachedNetworkImage(
                      placeholder: CircularProgressIndicator(),
                      imageUrl: data.volume[i].coinInfo.imageUrl,
                      height: 30.0,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.volume[i].coinInfo.fullName}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                '${currency}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${priceChangeDisplay}%',
                              style: TextStyle(
                                color: priceChange == 0 ? Colors.black : priceChange > 0 ? Colors.green : Colors.red,
                              ),
                            ),
                            Text('${price}'),
                          ],
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        onRefresh: refreshList,
      ),
    );
  }
}
