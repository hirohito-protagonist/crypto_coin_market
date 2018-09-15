import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/views/markets.view.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                CachedNetworkImage(
                  placeholder: CircularProgressIndicator(),
                  imageUrl: data['imageUrl'],
                  height: 100.0,
                ),
                Text(data['fullName']),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '1 ${data['name']} = ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      ),
                    ),
                    Text(
                      '${data['formattedPrice']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      data['formattedPriceChange'] == '' ? '' : '${data['formattedPriceChange']}%',
                      style: TextStyle(
                        color: data['priceChange'] == 0 ? Colors.black : data['priceChange'] > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

