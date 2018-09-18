import 'package:flutter/material.dart';
import 'package:crypto_coin_market/views/markets.view.dart';
import 'package:crypto_coin_market/views/details.view.dart';

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
            MaterialPageRoute(builder: (context) => DetailsView(
              title: 'Detail information',
              data: data,
            )),
          );
        }
      ),
    );
  }
}