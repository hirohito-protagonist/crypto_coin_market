import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';


class DetailsView extends StatefulWidget {

  final String title;
  final Map<String, dynamic> data;

  DetailsView({Key key, @required this.title, @required this.data}) : super(key: key);

  @override
  _DetailsView createState() => _DetailsView();

}

class _DetailsView extends State<DetailsView> {

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                    PriceChange(
                      change: data['priceChange'],
                      price: data['formattedPriceChange'],
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