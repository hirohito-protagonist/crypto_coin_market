import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/views/markets.view.dart';
import 'package:crypto_coin_market/widgets/coin_list_tile.widget.dart';

void main() => runApp(new MarketsPage());

class MarketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crypto Coin Market',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MarketsView(
        title: 'Crypto Coin Market',
        onSelect: (context, data) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(
              data: data,
            )),
          );
        }
      ),
    );
  }
}


class DetailPage extends StatelessWidget {

  final Map<String, dynamic> data;

  DetailPage({ Key key, @required this.data}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail information'),
      ),
      body: new CoinListTile(
        imageUrl: data['imageUrl'],
        name: data['name'],
        fullName: data['fullName'],
        formattedPrice: data['formattedPrice'],
        formattedPriceChange: data['formattedPriceChange'],
        priceChange: data['priceChange'],
      ),
    );
  }
}

