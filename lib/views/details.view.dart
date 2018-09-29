import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/currency.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';
import 'package:crypto_coin_market/crypto_compare.service.dart';

class DetailsView extends StatefulWidget {
  final String title;
  final Map<String, dynamic> data;

  DetailsView({Key key, @required this.title, @required this.data})
      : super(key: key);

  @override
  _DetailsView createState() => _DetailsView();
}

class _DetailsView extends State<DetailsView> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Null> updateData() async {
    final currency = widget.data['coinInformation']['name'];
    final prices = await allPriceMultiFull(http.Client(), [currency], Currency.fromCurrencyCode(widget.data['currency']));
    setState(() {
      final displayPriceNode = prices.display.containsKey(currency) ? prices.display[currency] : null;
      final rawPriceNode = prices.raw.containsKey(currency) ? prices.raw[currency] : null;
      widget.data['coinInformation']['formattedPrice'] = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['PRICE'] : '';
      widget.data['coinInformation']['formattedPriceChange'] = displayPriceNode != null ? Map.of(displayPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : '';
      widget.data['coinInformation']['priceChange'] = rawPriceNode != null ? Map.of(rawPriceNode).values.toList()[0]['CHANGEPCT24HOUR'] : 0;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data['coinInformation'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _refreshKey.currentState.show();
              ;
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        child: Container(
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
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      Text(
                        '${data['formattedPrice']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
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
        onRefresh: updateData,
      ),
    );
  }
}
