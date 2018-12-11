import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin_market/model/details_view.model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin_market/widgets/price_change.widget.dart';


class CoinInformation extends StatefulWidget {

  final DetailsCoinInformation information;

  CoinInformation({Key key, this.information}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CoinInformationState(information: information);
  }

}

class CoinInformationState extends State<CoinInformation> {

  DetailsCoinInformation information;

  CoinInformationState({this.information});

  update(DetailsCoinInformation information) {
    setState(() {
      this.information = information;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: information.imageUrl,
              height: 30.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${information.formattedPrice}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            PriceChange(
              change: information.priceChange,
              price: information.formattedPriceChange,
            ),
          ],
        ),
      ),
    );
  }
}